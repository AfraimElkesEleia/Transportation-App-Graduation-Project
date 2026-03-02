import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/styles.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/filter_selection.dart';

class FilterSection extends StatefulWidget {
  const FilterSection({super.key});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection>
    with SingleTickerProviderStateMixin {
  int price = 50;
  bool showFilter = false;

  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _buildSlider(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Max Cost : $price", style: AppStyles.regular18white(context)),
      Slider(
        min: 50,
        max: 1000,
        value: price.toDouble(),
        activeColor: ColorsManager.cyanBlue,
        inactiveColor: ColorsManager.darkBlue.withOpacity(0.5),
        thumbColor: Colors.white,
        onChanged: (value) {
          setState(() {
            price = value.toInt();
          });
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: ColorsManager.cyanBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            setState(() {
              showFilter = !showFilter;

              if (showFilter) {
                animationController.forward();
              } else {
                animationController.reverse();
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotationTransition(
                turns: animation,
                child: const Icon(FontAwesomeIcons.filter),
              ),
              horizontalSpace(space: 8),
              Text(
                showFilter ? "Hide Filter" : "Show Filter",
                style: AppStyles.bold16CyanBlue(
                  context,
                ).copyWith(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.fastOutSlowIn,
          child: showFilter
              ? Column(
                  children: [
                    verticalSpace(space: 8),
                    Divider(),
                    verticalSpace(space: 8),

                    Row(
                      children: [
                        Expanded(
                          child: FilterSelection(
                            items: ["Economic", "Business", "VIP"],
                          ),
                        ),
                        horizontalSpace(space: 10),
                        Expanded(
                          child: FilterSelection(
                            items: [
                              "Any Time",
                              "Morning (6 - 12)",
                              "Afternoon (12 - 18)",
                              "Evening (18 - 24)",
                            ],
                          ),
                        ),
                      ],
                    ),

                    verticalSpace(space: 16),
                    _buildSlider(context),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
