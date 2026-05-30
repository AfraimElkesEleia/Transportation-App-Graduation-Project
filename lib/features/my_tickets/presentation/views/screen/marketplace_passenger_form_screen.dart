import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';

// ── ID type options (Train only — National ID & Passport) ────────────────────
const _kIdTypes = ['NationalId', 'Passport'];

const _kIdTypeLabels = {'NationalId': 'National ID', 'Passport': 'Passport'};

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
    isTrain = _detectTrain(widget.item);
    seatsBooked =
        widget.item['seatsCount'] as int? ??
        widget.item['seatsBooked'] as int? ??
        1;

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

  /// Determines whether the listing is a train booking.
  ///
  /// Checks [item['agencyName']] at the root level first, then falls back to
  /// [item['tripDetails']['agencyName']] in case the API nests it differently.
  /// Primary match: exact value "Egyptian National Railways".
  /// Fallback matches: NATIONAL RAIL, RAILWAY, TRAIN keywords.
  static bool _detectTrain(Map<String, dynamic> item) {
    // Try root-level agencyName first, then inside tripDetails
    final agencyName =
        (item['agencyName'] as String? ??
                item['agency'] as String? ??
                (item['tripDetails'] as Map<String, dynamic>?)?['agencyName']
                    as String? ??
                '')
            .toUpperCase();

    // Explicit transportType field (if API provides it)
    final transportType = (item['transportType'] as String? ?? '')
        .toUpperCase();

    return transportType == 'TRAIN' ||
        agencyName == 'EGYPTIAN NATIONAL RAILWAYS' ||
        agencyName.contains('NATIONAL RAIL') ||
        agencyName.contains('RAILWAY') ||
        agencyName.contains('TRAIN') ||
        agencyName.contains('ENR');
  }

  /// Auto-fill all seats with first passenger's Name & Phone (Bus only).
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
      final Map<String, dynamic> payload = {
        'passengerName': c.nameController.text.trim(),
      };

      if (isTrain) {
        // idType is always set for Train; idNumber required by API when idType present
        payload['idType'] = c.selectedIdType;
        final idNum = c.idController.text.trim();
        if (idNum.isNotEmpty) payload['idNumber'] = idNum;
      }
      // Bus: no ID fields sent at all
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
              ScaffoldMessenger.of(context)
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
          child: Column(
            children: [
              _FormAppBar(isTrain: isTrain),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    children: [
                      // Transport type badge
                      _TransportBadge(isTrain: isTrain),
                      const SizedBox(height: 16),

                      ...List.generate(seatsBooked, (index) {
                        final widgets = <Widget>[
                          _PassengerCard(
                            label: 'Passenger ${index + 1}',
                            controllers: _controllers[index],
                            isTrain: isTrain,
                          ),
                        ];

                        // Auto-fill banner: bus only, first seat, multi-seat
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

// ── Per-passenger state container ─────────────────────────────────────────────
class _PassengerControllers {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final phoneController = TextEditingController();
  String selectedIdType = 'NationalId'; // default for Train

  void dispose() {
    nameController.dispose();
    idController.dispose();
    phoneController.dispose();
  }
}

// ── Transport type badge ──────────────────────────────────────────────────────
class _TransportBadge extends StatelessWidget {
  final bool isTrain;
  const _TransportBadge({required this.isTrain});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isTrain
            ? const Color(0xFF1A3A6A).withOpacity(0.8)
            : const Color(0xFF1A3A2A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTrain
              ? ColorsManager.accentCyan.withOpacity(0.4)
              : ColorsManager.successGreen.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isTrain ? Icons.train_rounded : Icons.directions_bus_rounded,
            color: isTrain
                ? ColorsManager.accentCyan
                : ColorsManager.successGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTrain ? 'Train Booking' : 'Bus Booking',
                  style: TextStyle(
                    color: isTrain
                        ? ColorsManager.accentCyan
                        : ColorsManager.successGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isTrain
                      ? 'Name, ID type & number required for each passenger'
                      : 'Name & phone number required for each passenger',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _FormAppBar extends StatelessWidget {
  final bool isTrain;
  const _FormAppBar({required this.isTrain});

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
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Passenger Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  isTrain ? 'Train' : 'Bus',
                  style: TextStyle(
                    color: isTrain
                        ? ColorsManager.accentCyan
                        : ColorsManager.successGreen,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}

// ── Passenger card ────────────────────────────────────────────────────────────
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorsManager.accentCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: ColorsManager.accentCyan,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  color: ColorsManager.accentCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Full Name ──
          _buildTextField(
            controller: widget.controllers.nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Full name is required'
                : null,
          ),
          const SizedBox(height: 12),

          if (widget.isTrain) ...[
            // ── ID Type dropdown ──
            _buildIdTypeDropdown(),
            const SizedBox(height: 12),

            // ── ID Number ──
            _buildTextField(
              controller: widget.controllers.idController,
              label: 'ID Number',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'ID number is required'
                  : null,
            ),
            const SizedBox(height: 12),
          ],

          // ── Phone Number (both Train and Bus) ──
          _buildTextField(
            controller: widget.controllers.phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Phone number is required'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildIdTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: widget.controllers.selectedIdType,
      dropdownColor: ColorsManager.seatContainerBg,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: 'ID Type',
        labelStyle: const TextStyle(
          color: ColorsManager.textMuted,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.credit_card_rounded,
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
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: ColorsManager.textMuted,
      ),
      items: _kIdTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(
            _kIdTypeLabels[type] ?? type,
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() => widget.controllers.selectedIdType = val);
        }
      },
      validator: (v) =>
          (v == null || v.isEmpty) ? 'Please select ID type' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
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
        focusedErrorBorder: OutlineInputBorder(
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
}

// ── Bottom action bar ─────────────────────────────────────────────────────────
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

// ── Auto-fill banner (Bus multi-seat) ─────────────────────────────────────────
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
                  autofilled ? 'Auto-filled ✔' : 'Travelling with family?',
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
