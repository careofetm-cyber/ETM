import 'package:freezed_annotation/freezed_annotation.dart';

part 'route.freezed.dart';
part 'route.g.dart';

@freezed
class Route with _$Route {
  const factory Route({
    required String id,
    required String name,
    required String companyId,
    String? description,
    required List<RouteStop> stops,
    required double totalDistance,
    required int estimatedDuration,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Route;

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);
}

@freezed
class RouteStop with _$RouteStop {
  const factory RouteStop({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required int sequenceOrder,
    String? address,
    String? landmark,
    int? estimatedTimeFromPrevious,
    double? distanceFromPrevious,
  }) = _RouteStop;

  factory RouteStop.fromJson(Map<String, dynamic> json) => _$RouteStopFromJson(json);
}

@freezed
class Stop with _$Stop {
  const factory Stop({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    String? landmark,
    String? companyId,
    DateTime? createdAt,
  }) = _Stop;

  factory Stop.fromJson(Map<String, dynamic> json) => _$StopFromJson(json);
}
