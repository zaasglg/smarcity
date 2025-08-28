import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import '../services/db_service.dart';
import 'notification_detail_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final DBService _dbService = DBService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      // For now, using mock data. Replace with actual notification service
      final notifications = await _getMockNotifications();
      setState(() => _notifications = notifications);
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<Map<String, dynamic>>> _getMockNotifications() async {
    // Mock notifications data - replace with actual service call
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': 1,
        'title': 'Новое сообщение',
        'message': 'У вас есть новое сообщение от администратора',
        'time': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        'isRead': false,
        'type': 'message',
      },
      {
        'id': 2,
        'title': 'Обновление системы',
        'message': 'Система будет обновлена сегодня в 23:00',
        'time': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'isRead': true,
        'type': 'system',
      },
      {
        'id': 3,
        'title': 'Напоминание',
        'message': 'Не забудьте проверить свой профиль',
        'time': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'isRead': false,
        'type': 'reminder',
      },
    ];
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (messageDate == today) {
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (messageDate == yesterday) {
        return 'Вчера';
      } else {
        return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
      }
    } catch (e) {
      return dateTimeStr;
    }
  }

  Future<void> _onRefresh() async {
    await _loadNotifications();
  }

  void _markAllAsRead() async {
    // Mark all notifications as read
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    // Here you would call your service to mark notifications as read
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Уведомления'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 36,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск уведомлений',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  HugeIcons.strokeRoundedSearch01,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: _onRefresh,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final notification = _notifications[index];
                            return _NotificationItem(
                              id: notification['id'],
                              title: notification['title'] ?? 'Уведомление',
                              message: notification['message'] ?? '',
                              time: _formatDateTime(notification['time']),
                              isRead: notification['isRead'] ?? false,
                              type: notification['type'] ?? 'default',
                              icon: _getNotificationIcon(notification['type'] ?? 'default'),
                              onTap: () async {
                                // Navigate to notification detail page
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationDetailPage(
                                      notificationId: notification['id'],
                                      title: notification['title'] ?? 'Уведомление',
                                      message: notification['message'] ?? '',
                                      type: notification['type'] ?? 'default',
                                      time: notification['time'] ?? '',
                                      isRead: notification['isRead'] ?? false,
                                    ),
                                  ),
                                );
                                
                                // If notification was deleted, remove it from the list
                                if (result == true) {
                                  setState(() {
                                    _notifications.removeWhere((n) => n['id'] == notification['id']);
                                  });
                                } else {
                                  // Mark as read when returning from detail page
                                  setState(() {
                                    notification['isRead'] = true;
                                  });
                                }
                              },
                            );
                          },
                          childCount: _notifications.length,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final int id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final String type;
  final IconData icon;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : Colors.blue.shade50,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ),
                if (!isRead)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                            fontSize: 14,
                            color: isRead ? Colors.grey.shade700 : Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      color: isRead ? Colors.grey.shade600 : Colors.grey.shade700,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}