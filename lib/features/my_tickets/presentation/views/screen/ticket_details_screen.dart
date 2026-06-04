import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/my_tickets_states.dart';
import 'package:transportation_app/features/my_tickets/presentation/views/widgets/boarding_pass_sheet.dart';
import 'package:transportation_app/features/profile/domain/entities/ticket_entity.dart';
import 'package:transportation_app/core/helper/extensions.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class TicketDetailsScreen extends StatefulWidget {
  final TicketEntity ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  late TicketEntity _ticket;

  Color get _statusColor {
    if (_ticket.refundStatus == 'Accepted' ||
        _ticket.refundStatus == 'Approved' ||
        _ticket.status.toLowerCase() == 'cancelled') {
      return Colors.red;
    }
    if (_ticket.status.toLowerCase() == 'completed') {
      return ColorsManager.brightBlue;
    }
    return ColorsManager.successGreen;
  }

  String _getLocalizedStatus(AppLocalizations l10n, String status) {
    if (_ticket.refundStatus == 'Accepted' ||
        _ticket.refundStatus == 'Approved') {
      return l10n.statusCancelled;
    }
    switch (status.toLowerCase()) {
      case 'confirmed':
        return l10n.statusConfirmed;
      case 'pending':
        return l10n.statusPending;
      case 'completed':
        return l10n.statusCompleted;
      case 'cancelled':
        return l10n.statusCancelled;
      default:
        return status;
    }
  }

  @override
  void initState() {
    super.initState();
    _ticket = widget.ticket;
  }

  /// Shows the confirmation dialog and returns true when the user confirms.
  Future<bool> _showRefundConfirmDialog(AppLocalizations l10n) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: Colors.orange,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.refundConfirmTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.refundConfirmBody,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white30),
              foregroundColor: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<MyTicketsCubit, MyTicketsState>(
      listenWhen: (_, state) =>
          state is RefundRequestedState || state is RefundRequestErrorState,
      listener: (context, state) {
        if (state is RefundRequestedState) {
          // Optimistically mark refund as requested so the button disables
          setState(() {
            _ticket = TicketEntity(
              bookingId: _ticket.bookingId,
              userId: _ticket.userId,
              status: _ticket.status,
              paymentStatus: _ticket.paymentStatus,
              totalPrice: _ticket.totalPrice,
              seatsBooked: _ticket.seatsBooked,
              bookingDate: _ticket.bookingDate,
              agencyName: _ticket.agencyName,
              agencyNameAr: _ticket.agencyNameAr,
              className: _ticket.className,
              classNameAr: _ticket.classNameAr,
              originGovernorate: _ticket.originGovernorate,
              originGovernorateAr: _ticket.originGovernorateAr,
              originStation: _ticket.originStation,
              originStationNameAr: _ticket.originStationNameAr,
              destinationGovernorate: _ticket.destinationGovernorate,
              destinationGovernorateAr: _ticket.destinationGovernorateAr,
              destinationStation: _ticket.destinationStation,
              destinationStationNameAr: _ticket.destinationStationNameAr,
              boardingTime: _ticket.boardingTime,
              dropoffTime: _ticket.dropoffTime,
              isMarketplacePurchase: _ticket.isMarketplacePurchase,
              isOfferedForResale: _ticket.isOfferedForResale,
              marketplaceListingId: _ticket.marketplaceListingId,
              passengers: _ticket.passengers,
              refundStatus: 'Requested',
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.refundSubmitted),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else if (state is RefundRequestErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isRequesting = state is RefundRequestingState;

        // Show refund button only for confirmed upcoming trips
        // Disabled when: refund already in progress/accepted, ticket is listed
        // on the marketplace, or it was purchased from the marketplace.
        final canRequestRefund =
            _ticket.boardingTime.isAfter(DateTime.now()) &&
            (_ticket.status == 'Confirmed' || _ticket.refundStatus != null) &&
            !_ticket.isMarketplacePurchase;

        // Locked because the ticket is currently listed for resale
        final isLockedByResale = _ticket.isOfferedForResale;

        return Scaffold(
          backgroundColor: ColorsManager.darkBlue,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: ColorsManager.accentCyan,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              l10n.ticketDetails,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── General Trip Info Card ──────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsManager.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.07),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.isArabic
                                ? (_ticket.agencyNameAr ?? _ticket.agencyName)
                                : _ticket.agencyName,
                            style: const TextStyle(
                              color: ColorsManager.accentCyan,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _statusColor.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              _getLocalizedStatus(l10n, _ticket.status),
                              style: TextStyle(
                                color: _statusColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.ticketClass(
                          context.isArabic
                              ? (_ticket.classNameAr ?? _ticket.className)
                              : _ticket.className,
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.from,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  (_ticket.originGovernorateAr ??
                                          _ticket.originGovernorate)
                                      .toLocalizedGov(context),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  (context.isArabic
                                          ? (_ticket.originStationNameAr ??
                                                _ticket.originStation)
                                          : _ticket.originStation)
                                      .toLocalizedStation(context),
                                  style: const TextStyle(
                                    color: ColorsManager.accentCyan,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: ColorsManager.accentCyan,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  l10n.to,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  (_ticket.destinationGovernorateAr ??
                                          _ticket.destinationGovernorate)
                                      .toLocalizedGov(context),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  (context.isArabic
                                          ? (_ticket.destinationStationNameAr ??
                                                _ticket.destinationStation)
                                          : _ticket.destinationStation)
                                      .toLocalizedStation(context),
                                  style: const TextStyle(
                                    color: ColorsManager.accentCyan,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: ColorsManager.accentCyan,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.departure,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Text(
                          DateFormat(
                            'yyyy-MM-dd hh:mm a',
                          ).format(_ticket.boardingTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: ColorsManager.accentCyan,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.arrival,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Text(
                          DateFormat(
                            'yyyy-MM-dd hh:mm a',
                          ).format(_ticket.dropoffTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.white12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.bookingRef,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'REF-${_ticket.bookingId}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Refund Button ───────────────────────────────────
                if (canRequestRefund) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _RefundButton(
                      l10n: l10n,
                      isRequesting: isRequesting,
                      refundStatus: _ticket.refundStatus,
                      isLockedByResale: isLockedByResale,
                      onPressed: () async {
                        final confirmed = await _showRefundConfirmDialog(l10n);
                        if (confirmed && context.mounted) {
                          context.read<MyTicketsCubit>().requestRefund(
                            bookingId: _ticket.bookingId,
                          );
                        }
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                Text(
                  l10n.passengersAndSeats,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.tapPassengerInfo,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 16),
                ..._ticket.passengers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final p = entry.value;
                  return GestureDetector(
                    onTap: () =>
                        showBoardingPassSheet(context, _ticket, p, index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ColorsManager.surfaceMid,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Index bubble
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: ColorsManager.accentCyan.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorsManager.accentCyan.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: ColorsManager.accentCyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Name / ID / Seat tag
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (p.name.isNotEmpty)
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                if (p.idNumber.isNotEmpty)
                                  Text(
                                    l10n.idNum(p.idNumber),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                if (p.seatNumber.isNotEmpty) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorsManager.accentCyan
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorsManager.accentCyan
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      l10n.seatNum(p.seatNumber),
                                      style: const TextStyle(
                                        color: ColorsManager.accentCyan,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // QR icon placeholder
                          const Icon(
                            Icons.qr_code_2_rounded,
                            size: 40,
                            color: Colors.white38,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.chevron_right,
                            color: Colors.white24,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Isolated widget for the refund button to keep build() clean.
class _RefundButton extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isRequesting;
  final String? refundStatus;

  /// True when the ticket is currently listed on the resale marketplace.
  final bool isLockedByResale;
  final VoidCallback onPressed;

  const _RefundButton({
    required this.l10n,
    required this.isRequesting,
    this.refundStatus,
    this.isLockedByResale = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasStatus =
        refundStatus == 'Requested' ||
        refundStatus == 'Accepted' ||
        refundStatus == 'Approved' ||
        refundStatus == 'Rejected';
    final isDisabled = hasStatus || isRequesting || isLockedByResale;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: isDisabled
            ? null
            : const LinearGradient(
                colors: [Color(0xFFFF8C00), Color(0xFFFF5500)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDisabled ? Colors.white12 : null,
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isDisabled ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isRequesting) ...[
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.refundRequesting,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ] else if (refundStatus == 'Accepted' ||
                    refundStatus == 'Approved') ...[
                  const Icon(
                    Icons.check_circle,
                    color: ColorsManager.successGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.refundAccepted,
                    style: const TextStyle(
                      color: ColorsManager.successGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ] else if (refundStatus == 'Rejected') ...[
                  const Icon(Icons.cancel, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.refundRejected,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ] else if (refundStatus == 'Requested') ...[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white54,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.refundAlreadyRequested,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ] else if (isLockedByResale) ...[
                  const Icon(Icons.storefront, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.listedOnMarketplace,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.requestRefund,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
