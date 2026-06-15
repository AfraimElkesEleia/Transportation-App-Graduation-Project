import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

String formatLocalizedTime(
  DateTime dateTime, {
  required String amLabel,
  required String pmLabel,
}) {
  final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = dateTime.hour < 12 ? amLabel : pmLabel;
  return '${hour12.toString().padLeft(2, '0')}:$minute $period';
}

String formatTicketTime(BuildContext context, DateTime dateTime) {
  final l10n = AppLocalizations.of(context);
  return formatLocalizedTime(
    dateTime,
    amLabel: l10n?.amLabel ?? 'AM',
    pmLabel: l10n?.pmLabel ?? 'PM',
  );
}

String formatTicketDateTime(
  BuildContext context,
  DateTime dateTime, {
  required String datePattern,
}) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final date = DateFormat(datePattern, locale).format(dateTime);
  return '$date ${formatTicketTime(context, dateTime)}';
}
