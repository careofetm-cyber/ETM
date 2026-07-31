// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

_$EmployeeImpl _$$EmployeeImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      companyId: json['companyId'] as String,
      employeeCode: json['employeeCode'] as String?,
      department: json['department'] as String?,
      designation: json['designation'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      alternatePhone: json['alternatePhone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      homeLatitude: _toDouble(json['homeLatitude']),
      homeLongitude: _toDouble(json['homeLongitude']),
      homeAddress: json['homeAddress'] as String?,
      assignedRouteId: json['assignedRouteId'] as String?,
      assignedStopId: json['assignedStopId'] as String?,
      isTransportRequired: json['isTransportRequired'] as bool?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EmployeeImplToJson(_$EmployeeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'companyId': instance.companyId,
      'employeeCode': instance.employeeCode,
      'department': instance.department,
      'designation': instance.designation,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'alternatePhone': instance.alternatePhone,
      'email': instance.email,
      'address': instance.address,
      'homeLatitude': instance.homeLatitude,
      'homeLongitude': instance.homeLongitude,
      'homeAddress': instance.homeAddress,
      'assignedRouteId': instance.assignedRouteId,
      'assignedStopId': instance.assignedStopId,
      'isTransportRequired': instance.isTransportRequired,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$DriverImpl _$$DriverImplFromJson(Map<String, dynamic> json) => _$DriverImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      companyId: json['companyId'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      licenseExpiry: json['licenseExpiry'] == null
          ? null
          : DateTime.parse(json['licenseExpiry'] as String),
      phone: json['phone'] as String?,
      rating: _toDouble(json['rating']),
      totalTrips: _toInt(json['totalTrips']),
      isAvailable: json['isAvailable'] as bool?,
      isActive: json['isActive'] as bool?,
      assignedVehicleId: json['assignedVehicleId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DriverImplToJson(_$DriverImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'companyId': instance.companyId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'licenseNumber': instance.licenseNumber,
      'licenseExpiry': instance.licenseExpiry?.toIso8601String(),
      'phone': instance.phone,
      'rating': instance.rating,
      'totalTrips': instance.totalTrips,
      'isAvailable': instance.isAvailable,
      'isActive': instance.isActive,
      'assignedVehicleId': instance.assignedVehicleId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CompanyImpl _$$CompanyImplFromJson(Map<String, dynamic> json) =>
    _$CompanyImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      logo: json['logo'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      isActive: json['isActive'] as bool?,
      plan: json['plan'] as String?,
      favicon: json['favicon'] as String?,
      primaryColor: json['primaryColor'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      tripCostPerTrip: _toDouble(json['tripCostPerTrip']),
      minimumKmForBilling: _toDouble(json['minimumKmForBilling']),
      monthlyTripLimit: _toInt(json['monthlyTripLimit']),
      tripsUsedThisMonth: _toInt(json['tripsUsedThisMonth']),
      subscriptionStatus: json['subscriptionStatus'] as String?,
      subscriptionStartDate: json['subscriptionStartDate'] == null
          ? null
          : DateTime.parse(json['subscriptionStartDate'] as String),
      subscriptionEndDate: json['subscriptionEndDate'] == null
          ? null
          : DateTime.parse(json['subscriptionEndDate'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CompanyImplToJson(_$CompanyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'logo': instance.logo,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'isActive': instance.isActive,
      'plan': instance.plan,
      'favicon': instance.favicon,
      'primaryColor': instance.primaryColor,
      'backgroundColor': instance.backgroundColor,
      'tripCostPerTrip': instance.tripCostPerTrip,
      'minimumKmForBilling': instance.minimumKmForBilling,
      'monthlyTripLimit': instance.monthlyTripLimit,
      'tripsUsedThisMonth': instance.tripsUsedThisMonth,
      'subscriptionStatus': instance.subscriptionStatus,
      'subscriptionStartDate':
          instance.subscriptionStartDate?.toIso8601String(),
      'subscriptionEndDate': instance.subscriptionEndDate?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
