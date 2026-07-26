import 'package:shelf/shelf.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Middleware authMiddleware({List<String>? requiredRoles}) {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden('Missing or invalid authorization header');
      }
      
      final token = authHeader.substring(7);
      
      try {
        final jwt = JWT.verify(token, SecretKey('your-secret-key'));
        final payload = jwt.payload;
        
        final userId = payload['userId'] as String?;
        final role = payload['role'] as String?;
        
        if (userId == null || role == null) {
          return Response.forbidden('Invalid token payload');
        }
        
        if (requiredRoles != null && !requiredRoles.contains(role)) {
          return Response.forbidden('Insufficient permissions');
        }
        
        // Add user info to request context
        final updatedRequest = request.change(context: {
          'userId': userId,
          'role': role,
          'companyId': payload['companyId'],
        });
        
        return await innerHandler(updatedRequest);
      } catch (e) {
        return Response.forbidden('Invalid or expired token');
      }
    };
  };
}

String generateToken({
  required String userId,
  required String role,
  String? companyId,
}) {
  final jwt = JWT({
    'userId': userId,
    'role': role,
    if (companyId != null) 'companyId': companyId,
    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'exp': DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
  });
  
  return jwt.sign(SecretKey('your-secret-key'));
}

String generateRefreshToken({
  required String userId,
  required String role,
  String? companyId,
}) {
  final jwt = JWT({
    'userId': userId,
    'role': role,
    if (companyId != null) 'companyId': companyId,
    'type': 'refresh',
    'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'exp': DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
  });
  
  return jwt.sign(SecretKey('your-refresh-secret-key'));
}
