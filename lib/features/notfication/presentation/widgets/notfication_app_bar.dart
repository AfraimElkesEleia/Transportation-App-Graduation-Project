import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/theming/colors.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_cubit.dart';
import 'package:transportation_app/features/notfication/presentation/cubit/notfication_state.dart';

class NotficationAppBar extends StatelessWidget {
  const NotficationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),

          // Title
          const Expanded(
            child: Text(
              'Notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),

          // Mark all read
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final hasUnread =
                  state is NotificationLoaded && state.unreadCount > 0;
              return GestureDetector(
                onTap: hasUnread
                    ? () => context.read<NotificationCubit>().markAllRead()
                    : null,
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: hasUnread ? ColorsManager.cyanBlue : Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
