// lib/services/notification_service.dart
import 'package:flutter/material.dart';

enum NotificationType {
  success,
  error,
  warning,
  info
}

class NotificationService {
  static void showNotification(
    BuildContext context, {
    required String message,
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Define colors and icons for different notification types
    final notificationConfig = {
      NotificationType.success: _NotificationConfig(
        color: Colors.green,
        icon: Icons.check_circle_outline,
        label: 'Success',
      ),
      NotificationType.error: _NotificationConfig(
        color: Colors.red,
        icon: Icons.error_outline,
        label: 'Error',
      ),
      NotificationType.warning: _NotificationConfig(
        color: Colors.orange,
        icon: Icons.warning_amber_outlined,
        label: 'Warning',
      ),
      NotificationType.info: _NotificationConfig(
        color: Colors.blue,
        icon: Icons.info_outline,
        label: 'Info',
      ),
    };

    final config = notificationConfig[type]!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              config.icon,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (message.isNotEmpty) const SizedBox(height: 4),
                  if (message.isNotEmpty)
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: config.color,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

class _NotificationConfig {
  final Color color;
  final IconData icon;
  final String label;

  _NotificationConfig({
    required this.color,
    required this.icon,
    required this.label,
  });
}