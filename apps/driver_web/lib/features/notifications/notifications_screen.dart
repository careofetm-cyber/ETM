import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/notifications');
      _notifications = resp.data is List ? resp.data : (resp.data['data'] ?? []);
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load notifications');
    } catch (e) {
      setState(() => _error = 'Network error');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _markAsRead(String id) async {
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/notifications/$id/read');
      setState(() {
        _notifications = _notifications.map((n) {
          if (n['id'] == id) return {...n, 'isRead': true};
          return n;
        }).toList();
      });
    } catch (_) {}
  }

  Future<void> _markAllRead() async {
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/notifications/read-all');
      setState(() {
        _notifications = _notifications.map((n) => {...n, 'isRead': true}).toList();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read'), backgroundColor: Colors.green),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to mark all as read'), backgroundColor: Colors.red),
        );
      }
    }
  }

  int get _unreadCount => _notifications.where((n) => n['isRead'] != true).length;

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'trip':
        return Icons.route_outlined;
      case 'schedule':
        return Icons.schedule_outlined;
      case 'alert':
        return Icons.warning_amber_outlined;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'trip':
        return const Color(0xFF2563EB);
      case 'schedule':
        return const Color(0xFFF59E0B);
      case 'alert':
        return const Color(0xFFEF4444);
      case 'system':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatTime(dynamic createdAt) {
    if (createdAt == null) return '';
    try {
      final dt = DateTime.parse(createdAt.toString());
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return DateFormat('MMM d, y').format(dt);
    } catch (_) {
      return createdAt.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;
    final padding = width < 600 ? 16.0 : width < 900 ? 24.0 : 32.0;
    final useTable = width > 700;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: cs.error),
                    const SizedBox(height: 12),
                    Text(_error!, style: TextStyle(color: cs.error, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _loadNotifications,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              )
            : _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none,
                            size: 56, color: cs.onSurfaceVariant.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        Text('No notifications',
                            style: TextStyle(color: cs.onSurfaceVariant, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
                        child: Row(
                          children: [
                            Text('Notifications',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            if (_unreadCount > 0)
                              TextButton.icon(
                                onPressed: _markAllRead,
                                icon: const Icon(Icons.done_all, size: 18),
                                label: const Text('Mark all read'),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: cs.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('$_unreadCount unread',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onPrimaryContainer)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: useTable
                            ? _buildTableView(padding)
                            : _buildCardView(padding),
                      ),
                    ],
                  );
  }

  Widget _buildTableView(double padding) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
      child: Card(
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Title')),
              DataColumn(label: Text('Message')),
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Status')),
            ],
            rows: _notifications.map((n) {
              final isRead = n['isRead'] == true;
              final title = n['title'] ?? '';
              final message = n['message'] ?? '';
              final type = n['type'] ?? '';
              final id = n['id'] ?? '';

              return DataRow(
                onSelectChanged: isRead ? null : (_) => _markAsRead(id),
                cells: [
                  DataCell(
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _typeColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_typeIcon(type), color: _typeColor(type), size: 18),
                    ),
                  ),
                  DataCell(
                    Text(title,
                        style: TextStyle(
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w700)),
                  ),
                  DataCell(
                    SizedBox(
                      width: 300,
                      child: Text(message,
                          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  DataCell(Text(_formatTime(n['createdAt']),
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12))),
                  DataCell(
                    isRead
                        ? Text('Read',
                            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12))
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Unread',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: cs.primary)),
                          ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardView(double padding) {
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final n = _notifications[index];
          final isRead = n['isRead'] == true;
          final title = n['title'] ?? '';
          final message = n['message'] ?? '';
          final type = n['type'] ?? '';
          final id = n['id'] ?? '';

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isRead ? null : () => _markAsRead(id),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _typeColor(type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_typeIcon(type), color: _typeColor(type), size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(title,
                                    style: TextStyle(
                                        fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                                        fontSize: 15)),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(message,
                              style: TextStyle(
                                  color: cs.onSurfaceVariant, fontSize: 13, height: 1.4)),
                          const SizedBox(height: 8),
                          Text(_formatTime(n['createdAt']),
                              style: TextStyle(
                                  color: cs.onSurfaceVariant.withOpacity(0.6), fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
