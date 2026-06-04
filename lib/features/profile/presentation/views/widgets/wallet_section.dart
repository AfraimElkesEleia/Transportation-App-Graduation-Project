import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';

class WalletSection extends StatelessWidget {
  final double? balance;
  const WalletSection({super.key, this.balance});

  void _showChargeSheet(BuildContext context) {
    // Capture the parent ScaffoldMessenger before entering the modal route,
    // so snackbars are shown on the underlying scaffold (not the sheet overlay).
    final messenger = ScaffoldMessenger.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: _ChargeWalletSheet(parentMessenger: messenger),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2B5E), Color(0xFF1A4A8A)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFF00E5FF),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.myWallet,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.circle, color: Color(0xFF00C853), size: 8),
                    const SizedBox(width: 4),
                    Text(
                      l10n.walletActive,
                      style: const TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (p, c) => c is ProfileLoaded || c is ProfileLoading,
            builder: (context, state) {
              final bal = state is ProfileLoaded
                  ? state.profile.walletBalance ?? 0.0
                  : balance ?? 0.0;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.availableBalance,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        bal.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 6),
                        child: Text(
                          l10n.egp,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  icon: Icons.add_circle_outline,
                  label: l10n.charge,
                  color: const Color(0xFF00E5FF),
                  onTap: () => _showChargeSheet(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionBtn(
                  icon: Icons.history_rounded,
                  label: l10n.history,
                  color: const Color(0xFF40E0D0),
                  onTap: () => _showHistorySheet(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showHistorySheet(BuildContext context) {
    context.read<ProfileCubit>().loadWalletHistory();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: const _WalletHistorySheet(),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Charge Bottom Sheet ──────────────────────────────────────────────
class _ChargeWalletSheet extends StatefulWidget {
  final ScaffoldMessengerState? parentMessenger;
  const _ChargeWalletSheet({this.parentMessenger});

  @override
  State<_ChargeWalletSheet> createState() => _ChargeWalletSheetState();
}

class _ChargeWalletSheetState extends State<_ChargeWalletSheet> {
  final _amountCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ProfileCubit>();
    cubit.depositToWallet(
      amount: double.tryParse(_amountCtrl.text) ?? 0,
      cardNumber: _cardCtrl.text.replaceAll(' ', ''),
      expiryDate: _expiryCtrl.text,
      cvv: _cvvCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messenger = widget.parentMessenger ?? ScaffoldMessenger.of(context);
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is WalletDepositSuccess) {
          Navigator.pop(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.walletChargedSuccessfully),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is WalletDepositFailure) {
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFB00020),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 4),
              ),
            );
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.5,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0A1628),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.chargeWallet,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: _CardTab(
                    amountCtrl: _amountCtrl,
                    cardCtrl: _cardCtrl,
                    expiryCtrl: _expiryCtrl,
                    cvvCtrl: _cvvCtrl,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final loading = state is WalletDepositLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E5FF),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                l10n.confirmPayment,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab Contents ─────────────────────────────────────────────────────
class _CardTab extends StatelessWidget {
  final TextEditingController amountCtrl, cardCtrl, expiryCtrl, cvvCtrl;
  const _CardTab({
    required this.amountCtrl,
    required this.cardCtrl,
    required this.expiryCtrl,
    required this.cvvCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SheetField(
          controller: amountCtrl,
          label: l10n.amountEgp,
          hint: '100 – 10,000',
          icon: Icons.payments_outlined,
          keyboardType: TextInputType.number,
          validator: (v) {
            final n = double.tryParse(v ?? '');
            if (n == null) return l10n.enterValidAmount;
            if (n < 10 || n > 10000) return l10n.amountMustBeRange;
            return null;
          },
        ),
        const SizedBox(height: 14),
        _SheetField(
          controller: cardCtrl,
          label: l10n.cardNumber,
          hint: '4242 4242 4242 4242',
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          validator: (v) {
            final clean = (v ?? '').replaceAll(' ', '');
            if (clean.length != 16) return l10n.mustBe16Digits;
            return null;
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _SheetField(
                controller: expiryCtrl,
                label: l10n.expiry,
                hint: 'MM/YY',
                icon: Icons.date_range,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(5),
                  _ExpiryDateFormatter(),
                ],
                validator: (v) {
                  if (v == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) {
                    return l10n.formatMmYy;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SheetField(
                controller: cvvCtrl,
                label: 'CVV',
                hint: '•••',
                icon: Icons.lock_outline,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (v) =>
                    (v?.length == 3) ? null : l10n.threeDigitsRequired,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.security, color: Colors.white38, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n.simulatedPayment,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF1A2E4A),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3A52)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00E5FF)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

// ── Wallet History Sheet ─────────────────────────────────────────────
class _WalletHistorySheet extends StatelessWidget {
  const _WalletHistorySheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A1628),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.transactionHistory,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is WalletHistoryLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF00E5FF),
                      ),
                    );
                  }
                  if (state is WalletHistoryError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white54),
                      ),
                    );
                  }
                  if (state is WalletHistoryLoaded) {
                    if (state.transactions.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noTransactionsYet,
                          style: const TextStyle(color: Colors.white54),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: ctrl,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.transactions.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.white12),
                      itemBuilder: (_, i) {
                        final t = state.transactions[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: t.isCredit
                                  ? const Color(
                                      0xFF00C853,
                                    ).withValues(alpha: 0.15)
                                  : Colors.red.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              t.isCredit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: t.isCredit
                                  ? const Color(0xFF00C853)
                                  : Colors.red,
                              size: 16,
                            ),
                          ),
                          title: Text(
                            t.type,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(
                            t.description,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            '${t.isCredit ? '+' : ''}${t.amount.toStringAsFixed(2)} EGP',
                            style: TextStyle(
                              color: t.isCredit
                                  ? const Color(0xFF00C853)
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    if (oldValue.text.length >= newText.length) {
      return newValue;
    }

    var digitsOnly = newText.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if (i == 1 && digitsOnly.length >= 2) {
        buffer.write('/');
      }
    }

    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
