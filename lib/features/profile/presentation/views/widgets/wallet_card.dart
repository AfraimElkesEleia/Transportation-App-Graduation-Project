import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';

/// Premium wallet balance card with Charge + History actions.
class WalletCard extends StatelessWidget {
  final double? balance;
  const WalletCard({super.key, this.balance});

  void _showChargeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: const _ChargeWalletSheet(),
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

  @override
  Widget build(BuildContext context) {
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
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: ColorsManager.accentCyan, size: 22),
              ),
              const SizedBox(width: 12),
              const Text('My Wallet',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              _ActiveBadge(),
            ],
          ),
          const SizedBox(height: 20),

          // Balance
          BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (_, c) =>
                c is ProfileLoading ||
                c is ProfileLoaded,
            builder: (context, state) {
              final bal = state is ProfileLoaded
                  ? (state.profile.walletBalance ?? 0.0)
                  : (balance ?? 0.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available Balance',
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
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
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6, left: 6),
                        child: Text('EGP',
                            style: TextStyle(
                                color: Colors.white60, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: _WalletActionBtn(
                  icon: Icons.add_circle_outline,
                  label: 'Charge',
                  color: ColorsManager.accentCyan,
                  onTap: () => _showChargeSheet(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _WalletActionBtn(
                  icon: Icons.history_rounded,
                  label: 'History',
                  color: ColorsManager.turquoise,
                  onTap: () => _showHistorySheet(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: ColorsManager.accentCyan.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsManager.accentCyan.withValues(alpha: 0.4)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: ColorsManager.successGreen, size: 8),
          SizedBox(width: 4),
          Text('Active',
              style: TextStyle(color: ColorsManager.accentCyan, fontSize: 11)),
        ],
      ),
    );
  }
}

class _WalletActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _WalletActionBtn(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

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
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// Charge Bottom Sheet
// ════════════════════════════════════════════════════════════════════════
class _ChargeWalletSheet extends StatefulWidget {
  const _ChargeWalletSheet();
  @override
  State<_ChargeWalletSheet> createState() => _ChargeWalletSheetState();
}

class _ChargeWalletSheetState extends State<_ChargeWalletSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController();
  final _instapayCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _amountCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _pointsCtrl.dispose();
    _instapayCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ProfileCubit>();
    if (_tab.index == 0) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Points redeemed successfully!'),
          backgroundColor: Colors.green));
    } else if (_tab.index == 1) {
      cubit.depositToWallet(
        amount: double.tryParse(_amountCtrl.text) ?? 0,
        cardNumber: _cardCtrl.text.replaceAll(' ', ''),
        expiryDate: _expiryCtrl.text,
        cvv: _cvvCtrl.text,
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('InstaPay deposit initiated!'),
          backgroundColor: Colors.green));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is WalletDepositSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Wallet charged successfully!'),
              backgroundColor: Colors.green));
        } else if (state is WalletDepositFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message), backgroundColor: Colors.red));
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.78,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: ColorsManager.searchBg,
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
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              const Text('Charge Wallet',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TabBar(
                controller: _tab,
                indicatorColor: ColorsManager.accentCyan,
                labelColor: ColorsManager.accentCyan,
                unselectedLabelColor: Colors.white38,
                dividerColor: Colors.white12,
                tabs: const [
                  Tab(icon: Icon(Icons.stars_rounded), text: 'Points'),
                  Tab(icon: Icon(Icons.credit_card), text: 'Visa / Card'),
                  Tab(icon: Icon(Icons.phone_android), text: 'InstaPay'),
                ],
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      _PointsTab(controller: _pointsCtrl),
                      _CardTab(
                        amountCtrl: _amountCtrl,
                        cardCtrl: _cardCtrl,
                        expiryCtrl: _expiryCtrl,
                        cvvCtrl: _cvvCtrl,
                      ),
                      _InstapayTab(
                          controller: _instapayCtrl,
                          amountCtrl: _amountCtrl),
                    ],
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
                          backgroundColor: ColorsManager.accentCyan,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: Colors.black))
                            : const Text('Confirm Payment',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
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

// ── Tab widgets ──────────────────────────────────────────────────────
class _PointsTab extends StatelessWidget {
  final TextEditingController controller;
  const _PointsTab({required this.controller});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: ColorsManager.surfaceMid,
              borderRadius: BorderRadius.circular(16)),
          child: const Row(
            children: [
              Icon(Icons.stars_rounded, color: Color(0xFFFFD700), size: 32),
              SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your Points',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                SizedBox(height: 4),
                Text('1,250 pts',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _Field(
            controller: controller,
            label: 'Points to Redeem',
            hint: 'e.g. 500',
            icon: Icons.stars_rounded,
            keyboardType: TextInputType.number,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter points' : null),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ColorsManager.successGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: ColorsManager.successGreen.withValues(alpha: 0.3)),
          ),
          child: const Text('100 points = 10 EGP  •  Min redeem: 100 pts',
              style:
                  TextStyle(color: ColorsManager.successGreen, fontSize: 12),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

class _CardTab extends StatelessWidget {
  final TextEditingController amountCtrl, cardCtrl, expiryCtrl, cvvCtrl;
  const _CardTab(
      {required this.amountCtrl,
      required this.cardCtrl,
      required this.expiryCtrl,
      required this.cvvCtrl});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _Field(
          controller: amountCtrl,
          label: 'Amount (EGP)',
          hint: '10 – 10,000',
          icon: Icons.payments_outlined,
          keyboardType: TextInputType.number,
          validator: (v) {
            final n = double.tryParse(v ?? '');
            if (n == null) return 'Enter a valid amount';
            if (n < 10 || n > 10000) return '10 – 10,000 EGP';
            return null;
          },
        ),
        const SizedBox(height: 14),
        _Field(
          controller: cardCtrl,
          label: 'Card Number',
          hint: '4242 4242 4242 4242',
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
          validator: (v) {
            if ((v ?? '').replaceAll(' ', '').length != 16) {
              return 'Must be 16 digits';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: _Field(
              controller: expiryCtrl,
              label: 'Expiry',
              hint: 'MM/YY',
              icon: Icons.date_range,
              validator: (v) =>
                  (v != null && RegExp(r'^\d{2}/\d{2}$').hasMatch(v))
                      ? null
                      : 'Format: MM/YY',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _Field(
              controller: cvvCtrl,
              label: 'CVV',
              hint: '•••',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (v) =>
                  (v?.length == 3) ? null : '3 digits required',
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12)),
          child: const Row(children: [
            Icon(Icons.security, color: Colors.white38, size: 16),
            SizedBox(width: 8),
            Text('Simulated payment • No real charge',
                style: TextStyle(color: Colors.white38, fontSize: 11)),
          ]),
        ),
      ],
    );
  }
}

class _InstapayTab extends StatelessWidget {
  final TextEditingController controller, amountCtrl;
  const _InstapayTab(
      {required this.controller, required this.amountCtrl});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _Field(
          controller: amountCtrl,
          label: 'Amount (EGP)',
          hint: '10 – 10,000',
          icon: Icons.payments_outlined,
          keyboardType: TextInputType.number,
          validator: (v) {
            final n = double.tryParse(v ?? '');
            if (n == null) return 'Enter a valid amount';
            if (n < 10 || n > 10000) return '10 – 10,000 EGP';
            return null;
          },
        ),
        const SizedBox(height: 14),
        _Field(
          controller: controller,
          label: 'InstaPay Reference',
          hint: 'Enter reference number',
          icon: Icons.phone_android,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'Enter reference' : null,
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              ColorsManager.successGreen.withValues(alpha: 0.1),
              const Color(0xFF1B5E20).withValues(alpha: 0.1),
            ]),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: ColorsManager.successGreen.withValues(alpha: 0.3)),
          ),
          child: const Column(children: [
            Icon(Icons.phone_android,
                color: ColorsManager.successGreen, size: 28),
            SizedBox(height: 8),
            Text('Instant Payment',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            SizedBox(height: 4),
            Text('Transfer via InstaPay and enter your reference',
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center),
          ]),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        labelStyle:
            const TextStyle(color: Colors.white54, fontSize: 13),
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
        filled: true,
        fillColor: ColorsManager.surfaceMid,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: ColorsManager.borderSubtle)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: ColorsManager.accentCyan)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════
// History Sheet
// ════════════════════════════════════════════════════════════════════════
class _WalletHistorySheet extends StatelessWidget {
  const _WalletHistorySheet();
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: ColorsManager.searchBg,
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
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            const Text('Transaction History',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (_, c) =>
                    c is WalletHistoryLoading ||
                    c is WalletHistoryLoaded ||
                    c is WalletHistoryError,
                builder: (context, state) {
                  if (state is WalletHistoryLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: ColorsManager.accentCyan));
                  }
                  if (state is WalletHistoryError) {
                    return Center(
                        child: Text(state.message,
                            style: const TextStyle(
                                color: Colors.white54)));
                  }
                  if (state is WalletHistoryLoaded) {
                    if (state.transactions.isEmpty) {
                      return const Center(
                          child: Text('No transactions yet',
                              style:
                                  TextStyle(color: Colors.white54)));
                    }
                    return ListView.separated(
                      controller: ctrl,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
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
                                  ? ColorsManager.successGreen
                                      .withValues(alpha: 0.15)
                                  : Colors.red.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              t.isCredit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: t.isCredit
                                  ? ColorsManager.successGreen
                                  : Colors.red,
                              size: 16,
                            ),
                          ),
                          title: Text(t.type,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                          subtitle: Text(t.description,
                              style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          trailing: Text(
                            '${t.isCredit ? '+' : ''}${t.amount.toStringAsFixed(2)} EGP',
                            style: TextStyle(
                              color: t.isCredit
                                  ? ColorsManager.successGreen
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
