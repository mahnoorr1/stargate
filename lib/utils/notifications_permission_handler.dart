// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPermissionHelper {
  static const String _permissionRequestedKey =
      'notification_permission_requested';

  static Future<void> requestNotificationPermission(
      BuildContext context) async {
    // Get shared preferences instance
    final prefs = await SharedPreferences.getInstance();

    // Check if the permission request has already been shown
    final hasRequestedPermission =
        prefs.getBool(_permissionRequestedKey) ?? false;

    if (!hasRequestedPermission) {
      // Check if the notification permission is already granted
      final status = await Permission.notification.status;

      if (status.isDenied || status.isPermanentlyDenied) {
        // Request permission if not granted
        final newStatus = await Permission.notification.request();
        if (newStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification permission granted')),
          );
        } else if (newStatus.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification permission denied')),
          );
        } else if (newStatus.isPermanentlyDenied) {
          // Redirect to app settings if permission is permanently denied
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Enable notification permission in settings')),
          );
          await openAppSettings();
        }
      }

      // Mark that the permission request has been shown
      await prefs.setBool(_permissionRequestedKey, true);
    }
  }
}
