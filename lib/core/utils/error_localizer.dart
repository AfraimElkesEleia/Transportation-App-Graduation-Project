import 'package:flutter/widgets.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';

class ErrorLocalizer {
  static String localize(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;

    // Match: "Insufficient funds. Your wallet balance is X, but checkout total is Y."
    final regExp = RegExp(
      r"Insufficient funds\.\s*Your wallet balance is\s*([\d\.,]+),\s*but checkout total is\s*([\d\.,]+)",
      caseSensitive: false,
    );
    final match = regExp.firstMatch(message);
    if (match != null) {
      final balance = match.group(1) ?? '0.00';
      final total = match.group(2) ?? '0.00';
      return l10n.insufficientFundsDetail(balance, total);
    }

    final lowerMessage = message.toLowerCase();
    if ((lowerMessage.contains("internet") &&
            (lowerMessage.contains("connection") ||
                lowerMessage.contains("network"))) ||
        lowerMessage.contains("connection error") ||
        lowerMessage.contains("network error")) {
      return l10n.noInternetConnection;
    }

    if (lowerMessage.contains("insufficient funds") ||
        lowerMessage.contains("insufficient_wallet_balance")) {
      return l10n.insufficientFunds;
    }

    if (lowerMessage == "checkout failed") {
      return l10n.checkoutFailed;
    }

    // Match: seat(s) taken / already taken / just taken
    if (lowerMessage.contains("seat") &&
        (lowerMessage.contains("taken") ||
            lowerMessage.contains("already booked") ||
            lowerMessage.contains("no longer available"))) {
      return l10n.seatsTakenError;
    }

    // Match server message: "one or more selected seats were just taken"
    if (lowerMessage.contains("one or more selected seats")) {
      return l10n.seatsTakenError;
    }

    return message;
  }
}
