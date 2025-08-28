import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NotificationDetailPage extends StatefulWidget {
  final int notificationId;
  final String title;
  final String message;
  final String type;
  final String time;
  final bool isRead;

  const NotificationDetailPage({
    super.key,
    required this.notificationId,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
  });

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  late bool _isRead;

  @override
  void initState() {
    super.initState();
    _isRead = widget.isRead;
    // Mark as read when opening detail page
    if (!_isRead) {
      _markAsRead();
    }
  }

  void _markAsRead() {
    setState(() {
      _isRead = true;
    });
    // Here you would call your service to mark notification as read
  }

  void _deleteNotification() async {
    // Here you would call your service to delete the notification
    Navigator.pop(context, true); // Return true to indicate deletion
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'message':
        return HugeIcons.strokeRoundedMail01;
      case 'system':
        return HugeIcons.strokeRoundedSettings02;
      case 'reminder':
        return HugeIcons.strokeRoundedAlarmClock;
      default:
        return HugeIcons.strokeRoundedNotification03;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'message':
        return Colors.blue;
      case 'system':
        return Colors.orange;
      case 'reminder':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getNotificationTypeText(String type) {
    switch (type) {
      case 'message':
        return 'Сообщение';
      case 'system':
        return 'Системное';
      case 'reminder':
        return 'Напоминание';
      default:
        return 'Уведомление';
    }
  }

  String _formatDateTime(String timeStr) {
    try {
      final dateTime = DateTime.parse(timeStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      String dateText;
      if (messageDate == today) {
        dateText = 'Сегодня';
      } else if (messageDate == yesterday) {
        dateText = 'Вчера';
      } else {
        dateText = '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
      }

      final timeText = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      return '$dateText в $timeText';
    } catch (e) {
      return timeStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            HugeIcons.strokeRoundedArrowLeft01,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getNotificationColor(widget.type).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(widget.type),
                color: _getNotificationColor(widget.type),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _getNotificationTypeText(widget.type),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              HugeIcons.strokeRoundedDelete02,
              color: Colors.red,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Удалить уведомление'),
                    content: const Text('Вы уверены, что хотите удалить это уведомление?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteNotification();
                        },
                        child: const Text(
                          'Удалить',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getNotificationColor(widget.type).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getNotificationColor(widget.type).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getNotificationColor(widget.type).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getNotificationIcon(widget.type),
                      color: _getNotificationColor(widget.type),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getNotificationTypeText(widget.type),
                          style: TextStyle(
                            color: _getNotificationColor(widget.type),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDateTime(widget.time),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isRead)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Прочитано',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Notification title
            Text(
              'Заголовок',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Notification message
            Text(
              'Сообщение',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _markAsRead();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Уведомление отмечено как прочитанное'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: Icon(
                      _isRead ? HugeIcons.strokeRoundedCheckmarkCircle02 : HugeIcons.strokeRoundedCheckmarkCircle01,
                      size: 18,
                    ),
                    label: Text(_isRead ? 'Прочитано' : 'Отметить как прочитанное'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isRead ? Colors.green : Colors.blue,
                      side: BorderSide(
                        color: _isRead ? Colors.green : Colors.blue,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}