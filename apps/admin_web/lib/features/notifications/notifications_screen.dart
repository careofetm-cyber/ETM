import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:etm_core/etm_core.dart';
import '../../shared/providers/api_providers.dart';

final notificationsPageProvider = StateProvider<int>((ref) => 1);
final notificationsUnreadOnlyProvider = StateProvider<bool>((ref) => false);

final notificationsProvider = FutureProvider<List<AppNotification>>((ref) async {
  final api = await ref.watch(notificationApiProvider.future);
  final page = ref.watch(notificationsPageProvider);
  final unreadOnly = ref.watch(notificationsUnreadOnlyProvider);
  return api.getNotifications(
    page: page,
    limit: 20,
    unreadOnly: unreadOnly ? true : null,
  );
});

final unreadCountProvider = FutureProvider<int>((ref) async {
  final api = await ref.watch(notificationApiProvider.future);
  return api.getUnreadCount();
});

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                SwitchListTile(
                  title: const Text('Unread only'),
                  value: ref.watch(notificationsUnreadOnlyProvider),
                  onChanged: (value) {
                    ref.read(notificationsUnreadOnlyProvider.notifier).state = value;
                    ref.read(notificationsPageProvider.notifier).state = 1;
                  },
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () async {
                    final api = await ref.read(notificationApiProvider.future);
                    await api.markAllAsRead();
                    ref.invalidate(notificationsProvider);
                    ref.invalidate(unreadCountProvider);
                  },
                  child: const Text('Mark all as read'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: notificationsAsync.when(
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return const Center(child: Text('No notifications'));
                  }
                  return _buildNotificationsList(notifications);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<AppNotification> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final isRead = notification.isRead;
        return Card(
          color: isRead
              ? null
              : AppColors.primaryLight.withOpacity(0.05),
          child: ListTile(
            leading: _getNotificationIcon(notification.type.name),
            title: Text(
              notification.title,
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(notification.body),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(notification.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (!isRead) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            onTap: () async {
              if (!isRead) {
                final api = await ref.read(notificationApiProvider.future);
                await api.markAsRead(notification.id);
                ref.invalidate(notificationsProvider);
                ref.invalidate(unreadCountProvider);
              }
            },
          ),
        );
      },
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Widget _getNotificationIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'emergency':
        icon = Icons.warning;
        color = AppColors.error;
        break;
      case 'trip':
        icon = Icons.trip_origin;
        color = AppColors.success;
        break;
      case 'maintenance':
        icon = Icons.build;
        color = AppColors.warning;
        break;
      case 'system':
        icon = Icons.info;
        color = AppColors.info;
        break;
      case 'attendance':
        icon = Icons.check_circle;
        color = AppColors.secondary;
        break;
      default:
        icon = Icons.notifications;
        color = AppColors.textSecondary;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color),
    );
  }
}
