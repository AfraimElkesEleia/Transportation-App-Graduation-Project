import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/routing/routes.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';

class MarketplacePassengerFormScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const MarketplacePassengerFormScreen({super.key, required this.item});

  @override
  State<MarketplacePassengerFormScreen> createState() =>
      _MarketplacePassengerFormScreenState();
}

class _MarketplacePassengerFormScreenState
    extends State<MarketplacePassengerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<_PassengerControllers> _controllers;
  bool _autofilled = false;
  late final bool isTrain;
  late final int seatsBooked;

  @override
  void initState() {
    super.initState();
    final trip = widget.item['tripDetails'] as Map<String, dynamic>? ?? {};
    final agencyName =
        widget.item['agencyName'] as String? ??
        widget.item['agency'] as String? ??
        '';
    isTrain = agencyName.toUpperCase().contains('ENR');
    seatsBooked = widget.item['seatsCount'] as int? ?? 1;

    _controllers = List.generate(seatsBooked, (_) => _PassengerControllers());
    _controllers.first.nameController.addListener(_onFirstChanged);
    _controllers.first.phoneController.addListener(_onFirstChanged);
  }

  void _onFirstChanged() {
    if (_autofilled) setState(() => _autofilled = false);
  }

  @override
  void dispose() {
    _controllers.first.nameController.removeListener(_onFirstChanged);
    _controllers.first.phoneController.removeListener(_onFirstChanged);
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _autofill() {
    final srcName = _controllers.first.nameController.text.trim();
    final srcPhone = _controllers.first.phoneController.text.trim();

    if (srcName.isEmpty || srcPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Please fill in Name and Phone for the first passenger first.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    for (int i = 1; i < _controllers.length; i++) {
      _controllers[i].nameController.text = srcName;
      _controllers[i].phoneController.text = srcPhone;
    }
    setState(() => _autofilled = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Filled ${_controllers.length - 1} seat(s) with "$srcName"',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final passengers = List.generate(seatsBooked, (i) {
      final c = _controllers[i];
      final Map<String, dynamic> payload = {};
      payload['passengerName'] = c.nameController.text.trim();
      final idNum = c.idController.text.trim();
      if (idNum.isNotEmpty || isTrain) {
        payload['idNumber'] = idNum;
        payload['idType'] = 'NationalId';
      }
      return payload;
    });

    final listingId = widget.item['listingId'] as int;
    context.read<MarketplaceCubit>().buyTicket(listingId, passengers);
  }

  @override
  Widget build(BuildContext context) {
    final askingPrice = (widget.item['askingPrice'] as num? ?? 0).toDouble();

    return Scaffold(
      backgroundColor: ColorsManager.seatBg,
      body: SafeArea(
        child: BlocListener<MarketplaceCubit, MarketplaceState>(
          listener: (context, state) {
            if (state is MarketplaceBoughtState) {
              Navigator.pop(context); // Go back to marketplace
            } else if (state is MarketplaceBuyErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              _FormAppBar(),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    children: [
                      ...List.generate(seatsBooked, (index) {
                        final widgets = <Widget>[
                          _PassengerCard(
                            label: 'Passenger ${index + 1}',
                            controllers: _controllers[index],
                            isTrain: isTrain,
                          ),
                        ];

                        if (index == 0 && !isTrain && seatsBooked > 1) {
                          widgets.add(
                            _AutofillBanner(
                              autofilled: _autofilled,
                              onAutofill: _autofill,
                            ),
                          );
                        }
                        return Column(children: widgets);
                      }),
                    ],
                  ),
                ),
              ),
              _FormBottomButtons(totalPrice: askingPrice, onBuyNow: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassengerControllers {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String gender = 'Male';

  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
    emailController.dispose();
  }
}

class _FormAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ColorsManager.seatContainerBg,
                borderRadius: BorderRadius.circular(21),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Passenger Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

class _PassengerCard extends StatefulWidget {
  final String label;
  final _PassengerControllers controllers;
  final bool isTrain;

  const _PassengerCard({
    required this.label,
    required this.controllers,
    required this.isTrain,
  });

  @override
  State<_PassengerCard> createState() => _PassengerCardState();
}

class _PassengerCardState extends State<_PassengerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.borderDim, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: ColorsManager.accentCyan,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: widget.controllers.nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: widget.controllers.idController,
            label: widget.isTrain ? 'National ID' : 'National ID (Optional)',
            icon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            validator: (v) => widget.isTrain && (v == null || v.trim().isEmpty)
                ? 'Required'
                : null,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: widget.controllers.phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          if (!widget.isTrain) _buildGenderDropdown(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: ColorsManager.textMuted,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: ColorsManager.textMuted, size: 20),
        filled: true,
        fillColor: ColorsManager.seatContainerBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.accentCyan),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: widget.controllers.gender,
      onChanged: (val) {
        if (val != null) {
          setState(() => widget.controllers.gender = val);
        }
      },
      items: const [
        DropdownMenuItem(value: 'Male', child: Text('Male')),
        DropdownMenuItem(value: 'Female', child: Text('Female')),
      ],
      dropdownColor: ColorsManager.seatContainerBg,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(
          color: ColorsManager.textMuted,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.wc_outlined,
          color: ColorsManager.textMuted,
          size: 20,
        ),
        filled: true,
        fillColor: ColorsManager.seatContainerBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsManager.accentCyan),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

class _FormBottomButtons extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onBuyNow;

  const _FormBottomButtons({required this.totalPrice, required this.onBuyNow});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceCubit, MarketplaceState>(
      builder: (context, state) {
        final isLoading = state is MarketplaceBuyingState;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Color(0xFF1E3A52), height: 1),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              color: ColorsManager.darkBlue,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      Text(
                        '$totalPrice EGP',
                        style: const TextStyle(
                          color: ColorsManager.successGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : onBuyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.accentCyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AutofillBanner extends StatelessWidget {
  final bool autofilled;
  final VoidCallback onAutofill;

  const _AutofillBanner({required this.autofilled, required this.onAutofill});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorsManager.accentCyan.withAlpha(80),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorsManager.accentCyan.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.family_restroom_rounded,
              color: ColorsManager.accentCyan,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  autofilled ? 'Auto-filled \u2714' : 'Travelling with family?',
                  style: TextStyle(
                    color: autofilled
                        ? ColorsManager.successGreen
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Fill seat 1, then copy name & phone to all other seats.',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onAutofill,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: autofilled
                    ? ColorsManager.successGreen
                    : ColorsManager.accentCyan,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              autofilled ? 'Re-fill' : 'Auto-fill',
              style: TextStyle(
                color: autofilled
                    ? ColorsManager.successGreen
                    : ColorsManager.accentCyan,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
