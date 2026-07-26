import 'in_memory_db.dart';

class RedisConfig {
  static InMemoryRedis? _redis;

  static Future<void> initialize() async {
    _redis = InMemoryRedis();
    print('Using in-memory Redis (development mode)');
  }

  static Future<void> close() async {}

  static Future<void> set(String key, String value, {Duration? expiry}) async {
    await _redis!.set(key, value, expiry: expiry);
  }

  static Future<String?> get(String key) async {
    return await _redis!.get(key);
  }

  static Future<void> delete(String key) async {
    await _redis!.delete(key);
  }

  static Future<bool> exists(String key) async {
    return await _redis!.exists(key);
  }

  static Future<void> setToken(String userId, String token, {Duration? expiry}) async {
    await set('token:$userId', token, expiry: expiry ?? const Duration(hours: 24));
  }

  static Future<String?> getToken(String userId) async {
    return await get('token:$userId');
  }

  static Future<void> invalidateToken(String userId) async {
    await delete('token:$userId');
  }
}
