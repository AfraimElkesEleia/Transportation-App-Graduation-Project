import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/core/theming/font_weight_helper.dart';
import 'package:transportation_app/core/widgets/block_container.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/date_time_field.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/dropdown_cities_menu.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/filter_section.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/search_trip_button.dart';
import 'package:transportation_app/features/home/presentation/views/widgets/toggle_app_bar.dart';

class PlanYourJourneyBlock extends StatefulWidget {
  const PlanYourJourneyBlock({super.key});

  @override
  State<PlanYourJourneyBlock> createState() => _PlanYourJourneyBlockState();
}

class _PlanYourJourneyBlockState extends State<PlanYourJourneyBlock>
    with SingleTickerProviderStateMixin {
  late final TextEditingController toController;
  late final TextEditingController fromController;
  late final Animation<double> swapAnimation;
  late final AnimationController animationController;
  Row planYourJourney() {
    return Row(
      children: [
        Icon(FontAwesomeIcons.train, color: Colors.white, size: 20),
        horizontalSpace(space: 12),
        Text(
          "Plan Your Journey",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeightHelper.medium,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    toController = TextEditingController();
    fromController = TextEditingController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    swapAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    super.initState();
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlockContainer(
      isVip: true,
      child: Column(
        children: [
          planYourJourney(),
          verticalSpace(space: 24),
          ToggleAppBar(),
          verticalSpace(space: 24),
          DropdownCitiesMenu(
            hintText: "From (e.g...Cairo,Alex)",
            controller: toController,
          ),
          verticalSpace(space: 12),
          Center(
            child: GestureDetector(
              onTap: () {
                animationController.forward(from: 0);
                if (fromController.text.isNotEmpty &&
                    toController.text.isNotEmpty) {
                  final String temp = fromController.text;
                  fromController.text = toController.text;
                  toController.text = temp;
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Color(0xFF235272),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(100),
                  ),
                ),
                child: RotationTransition(
                  turns: swapAnimation,
                  child: Icon(
                    FontAwesomeIcons.arrowRightArrowLeft,
                    color: ColorsManager.cyanBlue,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(space: 12),
          DropdownCitiesMenu(
            hintText: "To (e.g...Luxor,Sohag)",
            controller: fromController,
          ),
          verticalSpace(space: 12),
          DateTimeField(),
          verticalSpace(space: 12),
          FilterSection(),
          verticalSpace(space: 12),
          SearchTripButton(),
        ],
      ),
    );
  }
}
