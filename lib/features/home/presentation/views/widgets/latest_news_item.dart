
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transportation_app/core/helper/spacing.dart';
import 'package:transportation_app/core/theming/styles.dart';

import 'package:transportation_app/features/notfication/domain/entities/app_notfication.dart';

class LatestNewsItem extends StatelessWidget {
  final AppNotification? notification;
  const LatestNewsItem({
    super.key,
    this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16),
          side: BorderSide(width: 0.5, color: Colors.grey),
        ),
        color: Color(0xFF122763),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(FontAwesomeIcons.pooStorm, color: Colors.yellow),
          horizontalSpace(space: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification?.title ?? "New High Speed Service",
                  style: AppStyles.bold18DarkBlue(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                Text(
                  notification?.body ??
                  "Cairo-Alex route now is 40% faster with new trains",
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                  style: AppStyles.regular16CyanBlue(
                    context,
                  ).copyWith(color: Colors.white),
                ),
                Text(
                  notification != null ? _timeAgo(notification!.receivedAt) : "2 hours ago",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}