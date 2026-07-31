import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

enum TripStatus { scheduled, inProgress, completed, cancelled }
enum TripType { pickup, dropoff, drop }

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String routeId,
    required String vehicleId,
    required String driverId,
    required TripType type,
    required TripStatus status,
    required DateTime scheduledTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    String? companyId,
    int? totalPassengers,
    int? boardedPassengers,
    double? totalDistance,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  const Trip._();

  bool get isUpcoming => status == TripStatus.scheduled;
  bool get isActive => status == TripStatus.inProgress;
  bool get isCompleted => status == TripStatus.completed;
  
  String get statusDisplay {
    switch (status) {
      case TripStatus.scheduled:
        return 'Scheduled';
      case TripStatus.inProgress:
        return 'In Progress';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.cancelled:
        return 'Cancelled';
    }
  }
}

@freezed
class TripPassenger with _$TripPassenger {
  const factory TripPassenger({
    required String id,
    required String tripId,
    required String employeeId,
    required String stopId,
    bool? isBoarded,
    bool? isDropped,
    DateTime? boardedAt,
    DateTime? droppedAt,
    DateTime? createdAt,
  }) = _TripPassenger;

  factory TripPassenger.fromJson(Map<String, dynamic> json) => _$TripPassengerFromJson(json);
}

@freezed
class GPSLog with _$GPSLog {
  const factory GPSLog({
    required String id,
    required String vehicleId,
    String? tripId,
    required double latitude,
    required double longitude,
    double? speed,
    double? heading,
    double? altitude,
    required DateTime timestamp,
  }) = _GPSLog;

  factory GPSLog.fromJson(Map<String, dynamic> json) => _$GPSLogFromJson(json);
}

@freezed
class LocationUpdate with _$LocationUpdate {
  const factory LocationUpdate({
    required String vehicleId,
    required double latitude,
    required double longitude,
    double? speed,
    double? heading,
    DateTime? timestamp,
  }) = _LocationUpdate;

  factory LocationUpdate.fromJson(Map<String, dynamic> json) => _$LocationUpdateFromJson(json);
}
