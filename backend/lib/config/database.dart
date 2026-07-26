import 'in_memory_db.dart';
import 'seed_data.dart';

class DatabaseConfig {
  static InMemoryDatabase? _inMemoryDb;
  static bool _useInMemory = true;

  static Future<void> initialize() async {
    _inMemoryDb = InMemoryDatabase();
    SeedData.seed(_inMemoryDb!);
    _useInMemory = true;
    print('Using in-memory database (development mode)');
    print('Data seeded successfully!');
  }

  static bool get useInMemory => _useInMemory;
  static InMemoryDatabase get db => _inMemoryDb!;

  static Future<List<Map<String, dynamic>>> query(
    String sql, {
    Map<String, dynamic>? substitutionValues,
  }) async {
    if (!_useInMemory) throw Exception('PostgreSQL not configured');
    return [];
  }

  static Future<int> execute(
    String sql, {
    Map<String, dynamic>? substitutionValues,
  }) async {
    if (!_useInMemory) throw Exception('PostgreSQL not configured');
    return 0;
  }

  static Future<Map<String, dynamic>?> queryOne(
    String sql, {
    Map<String, dynamic>? substitutionValues,
  }) async {
    if (!_useInMemory) throw Exception('PostgreSQL not configured');
    return null;
  }
}
