import 'package:flutter/material.dart';

import '../services/user_profiling.dart'; // Replace with your API service path
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  // Getter for notifications
  List<NotificationModel> get notifications => _notifications;

  // Getter for loading status
  bool get isLoading => _isLoading;

  // Fetch notifications from the backend
  Future<void> fetchNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      List<NotificationModel> fetchedNotifications = await getNotifications();

      _notifications = fetchedNotifications;
    } catch (error) {
      debugPrint("Error fetching notifications: $error");
      _notifications = []; // Reset notifications in case of an error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark a notification as read

  // Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
