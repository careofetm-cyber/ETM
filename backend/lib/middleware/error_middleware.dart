import 'dart:convert';
import 'package:shelf/shelf.dart';

Map<String, dynamic> toCamelCase(Map<String, dynamic> map) {
  return map.map((key, value) {
    final camelKey = _snakeToCamel(key);
    if (value is Map<String, dynamic>) {
      return MapEntry(camelKey, toCamelCase(value));
    } else if (value is List) {
      return MapEntry(camelKey, value.map((e) {
        if (e is Map<String, dynamic>) {
          return toCamelCase(e);
        }
        return e;
      }).toList());
    }
    return MapEntry(camelKey, value);
  });
}

List<Map<String, dynamic>> toCamelCaseList(List<Map<String, dynamic>> list) {
  return list.map((e) => toCamelCase(e)).toList();
}

String _snakeToCamel(String snake) {
  if (!snake.contains('_')) return snake;
  final parts = snake.split('_');
  return parts[0] + parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

Middleware errorMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (error, stackTrace) {
        print('Error: $error');
        print('Stack trace: $stackTrace');
        
        if (error is FormatException) {
          return Response.badRequest(
            body: jsonEncode({'error': 'Invalid request format'}),
            headers: {'Content-Type': 'application/json'},
          );
        }
        
        return Response.internalServerError(
          body: jsonEncode({'error': 'Internal server error'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}

Response jsonResponse(Map<String, dynamic> data, {int statusCode = 200}) {
  return Response(
    statusCode,
    body: jsonEncode(toCamelCase(data)),
    headers: {'Content-Type': 'application/json'},
  );
}

Response errorResponse(String message, {int statusCode = 400}) {
  return Response(
    statusCode,
    body: jsonEncode({'error': message}),
    headers: {'Content-Type': 'application/json'},
  );
}

Response paginatedResponse(List<Map<String, dynamic>> data, int total, int page, int limit) {
  return jsonResponse({
    'data': data,
    'pagination': {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': (total / limit).ceil(),
    },
  });
}
