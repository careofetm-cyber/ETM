// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FuelLogImpl _$$FuelLogImplFromJson(Map<String, dynamic> json) =>
    _$FuelLogImpl(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      driverId: json['driverId'] as String,
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      odometerReading: (json['odometerReading'] as num).toDouble(),
      fuelType: json['fuelType'] as String?,
      gasStation: json['gasStation'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FuelLogImplToJson(_$FuelLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'driverId': instance.driverId,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'pricePerUnit': instance.pricePerUnit,
      'totalCost': instance.totalCost,
      'odometerReading': instance.odometerReading,
      'fuelType': instance.fuelType,
      'gasStation': instance.gasStation,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$MaintenanceImpl _$$MaintenanceImplFromJson(Map<String, dynamic> json) =>
    _$MaintenanceImpl(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      type: $enumDecode(_$MaintenanceTypeEnumMap, json['type']),
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      status: $enumDecode(_$MaintenanceStatusEnumMap, json['status']),
      description: json['description'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
      serviceProvider: json['serviceProvider'] as String?,
      odometerAtService: (json['odometerAtService'] as num?)?.toInt(),
      nextServiceOdometer: (json['nextServiceOdometer'] as num?)?.toInt(),
      nextServiceDate: json['nextServiceDate'] == null
          ? null
          : DateTime.parse(json['nextServiceDate'] as String),
      notes: json['notes'] as String?,
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MaintenanceImplToJson(_$MaintenanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'type': _$MaintenanceTypeEnumMap[instance.type]!,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'completedDate': instance.completedDate?.toIso8601String(),
      'status': _$MaintenanceStatusEnumMap[instance.status]!,
      'description': instance.description,
      'cost': instance.cost,
      'serviceProvider': instance.serviceProvider,
      'odometerAtService': instance.odometerAtService,
      'nextServiceOdometer': instance.nextServiceOdometer,
      'nextServiceDate': instance.nextServiceDate?.toIso8601String(),
      'notes': instance.notes,
      'documents': instance.documents,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$MaintenanceTypeEnumMap = {
  MaintenanceType.regularService: 'regularService',
  MaintenanceType.oilChange: 'oilChange',
  MaintenanceType.tireRotation: 'tireRotation',
  MaintenanceType.brakeService: 'brakeService',
  MaintenanceType.batteryReplacement: 'batteryReplacement',
  MaintenanceType.engineRepair: 'engineRepair',
  MaintenanceType.bodyWork: 'bodyWork',
  MaintenanceType.other: 'other',
};

const _$MaintenanceStatusEnumMap = {
  MaintenanceStatus.scheduled: 'scheduled',
  MaintenanceStatus.inProgress: 'inProgress',
  MaintenanceStatus.completed: 'completed',
  MaintenanceStatus.overdue: 'overdue',
};
