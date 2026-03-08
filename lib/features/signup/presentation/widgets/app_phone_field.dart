import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// One entry in the country-code list
class PhoneCountry {
  final String flag;       
  final String dialCode;   
  final String name;       
  final String countryCode;

  const PhoneCountry({
    required this.flag,
    required this.dialCode,
    required this.name,
    required this.countryCode,
  });
}

/// Static list — expand as needed
const List<PhoneCountry> kPhoneCountries = [
  PhoneCountry(flag: '🇪🇬', dialCode: '+20',  name: 'Egypt',        countryCode: 'EG'),
  PhoneCountry(flag: '🇸🇦', dialCode: '+966', name: 'Saudi Arabia',  countryCode: 'SA'),
  PhoneCountry(flag: '🇦🇪', dialCode: '+971', name: 'UAE',           countryCode: 'AE'),
  PhoneCountry(flag: '🇰🇼', dialCode: '+965', name: 'Kuwait',        countryCode: 'KW'),
  PhoneCountry(flag: '🇶🇦', dialCode: '+974', name: 'Qatar',         countryCode: 'QA'),
  PhoneCountry(flag: '🇧🇭', dialCode: '+973', name: 'Bahrain',       countryCode: 'BH'),
  PhoneCountry(flag: '🇴🇲', dialCode: '+968', name: 'Oman',          countryCode: 'OM'),
  PhoneCountry(flag: '🇯🇴', dialCode: '+962', name: 'Jordan',        countryCode: 'JO'),
  PhoneCountry(flag: '🇱🇧', dialCode: '+961', name: 'Lebanon',       countryCode: 'LB'),
  PhoneCountry(flag: '🇸🇩', dialCode: '+249', name: 'Sudan',         countryCode: 'SD'),
  PhoneCountry(flag: '🇩🇿', dialCode: '+213', name: 'Algeria',       countryCode: 'DZ'),
  PhoneCountry(flag: '🇲🇦', dialCode: '+212', name: 'Morocco',       countryCode: 'MA'),
  PhoneCountry(flag: '🇹🇳', dialCode: '+216', name: 'Tunisia',       countryCode: 'TN'),
  PhoneCountry(flag: '🇱🇾', dialCode: '+218', name: 'Libya',         countryCode: 'LY'),
  PhoneCountry(flag: '🇬🇧', dialCode: '+44',  name: 'UK',            countryCode: 'GB'),
  PhoneCountry(flag: '🇺🇸', dialCode: '+1',   name: 'USA',           countryCode: 'US'),
  PhoneCountry(flag: '🇩🇪', dialCode: '+49',  name: 'Germany',       countryCode: 'DE'),
  PhoneCountry(flag: '🇫🇷', dialCode: '+33',  name: 'France',        countryCode: 'FR'),
  PhoneCountry(flag: '🇹🇷', dialCode: '+90',  name: 'Turkey',        countryCode: 'TR'),
];

class AppPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String?               initialDialCode;   // e.g. "+20"
  final void Function(String dialCode, String countryCode)? onDialCodeChanged;
  final String? Function(String?)? validator;
  final String                label;

  const AppPhoneField({
    super.key,
    required this.controller,
    required this.label,
    this.initialDialCode,
    this.onDialCodeChanged,
    this.validator,
  });

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  late PhoneCountry _selected;

  @override
  void initState() {
    super.initState();
    _selected = kPhoneCountries.firstWhere(
      (c) => c.dialCode == widget.initialDialCode,
      orElse: () => kPhoneCountries.first, // default Egypt
    );
  }

  void _openPicker() {
    showModalBottomSheet(
      context:           context,
      isScrollControlled: true,
      backgroundColor:   const Color(0xFF1A2A3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryCodeSheet(
        selected: _selected,
        onSelected: (country) {
          setState(() => _selected = country);
          widget.onDialCodeChanged?.call(country.dialCode, country.countryCode);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color:      Colors.white70,
            fontSize:   13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller:   widget.controller,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(color: Colors.white),
          validator: widget.validator,
          decoration: InputDecoration(
            hintText:     'Enter phone number',
            hintStyle:    const TextStyle(color: Colors.white38),
            filled:       true,
            fillColor:    const Color(0xFF1A2A3A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical:   16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: Color(0xFF2A3A4A)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: Color(0xFF1AC8E8)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:   const BorderSide(color: Colors.red),
            ),
            // ── Dial code dropdown as prefix ──────────────────
            prefixIcon: GestureDetector(
              onTap: _openPicker,
              child: Container(
                margin:  const EdgeInsets.only(left: 12, right: 0),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Color(0xFF2A3A4A), width: 1),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_selected.flag,     style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 6),
                    Text(
                      _selected.dialCode,
                      style: const TextStyle(
                        color:      Colors.white,
                        fontSize:   14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.white54, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Bottom sheet that lists all countries ───────────────────────
class _CountryCodeSheet extends StatefulWidget {
  final PhoneCountry                     selected;
  final void Function(PhoneCountry)      onSelected;

  const _CountryCodeSheet({
    required this.selected,
    required this.onSelected,
  });

  @override
  State<_CountryCodeSheet> createState() => _CountryCodeSheetState();
}

class _CountryCodeSheetState extends State<_CountryCodeSheet> {
  final _search = TextEditingController();
  List<PhoneCountry> _filtered = kPhoneCountries;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = kPhoneCountries
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              c.dialCode.contains(q))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand:          false,
      initialChildSize: 0.6,
      maxChildSize:     0.9,
      builder: (_, scrollController) => Column(
        children: [
          // ── Handle ─────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width:  40,
            height: 4,
            decoration: BoxDecoration(
              color:        Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ───────────────────────────────────────────
          const Text(
            'Select Country Code',
            style: TextStyle(
              color:      Colors.white,
              fontSize:   18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // ── Search ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              onChanged:  _filter,
              style:      const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText:      'Search country or code...',
                hintStyle:     const TextStyle(color: Colors.white38),
                prefixIcon:    const Icon(Icons.search, color: Colors.white38),
                filled:        true,
                fillColor:     const Color(0xFF0D1B2A),
                border:        OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:  BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── List ────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller:  scrollController,
              itemCount:   _filtered.length,
              itemBuilder: (_, i) {
                final country = _filtered[i];
                final isSelected =
                    country.dialCode == widget.selected.dialCode;

                return ListTile(
                  leading: Text(
                    country.flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    country.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    country.dialCode,
                    style: TextStyle(
                      color:      isSelected
                          ? const Color(0xFF1AC8E8)
                          : Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selected:      isSelected,
                  selectedColor: const Color(0xFF1AC8E8),
                  onTap: () {
                    widget.onSelected(country);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

