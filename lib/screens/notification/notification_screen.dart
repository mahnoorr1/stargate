import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/localization/translation_strings.dart';
import 'package:stargate/providers/notification_provider.dart';

import '../../localization/localization.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch notifications
    Provider.of<NotificationProvider>(context, listen: false)
        .fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalization.of(context)!
              .translate(TranslationString.notifications),
          style: AppStyles.heading2,
        ),
        centerTitle: true,
      ),
      body: notificationProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : notificationProvider.notifications.isEmpty
              ? Center(
                  child: Text(AppLocalization.of(context)!
                      .translate(TranslationString.noNorificationsFound)))
              : ListView.builder(
                  itemCount: notificationProvider.notifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                        notificationProvider.notifications[index];
                    return buildNotificationCard(
                      title: notification.title,
                      description: notification.message,
                      imageUrl: notification.profileImage,
                      date: "${notification.date} ${notification.time}",
                    );
                  },
                ),
    );
  }

  Padding buildNotificationCard({
    required String title,
    required String description,
    required String imageUrl,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person,
                          color: AppColors.darkGrey, size: 30)
                      : ClipOval(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person,
                                  color: AppColors.darkGrey, size: 30);
                            },
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppStyles.heading4,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: AppStyles.normalText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                date,
                style: const TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
