import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/l10n/app_localizations.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_autofill_banner.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_card.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_app_bar.dart';
import 'package:transportation_app/features/booking/presentation/views/widgets/passenger_form/passenger_form_controllers.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_cubit.dart';
import 'package:transportation_app/features/my_tickets/presentation/cubit/marketplace_states.dart';
import 'package:transportation_app/features/profile/domain/entities/profile_entity.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_cubit.dart';
import 'package:transportation_app/features/profile/presentation/cubit/profile_cubit/profile_states.dart';

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
  late final List<PassengerFormControllers> _controllers;
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

    _controllers = List.generate(
      seatsBooked,
      (_) => PassengerFormControllers(),
    );
    _controllers.first.nameController.addListener(_onFirstChanged);
    _controllers.first.phoneController.addListener(_onFirstChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded) {
        _prefillFromProfile(profileState.profile);
      }
    });
  }

  void _onFirstChanged() {
    if (_autofilled) setState(() => _autofilled = false);
  }

  void _prefillFromProfile(ProfileEntity profile) {
    if (_controllers.isEmpty) return;

    final first = _controllers.first;
    if (first.nameController.text.trim().isEmpty) {
      first.nameController.text = profile.fullName;
    }
    if (first.phoneController.text.trim().isEmpty) {
      first.phoneController.text = profile.phoneNumber;
    }
    if (isTrain && profile.idNumber != null && profile.idNumber!.isNotEmpty) {
      if (first.idController.text.trim().isEmpty) {
        first.idController.text = profile.idNumber!;
      }
      if (profile.idType != null) {
        setState(() {
          first.selectedIdType = profile.idType == 2
              ? 'Passport'
              : 'NationalId';
        });
      }
    }
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
    final loc = AppLocalizations.of(context)!;
    final srcName = _controllers.first.nameController.text.trim();
    final srcPhone = _controllers.first.phoneController.text.trim();

    if (srcName.isEmpty || srcPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(loc.fillNamePhoneFirst)),
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
                loc.filledNSeats('${_controllers.length - 1}', srcName),
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
        child: MultiBlocListener(
          listeners: [
            BlocListener<MarketplaceCubit, MarketplaceState>(
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
            ),
            BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileLoaded) {
                  _prefillFromProfile(state.profile);
                }
              },
            ),
          ],
          child: Column(
            children: [
              PassengerFormAppBar(
                subtitle: isTrain
                    ? AppLocalizations.of(context)!.train
                    : AppLocalizations.of(context)!.bus,
              ),
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
                          PassengerCard(
                            index: index + 1,
                            controllers: _controllers[index],
                            isTrain: isTrain,
                            showEmail: false,
                            showHeaderIcon: true,
                            phoneInputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            idInputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9]'),
                              ),
                            ],
                          ),
                        ];

                        // Auto-fill banner: bus only, first seat, multi-seat
                        if (index == 0 && !isTrain && seatsBooked > 1) {
                          widgets.add(
                            PassengerAutofillBanner(
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

// ── Transport type badge ──────────────────────────────────────────────────────
class _TransportBadge extends StatelessWidget {
  final bool isTrain;
  const _TransportBadge({required this.isTrain});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isTrain
            ? const Color(0xFF1A3A6A).withValues(alpha: 0.8)
            : const Color(0xFF1A3A2A).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isTrain
              ? ColorsManager.accentCyan.withValues(alpha: 0.4)
              : ColorsManager.successGreen.withValues(alpha: 0.4),
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
                  isTrain ? loc.trainBooking : loc.busBooking,
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
                      ? loc.trainPassengerRequirements
                      : loc.busPassengerRequirements,
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
                      Text(
                        AppLocalizations.of(context)!.totalPrice,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(0)} ${AppLocalizations.of(context)!.egp}',
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
                          : Text(
                              AppLocalizations.of(context)!.buyNow,
                              style: const TextStyle(
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
