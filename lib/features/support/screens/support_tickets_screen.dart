import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/utils/error_localizer.dart';
import 'package:transportation_app/features/support/cubit/support_tickets_cubit.dart';
import 'package:transportation_app/features/support/domain/entities/support_ticket_entity.dart';

class SupportTicketsScreen extends StatelessWidget {
  const SupportTicketsScreen({super.key});

  Future<void> _refresh(BuildContext context) {
    return context.read<SupportTicketsCubit>().loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: ColorsManager.searchBg,
      appBar: AppBar(
        backgroundColor: ColorsManager.searchBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.supportTickets,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<SupportTicketsCubit, SupportTicketsState>(
          builder: (context, state) {
            if (state is SupportTicketsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.accentCyan,
                  strokeWidth: 2.5,
                ),
              );
            }

            if (state is SupportTicketsError) {
              return _SupportTicketsErrorView(
                message: ErrorLocalizer.localize(context, state.message),
                onRetry: () => _refresh(context),
                retryLabel: l10n.retry,
              );
            }

            if (state is SupportTicketsLoaded) {
              return RefreshIndicator(
                color: ColorsManager.accentCyan,
                backgroundColor: ColorsManager.cardBg,
                onRefresh: () => _refresh(context),
                child: state.tickets.isEmpty
                    ? _EmptySupportTicketsView(
                        title: l10n.noSupportTickets,
                        body: l10n.supportTicketsEmptyBody,
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: state.tickets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) =>
                            _SupportTicketCard(ticket: state.tickets[index]),
                      ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SupportTicketCard extends StatelessWidget {
  final SupportTicketEntity ticket;

  const _SupportTicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final title = _localizedValue(
      isArabic: isArabic,
      localized: ticket.titleAr,
      original: ticket.title,
    );
    final description = _localizedValue(
      isArabic: isArabic,
      localized: ticket.descriptionAr,
      original: ticket.description,
    );
    final category = _localizedValue(
      isArabic: isArabic,
      localized: ticket.categoryAr,
      original: ticket.category,
    );
    final status = _localizedValue(
      isArabic: isArabic,
      localized: ticket.statusAr,
      original: ticket.status,
    );
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _TicketIdBadge(ticketId: ticket.ticketId),
              _StatusTag(status: status, statusKey: ticket.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title.isEmpty ? l10n.untitledTicket : title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            description.isEmpty ? l10n.noDescriptionProvided : description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.64),
              fontSize: 13,
              height: 1.45,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _CategoryTag(category: category, categoryKey: ticket.category),
              _CreatedDateLabel(createdAt: ticket.createdAt),
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketIdBadge extends StatelessWidget {
  final int ticketId;

  const _TicketIdBadge({required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: ColorsManager.accentCyan.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorsManager.accentCyan.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        '#$ticketId',
        style: const TextStyle(
          color: ColorsManager.accentCyan,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String category;
  final String categoryKey;

  const _CategoryTag({required this.category, required this.categoryKey});

  Color get _color {
    switch (categoryKey.toLowerCase()) {
      case 'payment':
        return const Color(0xFFFFB74D);
      case 'tripexperience':
      case 'trip experience':
        return ColorsManager.accentCyan;
      case 'appbug':
      case 'app bug':
        return const Color(0xFFFF6B6B);
      case 'accountissue':
      case 'account issue':
        return const Color(0xFFB388FF);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PillTag(
      label: _readable(category),
      color: _color,
      icon: Icons.label_outline,
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String status;
  final String statusKey;

  const _StatusTag({required this.status, required this.statusKey});

  Color get _color {
    switch (statusKey.toLowerCase()) {
      case 'open':
        return ColorsManager.accentCyan;
      case 'inprogress':
      case 'in progress':
        return const Color(0xFFFFD54F);
      case 'resolved':
        return ColorsManager.successGreen;
      case 'closed':
        return const Color(0xFF90A4AE);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PillTag(
      label: _readable(status),
      color: _color,
      icon: Icons.flag_outlined,
    );
  }
}

class _PillTag extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _PillTag({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatedDateLabel extends StatelessWidget {
  final DateTime createdAt;

  const _CreatedDateLabel({required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.schedule_outlined, color: Colors.white38, size: 14),
        const SizedBox(width: 5),
        Text(
          _formatDate(createdAt),
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _SupportTicketsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

  const _SupportTicketsErrorView({
    required this.message,
    required this.onRetry,
    required this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white38, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.accentCyan,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySupportTicketsView extends StatelessWidget {
  final String title;
  final String body;

  const _EmptySupportTicketsView({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(
          Icons.support_agent_rounded,
          color: Colors.white24,
          size: 56,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

String _formatDate(DateTime value) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day ${months[local.month - 1]} ${local.year}, $hour:$minute';
}

String _readable(String value) {
  if (value.trim().isEmpty) return 'Other';
  final spaced = value
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll('_', ' ')
      .trim();
  return spaced[0].toUpperCase() + spaced.substring(1);
}

String _localizedValue({
  required bool isArabic,
  required String? localized,
  required String original,
}) {
  if (isArabic && localized != null && localized.trim().isNotEmpty) {
    return localized.trim();
  }
  return original.trim();
}
