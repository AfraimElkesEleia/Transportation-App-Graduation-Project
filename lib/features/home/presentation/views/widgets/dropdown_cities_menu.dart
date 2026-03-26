import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DropdownCitiesMenu extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  final void Function(String)? onSelected;
  const DropdownCitiesMenu({
    super.key,
    required this.hintText,
    required this.controller,
    this.errorText,
    this.onSelected,
  });

  static final List<String> egyptCities = [
    "Cairo",
    "Giza",
    "Alexandria",
    "Shubra El-Kheima",
    "Port Said",
    "Suez",
    "Luxor",
    "Asyut",
    "Ismailia",
    "Fayoum",
    "Zagazig",
    "Damietta",
    "Aswan",
    "Minya",
    "Damanhur",
    "Beni Suef",
    "Qena",
    "Sohag",
    "Hurghada",
    "Mansoura",
    "Tanta",
    "Arish",
    "Banha",
    "Kafr El-Sheikh",
    "Mallawi",
    "10th of Ramadan City",
    "Obour City",
    "Sadat City",
    "New Cairo",
    "New Capital",
    "Sharm El Sheikh",
    "Marsa Matrouh",
    "North Sinai",
    "South Sinai",
    "Beheira",
    "Monufia",
    "Sharqia",
    "Qalyubia",
    "Gharbia",
    "Dakahlia",
    "Red Sea",
    "New Valley",
    "Helwan",
  ];
  static final Map<String, String> egyptCitiesArabic = {
    "Cairo": "القاهرة",
    "Giza": "الجيزة",
    "Alexandria": "الإسكندرية",
    "Shubra El-Kheima": "شبرا الخيمة",
    "Port Said": "بورسعيد",
    "Suez": "السويس",
    "Luxor": "الأقصر",
    "Asyut": "أسيوط",
    "Ismailia": "الإسماعيلية",
    "Fayoum": "الفيوم",
    "Zagazig": "الزقازيق",
    "Damietta": "دمياط",
    "Aswan": "أسوان",
    "Minya": "المنيا",
    "Damanhur": "دمنهور",
    "Beni Suef": "بني سويف",
    "Qena": "قنا",
    "Sohag": "سوهاج",
    "Hurghada": "الغردقة",
    "Mansoura": "المنصورة",
    "Tanta": "طنطا",
    "Arish": "العريش",
    "Banha": "بنها",
    "Kafr El-Sheikh": "كفر الشيخ",
    "Mallawi": "ملوي",
    "10th of Ramadan City": "العاشر من رمضان",
    "Obour City": "مدينة العبور",
    "Sadat City": "مدينة السادات",
    "New Cairo": "القاهرة الجديدة",
    "New Capital": "العاصمة الإدارية",
    "Sharm El Sheikh": "شرم الشيخ",
    "Marsa Matrouh": "مرسى مطروح",
    "North Sinai": "شمال سيناء",
    "South Sinai": "جنوب سيناء",
    "Beheira": "البحيرة",
    "Monufia": "المنوفية",
    "Sharqia": "الشرقية",
    "Qalyubia": "القليوبية",
    "Gharbia": "الغربية",
    "Dakahlia": "الدقهلية",
    "Red Sea": "البحر الأحمر",
    "New Valley": "الوادي الجديد",
    "Helwan": "حلوان",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownMenu(
          controller: controller,
          onSelected: (value) => onSelected?.call(value ?? ''),
          menuStyle: MenuStyle(
            maximumSize: WidgetStatePropertyAll(
              Size(double.infinity, MediaQuery.sizeOf(context).height / 3.5),
            ),
          ),
          enableFilter: true,
          enableSearch: true,
          width: MediaQuery.sizeOf(context).width - 40,
          hintText: hintText,
          textStyle: const TextStyle(color: Colors.white),
          leadingIcon: Icon(
            FontAwesomeIcons.mapLocation,
            color: Color(0xFF4f8c9a),
          ),
          trailingIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF4f8c9a),
            size: 28,
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(16),
            hintStyle: const TextStyle(color: Color(0xFF4f8c9a)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: errorText != null
                    ? Colors.redAccent
                    : const Color(0xFF4f8c9a),
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: errorText != null
                    ? Colors.redAccent
                    : const Color(0xFF4f8c9a),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: errorText != null
                    ? Colors.redAccent
                    : const Color(0xFF4f8c9a),
                width: 2.5,
              ),
            ),
          ),
          dropdownMenuEntries: egyptCities.map((city) {
            return DropdownMenuEntry(
              label: city,
              value: city,
              labelWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    egyptCitiesArabic[city] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
