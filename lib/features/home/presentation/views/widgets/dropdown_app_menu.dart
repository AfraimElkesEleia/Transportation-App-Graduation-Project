import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:transportation_app/core/constants/cities.dart';
import 'package:transportation_app/core/theming/colors.dart';

class DropdownAppMenu<T> extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<T?>? onSelected;
  final List<T> items;
  final String displayProperty;
  final bool showSearchBox;
  final IconData? prefixIcon;
  final T? selectedItem;

  // When true, a null "Any station" row is prepended (used for sub-city).
  final bool allowClearSelection;

  const DropdownAppMenu({
    super.key,
    required this.hintText,
    required this.controller,
    required this.items,
    required this.displayProperty,
    this.errorText,
    this.onSelected,
    this.showSearchBox = true,
    this.prefixIcon = Icons.location_on_outlined,
    this.selectedItem,
    this.allowClearSelection = false,
  });

  // ── helpers ──────────────────────────────────────────────────────────────

  String _nameEn(T item) {
    if (item is Governorate) return item.nameEn;
    if (item is SubCity) return item.nameEn;
    return item.toString();
  }

  String _nameAr(T item) {
    if (item is Governorate) return item.nameAr;
    if (item is SubCity) return item.nameAr;
    return '';
  }

  String _displayValue(T? item) {
    if (item == null) return 'Any station';
    return _nameEn(item);
  }

  List<T?> _buildList(String filter) {
    final query = filter.trim().toLowerCase();
    final filtered = query.isEmpty
        ? items
        : items.where((i) => _nameEn(i).toLowerCase().contains(query)).toList();

    if (allowClearSelection && query.isEmpty) {
      return <T?>[null, ...filtered];
    }
    return filtered;
  }

  bool _compare(T? a, T? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a is Governorate && b is Governorate) return a.slug == b.slug;
    if (a is SubCity && b is SubCity) return a.slug == b.slug;
    return a == b;
  }

  // ── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final popupMaxH = MediaQuery.of(context).size.height * 0.45;

    const popupBg = Color(0xFF0F2035);
    const dividerColor = Color(0xFF1E3A52);

    return DropdownSearch<T?>(
      items: (filter, _) => _buildList(filter),

      compareFn: (a, b) => _compare(a, b),

      itemAsString: (item) => _displayValue(item),

      selectedItem: selectedItem,

      onChanged: (value) {
        controller.text = value != null ? _nameEn(value) : '';
        onSelected?.call(value);
      },
      dropdownBuilder: (context, selectedItem) {
        final label = _displayValue(selectedItem);
        return Text(
          label,
          style: TextStyle(
            color: selectedItem != null ? Colors.white : Colors.white38,
            fontSize: 14,
            fontWeight: selectedItem != null
                ? FontWeight.w500
                : FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        );
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          errorText: errorText,
          errorStyle: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 12),
          filled: true,
          fillColor: const Color(0xFF112233),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF1E3A52), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorsManager.cyanBlue, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
          ),
          prefixIcon: Icon(prefixIcon, color: ColorsManager.cyanBlue, size: 18),
        ),
      ),

      suffixProps: DropdownSuffixProps(
        dropdownButtonProps: DropdownButtonProps(
          iconClosed: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white38,
            size: 22,
          ),
          iconOpened: Icon(
            Icons.keyboard_arrow_up_rounded,
            color: ColorsManager.cyanBlue,
            size: 22,
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox,
        fit: FlexFit.loose,
        constraints: BoxConstraints(maxHeight: popupMaxH),
        searchFieldProps: TextFieldProps(
          autofocus: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white54,
              size: 18,
            ),
            filled: true,
            fillColor: const Color(0xFF1A3045),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ColorsManager.cyanBlue, width: 1),
            ),
          ),
        ),

        itemBuilder: (context, item, isDisabled, isSelected) {
          if (item == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.not_interested_rounded,
                    size: 18,
                    color: isSelected ? ColorsManager.cyanBlue : Colors.white38,
                  ),
                  title: Text(
                    'Any station',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? ColorsManager.cyanBlue
                          : Colors.white70,
                    ),
                  ),
                  subtitle: const Text(
                    'No specific preference',
                    style: TextStyle(fontSize: 11, color: Colors.white38),
                  ),
                  selected: isSelected,
                  selectedTileColor: ColorsManager.cyanBlue.withValues(
                    alpha: 0.08,
                  ),
                ),
                Divider(height: 1, color: dividerColor),
              ],
            );
          }

          final en = _nameEn(item);
          final ar = _nameAr(item);
          Widget? trailing;
          if (item is Governorate) {
            final count = item.subCities.length;
            trailing = Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorsManager.cyanBlue.withValues(alpha: 0.2)
                    : const Color(0xFF1A3045),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? ColorsManager.cyanBlue : Colors.white38,
                ),
              ),
            );
          }

          return ListTile(
            dense: true,
            selected: isSelected,
            selectedTileColor: ColorsManager.cyanBlue.withValues(alpha: 0.08),
            leading: Icon(
              Icons.train_outlined,
              size: 18,
              color: isSelected ? ColorsManager.cyanBlue : Colors.white38,
            ),
            title: Text(
              en,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? ColorsManager.cyanBlue : Colors.white,
              ),
            ),
            subtitle: ar.isNotEmpty
                ? Text(
                    ar,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                      // Right-to-left Arabic text
                      letterSpacing: 0.2,
                    ),
                    textDirection: TextDirection.rtl,
                  )
                : null,
            trailing: trailing,
          );
        },
        menuProps: MenuProps(
          elevation: 12,
          backgroundColor: popupBg,
          margin: const EdgeInsets.only(top: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: ColorsManager.cyanBlue.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
