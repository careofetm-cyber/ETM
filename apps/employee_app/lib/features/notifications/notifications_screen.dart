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
        if (idx >= 0) _notifications[idx]['is_read'] = true;
        if (_unreadCount > 0) _unreadCount--;
      });
    } catch (_) {}
  }

  Future<void> _markAllAsRead() async {
    try {
      final dio = ref.read(dioProvider);
      await dio.put('/notifications/read-all');
      setState(() {
        for (var n in _notifications) n['is_read'] = true;
        _unreadCount = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
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
      case 'trip': return Colors.blue;
      case 'attendance': return Colors.green;
      case 'emergency': return Colors.red;
      case 'maintenance': return Colors.orange;
      case 'system': return Colors.purple;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError()
                : RefreshIndicator(
                    onRefresh: _loadData,
                    child: Column(
                      children: [
                        if (_unreadCount > 0)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 10, color: Theme.of(context).colorScheme.primary),
                                const SizedBox(width: 8),
                                Text('$_unreadCount unread notification${_unreadCount == 1 ? '' : 's'}',
                                    style: const TextStyle(fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              FilterChip(
                                label: const Text('All'),
                                selected: !_showUnreadOnly,
                                onSelected: (_) { _showUnreadOnly = false; _loadData(); },
                              ),
                              const SizedBox(width: 8),
                              FilterChip(
                                label: Text('Unread ($_unreadCount)'),
                                selected: _showUnreadOnly,
                                onSelected: (_) { _showUnreadOnly = true; _loadData(); },
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
                                      Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade300),
                                      const SizedBox(height: 12),
                                      Text('No notifications', style: TextStyle(color: Colors.grey.shade500)),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  itemCount: _notifications.length + (_hasMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _notifications.length) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: FilledButton(onPressed: _loadMore, child: const Text('Load More')),
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
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationTile(dynamic notification) {
    final isRead = notification['is_read'] == true || notification['isRead'] == true;
    final type = notification['type'] ?? 'general';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isRead ? null : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _typeColor(type).withOpacity(0.15),
          child: Icon(_typeIcon(type), color: _typeColor(type), size: 20),
        ),
        title: Text(
          notification['title'] ?? 'Notification',
          style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Text(
          notification['body'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isRead)
              Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              ),
            const SizedBox(height: 4),
            Text(
              _timeAgo(notification['created_at']),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
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
