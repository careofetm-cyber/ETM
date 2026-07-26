import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

enum AttendanceStatus { present, absent, late, halfDay, onLeave }
enum BoardingMethod { qr, manual, gps }

@freezed
class Attendance with _$Attendance {
  const factory Attendance({
    required String id,
    required String employeeId,
    required DateTime date,
    required AttendanceStatus status,
    String? tripId,
    String? vehicleId,
    BoardingMethod? boardingMethod,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInLocation,
    String? checkOutLocation,
    String? companyId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);

  const Attendance._();

  String get statusDisplay {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.onLeave:
        return 'On Leave';
    }
  }
}

@freezed
class TransportRequest with _$TransportRequest {
  const factory TransportRequest({
    required String id,
    required String employeeId,
    required String companyId,
    required TransportRequestType type,
    required TransportRequestStatus status,
    String? routeId,
    String? stopId,
    DateTime? effectiveFrom,
    DateTime? effectiveTo,
    String? reason,
    String? rejectionReason,
    String? approvedBy,
    DateTime? approvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TransportRequest;

  factory TransportRequest.fromJson(Map<String, dynamic> json) => _$TransportRequestFromJson(json);
}

enum TransportRequestType { newRequest, routeChange, stopChange, cancellation }
enum TransportRequestStatus { pending, approved, rejected, cancelled }
