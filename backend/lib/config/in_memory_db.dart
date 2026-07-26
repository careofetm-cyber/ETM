class InMemoryDatabase {
  static final InMemoryDatabase _instance = InMemoryDatabase._internal();
  factory InMemoryDatabase() => _instance;
  InMemoryDatabase._internal();

  final Map<String, List<Map<String, dynamic>>> _tables = {};

  void createTable(String name) {
    _tables[name] = [];
  }

  List<Map<String, dynamic>> findAll(String table, {
    Map<String, dynamic>? filters,
    int? limit,
    int? offset,
  }) {
    var results = _tables[table] ?? [];

    if (filters != null) {
      results = results.where((row) {
        return filters.entries.every((entry) {
          final value = row[entry.key];
          final filterValue = entry.value;
          if (filterValue == null) return true;
          if (filterValue is String && filterValue.contains('%')) {
            final pattern = filterValue.replaceAll('%', '').toLowerCase();
            return value?.toString().toLowerCase().contains(pattern) == true;
          }
          return value?.toString() == filterValue.toString();
        });
      }).toList();
    }

    if (offset != null && offset > 0) {
      results = results.skip(offset).toList();
    }
    if (limit != null) {
      results = results.take(limit).toList();
    }

    return results;
  }

  Map<String, dynamic>? findOne(String table, {Map<String, dynamic>? where}) {
    if (where == null) return _tables[table]?.isNotEmpty == true ? _tables[table]!.first : null;
    final results = findAll(table, filters: where);
    return results.isNotEmpty ? results.first : null;
  }

  int count(String table, {Map<String, dynamic>? filters}) {
    return findAll(table, filters: filters).length;
  }

  Map<String, dynamic> insert(String table, Map<String, dynamic> data) {
    _tables[table] ??= [];
    final row = Map<String, dynamic>.from(data);
    _tables[table]!.add(row);
    return row;
  }

  void update(String table, Map<String, dynamic> data, {required Map<String, dynamic> where}) {
    final rows = _tables[table] ?? [];
    for (var i = 0; i < rows.length; i++) {
      if (where.entries.every((e) => rows[i][e.key]?.toString() == e.value.toString())) {
        _tables[table]![i] = {...rows[i], ...data};
      }
    }
  }

  void delete(String table, {required Map<String, dynamic> where}) {
    _tables[table]?.removeWhere((row) {
      return where.entries.every((e) => row[e.key]?.toString() == e.value.toString());
    });
  }

  void deleteAll(String table) {
    _tables[table] = [];
  }

  List<Map<String, dynamic>> rawQuery(String sql, {Map<String, dynamic>? params}) {
    return [];
  }

  Map<String, dynamic> rawQueryOne(String sql, {Map<String, dynamic>? params}) {
    return {};
  }
}

class InMemoryRedis {
  static final InMemoryRedis _instance = InMemoryRedis._internal();
  factory InMemoryRedis() => _instance;
  InMemoryRedis._internal();

  final Map<String, String> _store = {};
  final Map<String, DateTime> _expiry = {};

  Future<void> set(String key, String value, {Duration? expiry}) async {
    _store[key] = value;
    if (expiry != null) {
      _expiry[key] = DateTime.now().add(expiry);
    }
  }

  Future<String?> get(String key) async {
    if (_expiry.containsKey(key) && DateTime.now().isAfter(_expiry[key]!)) {
      _store.remove(key);
      _expiry.remove(key);
      return null;
    }
    return _store[key];
  }

  Future<void> delete(String key) async {
    _store.remove(key);
    _expiry.remove(key);
  }

  Future<bool> exists(String key) async {
    if (_expiry.containsKey(key) && DateTime.now().isAfter(_expiry[key]!)) {
      _store.remove(key);
      _expiry.remove(key);
      return false;
    }
    return _store.containsKey(key);
  }
}
