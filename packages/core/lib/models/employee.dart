import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
class Employee with _$Employee {
  const factory Employee({
    required String id,
    required String userId,
    required String companyId,
    String? employeeCode,
    String? department,
    String? designation,
    String? phone,
    String? alternatePhone,
    String? email,
    String? address,
    double? homeLatitude,
    double? homeLongitude,
    String? homeAddress,
    String? assignedRouteId,
    String? assignedStopId,
    bool? isTransportRequired,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Employee;

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
}

@freezed
class Driver with _$Driver {
  const factory Driver({
    required String id,
    required String userId,
    required String companyId,
    String? licenseNumber,
    DateTime? licenseExpiry,
    String? phone,
    double? rating,
    int? totalTrips,
    bool? isAvailable,
    bool? isActive,
    String? assignedVehicleId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Driver;

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
}

@freezed
class Company with _$Company {
  const factory Company({
    required String id,
    required String name,
    String? slug,
    String? logo,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    bool? isActive,
    String? plan,
    String? favicon,
    String? primaryColor,
    String? backgroundColor,
    double? tripCostPerTrip,
    double? minimumKmForBilling,
    int? monthlyTripLimit,
    int? tripsUsedThisMonth,
    String? subscriptionStatus,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Company;

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
}
