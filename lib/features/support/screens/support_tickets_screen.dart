import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
              _StatusTag(ticket: ticket),
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
              _CategoryTag(ticket: ticket),
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
  final SupportTicketEntity ticket;

  const _CategoryTag({required this.ticket});

  Color get _color {
    switch (ticket.categoryKey) {
      case 'payment':
        return const Color(0xFFFFB74D);
      case 'tripExperience':
        return ColorsManager.accentCyan;
      case 'appBug':
        return const Color(0xFFFF6B6B);
      case 'accountIssue':
        return const Color(0xFFB388FF);
      default:
        return const Color(0xFF90A4AE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _PillTag(
      label: _localizedCategoryLabel(
        AppLocalizations.of(context)!,
        ticket.categoryKey,
        ticket.category,
      ),
      color: _color,
      icon: Icons.label_outline,
    );
  }
}

class _StatusTag extends StatelessWidget {
  final SupportTicketEntity ticket;

  const _StatusTag({required this.ticket});

  Color get _color {
    switch (ticket.statusKey) {
      case 'open':
        return ColorsManager.accentCyan;
      case 'inProgress':
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
      label: _localizedStatusLabel(
        AppLocalizations.of(context)!,
        ticket.statusKey,
        ticket.status,
      ),
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
          _formatDate(context, createdAt),
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

String _formatDate(BuildContext context, DateTime value) {
  final local = value.toLocal();
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).add_Hm().format(local);
}

String _readable(String value) {
  if (value.trim().isEmpty) return 'Other';
  final spaced = value
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll('_', ' ')
      .trim();
  return spaced[0].toUpperCase() + spaced.substring(1);
}

String _localizedCategoryLabel(
  AppLocalizations l10n,
  String key,
  String fallback,
) {
  return switch (key) {
    'payment' => l10n.supportCategoryPayment,
    'tripExperience' => l10n.supportCategoryTripExperience,
    'appBug' => l10n.supportCategoryAppBug,
    'accountIssue' => l10n.supportCategoryAccountIssue,
    'other' => l10n.supportCategoryOther,
    _ => _readable(fallback),
  };
}

String _localizedStatusLabel(AppLocalizations l10n, String key, String fallback) {
  return switch (key) {
    'open' => l10n.supportStatusOpen,
    'inProgress' => l10n.supportStatusInProgress,
    'resolved' => l10n.supportStatusResolved,
    'closed' => l10n.supportStatusClosed,
    _ => _readable(fallback),
  };
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
