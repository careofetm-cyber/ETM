import '../config/database.dart';

class NotificationHelper {
  static void create({
    required String userId,
    required String title,
    required String message,
    required String type,
    String? referenceId,
    String? referenceType,
    String? companyId,
  }) {
    final db = DatabaseConfig.db;
    db.insert('notifications', {
      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': userId,
      'company_id': companyId,
      'title': title,
      'message': message,
      'type': type,
      'reference_id': referenceId,
      'reference_type': referenceType,
      'is_read': false,
      'created_at': DateTime.now().toIso8601String(),
    });
  }
}
