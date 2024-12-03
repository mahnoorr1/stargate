import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: AppStyles.heading2,
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Notifications'),
      ),
    );
  }
}
