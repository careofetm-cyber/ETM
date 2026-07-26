import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class RouteApi {
  final ApiClient _client;
  
  RouteApi(this._client);
  
  Future<List<Route>> getRoutes({int page = 1, int limit = 20}) async {
    final response = await _client.dio.get('/routes', queryParameters: {
      'page': page,
      'limit': limit,
    });
    return (response.data['data'] as List).map((r) => Route.fromJson(r)).toList();
  }
  
  Future<Route> getRoute(String id) async {
    final response = await _client.dio.get('/routes/$id');
    return Route.fromJson(response.data);
  }
  
  Future<Route> createRoute(Map<String, dynamic> data) async {
    final response = await _client.dio.post('/routes', data: data);
    return Route.fromJson(response.data);
  }
  
  Future<Route> updateRoute(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put('/routes/$id', data: data);
    return Route.fromJson(response.data);
  }
  
  Future<void> deleteRoute(String id) async {
    await _client.dio.delete('/routes/$id');
  }
  
  Future<List<Stop>> getStops({int page = 1, int limit = 20}) async {
    final response = await _client.dio.get('/stops', queryParameters: {
      'page': page,
      'limit': limit,
    });
    return (response.data['data'] as List).map((s) => Stop.fromJson(s)).toList();
  }
  
  Future<Stop> createStop(Map<String, dynamic> data) async {
    final response = await _client.dio.post('/stops', data: data);
    return Stop.fromJson(response.data);
  }
  
  Future<Stop> updateStop(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.put('/stops/$id', data: data);
    return Stop.fromJson(response.data);
  }
  
  Future<void> deleteStop(String id) async {
    await _client.dio.delete('/stops/$id');
  }
}
