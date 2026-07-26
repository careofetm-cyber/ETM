import 'package:freezed_annotation/freezed_annotation.dart';

part 'incident.freezed.dart';
part 'incident.g.dart';

enum IncidentSeverity { low, medium, high, critical }
enum IncidentStatus { reported, investigating, resolved, closed }

@freezed
class Incident with _$Incident {
  const factory Incident({
    required String id,
    required String reportedBy,
    required String? vehicleId,
    required String? tripId,
    required String? driverId,
    required IncidentSeverity severity,
    required IncidentStatus status,
    required String description,
    String? location,
    double? latitude,
    double? longitude,
    DateTime? incidentTime,
    List<String>? imageUrls,
    String? resolution,
    String? resolvedBy,
    DateTime? resolvedAt,
    String? companyId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Incident;

  factory Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);
}

@freezed
class SOSAlert with _$SOSAlert {
  const factory SOSAlert({
    required String id,
    required String userId,
    required String userType,
    required double latitude,
    required double longitude,
    String? message,
    required bool isResolved,
    String? resolvedBy,
    DateTime? resolvedAt,
    String? companyId,
    DateTime? createdAt,
  }) = _SOSAlert;

  factory SOSAlert.fromJson(Map<String, dynamic> json) => _$SOSAlertFromJson(json);
}
