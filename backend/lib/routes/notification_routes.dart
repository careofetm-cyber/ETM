import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/database.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/error_middleware.dart';

class NotificationRoutes {
  final router = Router();
  
  NotificationRoutes() {
    router.get('/', authMiddleware()(getNotifications));
    router.put('/<id>/read', authMiddleware()(markAsRead));
    router.put('/read-all', authMiddleware()(markAllAsRead));
    router.get('/unread-count', authMiddleware()(getUnreadCount));
  }
  
  Future<Response> getNotifications(Request request) async {
    final userId = request.context['userId'] as String;
    final page = int.tryParse(request.url.queryParameters['page'] ?? '1') ?? 1;
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '20') ?? 20;
    final unreadOnly = request.url.queryParameters['unreadOnly'] == 'true';
    
    final db = DatabaseConfig.db;
    final filters = <String, dynamic>{'user_id': userId};
    if (unreadOnly) filters['is_read'] = false;
    
    var allNotifications = db.findAll('notifications', filters: filters);
    final total = allNotifications.length;
    allNotifications.sort((a, b) => (b['created_at'] ?? '').toString().compareTo((a['created_at'] ?? '').toString()));
    final paginated = allNotifications.skip((page - 1) * limit).take(limit).toList();
    
    return jsonResponse({
      'data': paginated,
      'pagination': {
        'total': total,
        'page': page,
        'limit': limit,
        'totalPages': (total / limit).ceil(),
      },
    });
  }
  
  Future<Response> markAsRead(Request request) async {
    final id = request.params['id'];
    
    final db = DatabaseConfig.db;
    db.update('notifications', {
      'is_read': true,
      'read_at': DateTime.now().toIso8601String(),
    }, where: {'id': id});
    
    return jsonResponse({'message': 'Notification marked as read'});
  }
  
  Future<Response> markAllAsRead(Request request) async {
    final userId = request.context['userId'] as String;
    
    final db = DatabaseConfig.db;
    final unread = db.findAll('notifications', filters: {'user_id': userId, 'is_read': false});
    final now = DateTime.now().toIso8601String();
    for (final n in unread) {
      db.update('notifications', {
        'is_read': true,
        'read_at': now,
      }, where: {'id': n['id']});
    }
    
    return jsonResponse({'message': 'All notifications marked as read'});
  }
  
  Future<Response> getUnreadCount(Request request) async {
    final userId = request.context['userId'] as String;
    
    final db = DatabaseConfig.db;
    final count = db.count('notifications', filters: {'user_id': userId, 'is_read': false});
    
    return jsonResponse({'count': count});
  }
}
