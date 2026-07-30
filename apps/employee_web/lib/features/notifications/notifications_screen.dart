import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../providers.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});
  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _notifications = [];
  int _unreadCount = 0;
  int _page = 1;
  bool _hasMore = true;
  bool _showUnreadOnly = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final dio = ref.read(dioProvider);
      final params = <String, dynamic>{'page': 1, 'limit': 30};
      if (_showUnreadOnly) params['unreadOnly'] = 'true';
      final resp = await dio.get('/notifications/', queryParameters: params);
      _notifications = resp.data['data'] ?? [];
      _page = 1;
      final total = resp.data['pagination']?['totalPages'] ?? 1;
      _hasMore = _page < total;

      final countResp = await dio.get('/notifications/unread-count');
      _unreadCount = countResp.data['count'] ?? 0;
    } on DioException catch (e) {
      setState(() => _error = e.response?.data?['error'] ?? 'Failed to load notifications');
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _loadMore() async {
    if (!_hasMore) return;
    try {
      final dio = ref.read(dioProvider);
      _page++;
      final params = <String, dynamic>{'page': _page, 'limit': 30};
      if (_showUnreadOnly) params['unreadOnly'] = 'true';
      final resp = await dio.get('/notifications/', queryParameters: params);
      final more = resp.data['data'] ?? [];
      setState(() {
        _notifications.addAll(more);
        final total = resp.data['pagination']?['totalPages'] ?? 1;
        _hasMore = _page < total;
      });
    } catch (_) {}
  }

  Future<void> _markAsRead(String id) async {
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/notifications/$id/read');
      setState(() {
        final idx = _notifications.indexWhere((n) => n['id'] == id);
        if (idx >= 0) _notifications[idx]['isRead'] = true;
        if (_unreadCount > 0) _unreadCount--;
      });
    } catch (_) {}
  }

  Future<void> _markAllAsRead() async {
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/notifications/read-all');
      setState(() {
        for (var n in _notifications) n['isRead'] = true;
        _unreadCount = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All notifications marked as read')));
      }
    } catch (_) {}
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'trip': return Icons.directions_bus;
      case 'attendance': return Icons.how_to_reg;
      case 'emergency': return Icons.emergency;
      case 'maintenance': return Icons.build;
      case 'system': return Icons.info_outline;
      default: return Icons.notifications;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'trip': return const Color(0xFF2563EB);
      case 'attendance': return const Color(0xFF059669);
      case 'emergency': return const Color(0xFFDC2626);
      case 'maintenance': return const Color(0xFFD97706);
      case 'system': return const Color(0xFF7C3AED);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 800;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                        child: Row(
                          children: [
                            if (_unreadCount > 0) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.circle_notifications, size: 18, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 6),
                                    Text('$_unreadCount unread', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  ],
                                ),
                              ),
                              const Spacer(),
                            ] else
                              const Spacer(),
                            FilterChip(
                              label: const Text('All'),
                              avatar: const Icon(Icons.notifications, size: 18),
                              selected: !_showUnreadOnly,
                              onSelected: (_) { _showUnreadOnly = false; _loadData(); },
                            ),
                            const SizedBox(width: 8),
                            FilterChip(
                              label: Text('Unread ($_unreadCount)'),
                              avatar: Icon(Icons.mark_email_unread, size: 18, color: _showUnreadOnly ? Theme.of(context).colorScheme.primary : null),
                              selected: _showUnreadOnly,
                              onSelected: (_) { _showUnreadOnly = true; _loadData(); },
                            ),
                            const SizedBox(width: 8),
                            if (_unreadCount > 0)
                              TextButton.icon(
                                onPressed: _markAllAsRead,
                                icon: const Icon(Icons.done_all, size: 18),
                                label: const Text('Mark all read'),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _notifications.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.notifications_none, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
                                    const SizedBox(height: 16),
                                    Text('No notifications', style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                itemCount: _notifications.length + (_hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _notifications.length) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: FilledButton.icon(onPressed: _loadMore, icon: const Icon(Icons.expand_more), label: const Text('Load More')),
                                      ),
                                    );
                                  }
                                  return _buildNotificationTile(_notifications[index]);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.error_outline, size: 48, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: _loadData, icon: const Icon(Icons.refresh), label: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(dynamic notification) {
    final isRead = notification['isRead'] == true || notification['is_read'] == true;
    final type = notification['type'] ?? 'general';
    final typeColor = _typeColor(type);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isRead ? null : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.08),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: typeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(_typeIcon(type), color: typeColor, size: 20),
        ),
        title: Text(notification['title'] ?? 'Notification', style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.w600, fontSize: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(notification['body'] ?? notification['message'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle)),
            const SizedBox(height: 4),
            Text(_timeAgo(notification['createdAt'] ?? notification['created_at']), style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        onTap: isRead ? null : () => _markAsRead(notification['id']),
      ),
    );
  }

  String _timeAgo(dynamic createdAt) {
    if (createdAt == null) return '';
    try {
      final dt = DateTime.parse(createdAt.toString());
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}
