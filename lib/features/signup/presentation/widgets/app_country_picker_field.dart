import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppCountryPickerField extends StatelessWidget {
  const AppCountryPickerField({
    super.key,
    required this.label,
    required this.selectedCode,
    required this.onCountrySelected,
    this.selectedName,
    this.errorText,
  });

  final String label;
  final String? selectedCode;
  final String? selectedName;
  final void Function(String code, String name) onCountrySelected;
  final String? errorText;

  static const _white20 = Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 4,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _openPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: errorText != null ? Colors.redAccent : _white20,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.flag, color: Colors.white, size: 20),
                const SizedBox(width: 14),
                if (selectedCode != null) ...[
                  Text(
                    _flagEmoji(selectedCode!),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    selectedName ?? 'Select your country',
                    style: TextStyle(
                      color: selectedCode != null
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
                if (selectedCode != null)
                  Text(
                    selectedCode!,
                    style: const TextStyle(
                      color: Color(0xff1AC8E8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, color: Colors.white54),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ],
      ],
    );
  }

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff0B1F3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _CountryPickerSheet(
        onSelected: onCountrySelected,
        selectedCode: selectedCode,
      ),
    );
  }

  /// Converts ISO alpha-2 code to flag emoji.
  static String _flagEmoji(String code) {
    final base = 0x1F1E6 - 0x41; // regional indicator base
    return String.fromCharCodes(
      code.toUpperCase().codeUnits.map((c) => base + c),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Bottom sheet content
// ─────────────────────────────────────────────────────────────────

class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({
    required this.onSelected,
    this.selectedCode,
  });

  final void Function(String code, String name) onSelected;
  final String? selectedCode;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _searchController = TextEditingController();
  late List<_Country> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = _kCountries;
    _searchController.addListener(() {
      final q = _searchController.text.toLowerCase();
      setState(() {
        _filtered = _kCountries
            .where((c) =>
                c.name.toLowerCase().contains(q) ||
                c.code.toLowerCase().contains(q))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, scrollController) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              'Select Country',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            const SizedBox(height: 12),
            // Search
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search country…',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.07),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // List
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  final isSelected = c.code == widget.selectedCode;
                  return ListTile(
                    leading: Text(
                      AppCountryPickerField._flagEmoji(c.code),
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      c.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                    trailing: Text(
                      c.code,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xff1AC8E8)
                            : Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      widget.onSelected(c.code, c.name);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Country {
  const _Country(this.code, this.name);
  final String code;
  final String name;
}
const _kCountries = [
  _Country('EG', 'Egypt'),
  _Country('SA', 'Saudi Arabia'),
  _Country('AE', 'United Arab Emirates'),
  _Country('KW', 'Kuwait'),
  _Country('QA', 'Qatar'),
  _Country('BH', 'Bahrain'),
  _Country('OM', 'Oman'),
  _Country('JO', 'Jordan'),
  _Country('LB', 'Lebanon'),
  _Country('SY', 'Syria'),
  _Country('IQ', 'Iraq'),
  _Country('PS', 'Palestine'),
  _Country('YE', 'Yemen'),
  _Country('LY', 'Libya'),
  _Country('TN', 'Tunisia'),
  _Country('DZ', 'Algeria'),
  _Country('MA', 'Morocco'),
  _Country('SD', 'Sudan'),
  _Country('US', 'United States'),
  _Country('GB', 'United Kingdom'),
  _Country('FR', 'France'),
  _Country('DE', 'Germany'),
  _Country('IT', 'Italy'),
  _Country('ES', 'Spain'),
  _Country('CA', 'Canada'),
  _Country('AU', 'Australia'),
  _Country('TR', 'Turkey'),
  _Country('IN', 'India'),
  _Country('PK', 'Pakistan'),
  _Country('NG', 'Nigeria'),
  _Country('ZA', 'South Africa'),
  _Country('KE', 'Kenya'),
  _Country('GH', 'Ghana'),
  _Country('BR', 'Brazil'),
  _Country('MX', 'Mexico'),
  _Country('AR', 'Argentina'),
  _Country('JP', 'Japan'),
  _Country('CN', 'China'),
  _Country('KR', 'South Korea'),
  _Country('SG', 'Singapore'),
  _Country('MY', 'Malaysia'),
  _Country('ID', 'Indonesia'),
  _Country('PH', 'Philippines'),
  _Country('RU', 'Russia'),
  _Country('UA', 'Ukraine'),
  _Country('PL', 'Poland'),
  _Country('NL', 'Netherlands'),
  _Country('SE', 'Sweden'),
  _Country('NO', 'Norway'),
  _Country('CH', 'Switzerland'),
];