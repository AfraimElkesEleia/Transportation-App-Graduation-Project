import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:transportation_app/core/di/injection_container.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/passenger_boarding_pass_cubit.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';

/// Shows the boarding pass bottom sheet for a specific passenger.
void showBoardingPassSheet(
  BuildContext context,
  TicketEntity ticket,
  TicketPassengerEntity passenger,
  int passengerIndex,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (_) =>
          sl<PassengerBoardingPassCubit>()
            ..fetchQrPayload(ticket.bookingId, passenger.passengerId),
      child: _BoardingPassSheet(
        ticket: ticket,
        passenger: passenger,
        passengerIndex: passengerIndex,
      ),
    ),
  );
}

class _BoardingPassSheet extends StatefulWidget {
  final TicketEntity ticket;
  final TicketPassengerEntity passenger;
  final int passengerIndex;

  const _BoardingPassSheet({
    required this.ticket,
    required this.passenger,
    required this.passengerIndex,
  });

  @override
  State<_BoardingPassSheet> createState() => _BoardingPassSheetState();
}

class _BoardingPassSheetState extends State<_BoardingPassSheet> {
  final GlobalKey _qrKey = GlobalKey();

  String _fmt12(DateTime dt) => DateFormat('hh:mm a').format(dt);
  String _fmtDate(DateTime dt) => DateFormat('dd MMM yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    final t = widget.ticket;
    final p = widget.passenger;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: ColorsManager.darkBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Header row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Boarding Pass',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'REF-${t.bookingId}-P${p.passengerId}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Scrollable content
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // ── Route card ─────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D2340), Color(0xFF0A3060)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      children: [
                        // Origin → Destination
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Origin
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _originCode(
                                        context.isArabic
                                            ? (t.originGovernorateAr ??
                                                  t.originGovernorate)
                                            : t.originGovernorate,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Text(
                                      context.isArabic
                                          ? (t.originGovernorateAr ??
                                                t.originGovernorate)
                                          : t.originGovernorate,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (t.originStation.isNotEmpty)
                                      Text(
                                        context.isArabic
                                            ? (t.originStationNameAr ??
                                                  t.originStation)
                                            : t.originStation,
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    Text(
                                      _fmt12(t.boardingTime),
                                      style: const TextStyle(
                                        color: ColorsManager.accentCyan,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Center timeline
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      _duration(t.boardingTime, t.dropoffTime),
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: ColorsManager.accentCyan,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Container(
                                          width: 60,
                                          height: 1,
                                          color: Colors.white24,
                                        ),
                                        const Icon(
                                          Icons.train,
                                          color: Colors.white38,
                                          size: 18,
                                        ),
                                        Container(
                                          width: 60,
                                          height: 1,
                                          color: Colors.white24,
                                        ),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: ColorsManager.accentCyan,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      context.isArabic
                                          ? (t.agencyNameAr ?? t.agencyName)
                                          : t.agencyName,
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Destination
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _originCode(
                                        context.isArabic
                                            ? (t.destinationGovernorateAr ??
                                                  t.destinationGovernorate)
                                            : t.destinationGovernorate,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    Text(
                                      context.isArabic
                                          ? (t.destinationGovernorateAr ??
                                                t.destinationGovernorate)
                                          : t.destinationGovernorate,
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (t.destinationStation.isNotEmpty)
                                      Text(
                                        context.isArabic
                                            ? (t.destinationStationNameAr ??
                                                  t.destinationStation)
                                            : t.destinationStation,
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    Text(
                                      _fmt12(t.dropoffTime),
                                      style: const TextStyle(
                                        color: ColorsManager.accentCyan,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Dashed divider
                        _DashedDivider(),
                        // Passenger info + QR
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Passenger info row ──────────────
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'PASSENGER',
                                          style: TextStyle(
                                            color: Colors.white38,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          p.name.isNotEmpty ? p.name : '—',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (p.idNumber.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'ID: ${p.idNumber}',
                                            style: const TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // ── Seat / Class / Date chips ────────
                              Row(
                                children: [
                                  _InfoChip(
                                    label: 'SEAT',
                                    value: p.seatNumber.isNotEmpty
                                        ? p.seatNumber
                                        : '—',
                                    valueColor: Colors.white,
                                  ),
                                  const SizedBox(width: 16),
                                  _InfoChip(
                                    label: 'CLASS',
                                    value: t.className.isNotEmpty
                                        ? t.className
                                        : '—',
                                    valueColor: ColorsManager.accentCyan,
                                  ),
                                  const SizedBox(width: 16),
                                  _InfoChip(
                                    label: 'DATE',
                                    value: _fmtDate(t.boardingTime),
                                    valueColor: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // ── Full-width QR code ───────────────
                              BlocBuilder<
                                PassengerBoardingPassCubit,
                                PassengerBoardingPassState
                              >(
                                builder: (_, state) {
                                  if (state is PassengerBoardingPassLoading) {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: ColorsManager.accentCyan,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  } else if (state
                                      is PassengerBoardingPassLoaded) {
                                    return RepaintBoundary(
                                      key: _qrKey,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: QrImageView(
                                          data: state.qrPayload,
                                          version: QrVersions.auto,
                                          size: 220,
                                          eyeStyle: const QrEyeStyle(
                                            eyeShape: QrEyeShape.square,
                                            color: Colors.black,
                                          ),
                                          dataModuleStyle:
                                              const QrDataModuleStyle(
                                                dataModuleShape:
                                                    QrDataModuleShape.square,
                                                color: Colors.black,
                                              ),
                                        ),
                                      ),
                                    );
                                  } else if (state
                                      is PassengerBoardingPassError) {
                                    return Container(
                                      height: 120,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 36,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox(height: 120);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            // ── Bottom action bar ─────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                8,
                16,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        BlocBuilder<
                          PassengerBoardingPassCubit,
                          PassengerBoardingPassState
                        >(
                          builder: (_, state) {
                            final qrPayload =
                                state is PassengerBoardingPassLoaded
                                ? state.qrPayload
                                : null;
                            return _DownloadButton(
                              enabled: qrPayload != null,
                              onTap: () => _printPdf(context, qrPayload!),
                            );
                          },
                        ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<
                    PassengerBoardingPassCubit,
                    PassengerBoardingPassState
                  >(
                    builder: (_, state) {
                      final qrPayload = state is PassengerBoardingPassLoaded
                          ? state.qrPayload
                          : null;
                      return _ShareButton(
                        enabled: qrPayload != null,
                        onTap: () {
                          if (qrPayload != null) {
                            Clipboard.setData(ClipboardData(text: qrPayload));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('QR payload copied'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _printPdf(BuildContext context, String qrPayload) async {
    final t = widget.ticket;
    final p = widget.passenger;
    final pdf = pw.Document();

    // Generate QR image bytes
    final qrImage = await _generateQrImage(qrPayload);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'BOARDING PASS',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      t.agencyName,
                      style: const pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  'REF-${t.bookingId}',
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Divider(),
            pw.SizedBox(height: 16),
            // Route
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      _originCode(
                        context.isArabic
                            ? (t.originGovernorateAr ?? t.originGovernorate)
                            : t.originGovernorate,
                      ),
                      style: pw.TextStyle(
                        fontSize: 36,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(t.originGovernorate),
                    if (t.originStation.isNotEmpty)
                      pw.Text(
                        t.originStation,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                    pw.Text(
                      _fmt12(t.boardingTime),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  '→',
                  style: const pw.TextStyle(
                    fontSize: 28,
                    color: PdfColors.grey,
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      _originCode(
                        context.isArabic
                            ? (t.destinationGovernorateAr ??
                                  t.destinationGovernorate)
                            : t.destinationGovernorate,
                      ),
                      style: pw.TextStyle(
                        fontSize: 36,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(t.destinationGovernorate),
                    if (t.destinationStation.isNotEmpty)
                      pw.Text(
                        t.destinationStation,
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                      ),
                    pw.Text(
                      _fmt12(t.dropoffTime),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Divider(),
            pw.SizedBox(height: 16),
            // Passenger + QR
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'PASSENGER',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        p.name.isNotEmpty ? p.name : '—',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (p.idNumber.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'ID: ${p.idNumber}',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                      pw.SizedBox(height: 16),
                      pw.Row(
                        children: [
                          _pdfChip(
                            'SEAT',
                            p.seatNumber.isNotEmpty ? p.seatNumber : '—',
                          ),
                          pw.SizedBox(width: 16),
                          _pdfChip(
                            'CLASS',
                            t.className.isNotEmpty ? t.className : '—',
                          ),
                          pw.SizedBox(width: 16),
                          _pdfChip('DATE', _fmtDate(t.boardingTime)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (qrImage != null)
                  pw.Image(pw.MemoryImage(qrImage), width: 120, height: 120),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.Divider(),
            pw.SizedBox(height: 8),
            pw.Text(
              'Generated by TransportApp • ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey400),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: 'boarding-pass-${p.name.replaceAll(' ', '_')}.pdf',
    );
  }

  Future<Uint8List?> _generateQrImage(String data) async {
    try {
      final qrPainter = QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: true,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF000000),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF000000),
        ),
      );
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 300, 300));
      qrPainter.paint(canvas, const Size(300, 300));
      final picture = recorder.endRecording();
      final image = await picture.toImage(300, 300);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  pw.Widget _pdfChip(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  String _originCode(String city) {
    if (city.length < 3) return city.toUpperCase();
    return city.substring(0, 3).toUpperCase();
  }

  String _duration(DateTime from, DateTime to) {
    final diff = to.difference(from);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    return '${h}h ${m}m';
  }
}

// ── Helper widgets ─────────────────────────────────────────────────

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              margin: const EdgeInsets.only(right: dashSpace),
              color: Colors.white12,
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _DownloadButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
                  colors: [ColorsManager.accentCyan, Color(0xFF00BFA5)],
                )
              : null,
          color: enabled ? null : Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_rounded,
              color: enabled ? Colors.black : Colors.white38,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Download PDF',
              style: TextStyle(
                color: enabled ? Colors.black : Colors.white38,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _ShareButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.share_rounded,
          color: enabled ? Colors.white : Colors.white24,
          size: 20,
        ),
      ),
    );
  }
}
