// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingRecordImpl _$$BillingRecordImplFromJson(Map<String, dynamic> json) =>
    _$BillingRecordImpl(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      tripId: json['tripId'] as String,
      tripCost: (json['tripCost'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
      passengers: (json['passengers'] as num?)?.toInt(),
      isBillable: json['isBillable'] as bool?,
      discardReason: json['discardReason'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      month: json['month'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BillingRecordImplToJson(_$BillingRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'tripId': instance.tripId,
      'tripCost': instance.tripCost,
      'distance': instance.distance,
      'duration': instance.duration,
      'passengers': instance.passengers,
      'isBillable': instance.isBillable,
      'discardReason': instance.discardReason,
      'completedAt': instance.completedAt?.toIso8601String(),
      'month': instance.month,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String,
      companyId: json['companyId'] as String,
      month: json['month'] as String,
      totalTrips: (json['totalTrips'] as num).toInt(),
      billableTrips: (json['billableTrips'] as num).toInt(),
      discardedTrips: (json['discardedTrips'] as num).toInt(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyId': instance.companyId,
      'month': instance.month,
      'totalTrips': instance.totalTrips,
      'billableTrips': instance.billableTrips,
      'discardedTrips': instance.discardedTrips,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
      'dueDate': instance.dueDate?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$CompanyBillingSummaryImpl _$$CompanyBillingSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanyBillingSummaryImpl(
      companyId: json['companyId'] as String,
      companyName: json['companyName'] as String,
      totalTripsThisMonth: (json['totalTripsThisMonth'] as num).toInt(),
      billableTripsThisMonth: (json['billableTripsThisMonth'] as num).toInt(),
      discardedTripsThisMonth: (json['discardedTripsThisMonth'] as num).toInt(),
      totalAmountThisMonth: (json['totalAmountThisMonth'] as num).toDouble(),
      monthlyTripLimit: (json['monthlyTripLimit'] as num).toInt(),
      tripCostPerTrip: (json['tripCostPerTrip'] as num).toDouble(),
      minimumKmForBilling: (json['minimumKmForBilling'] as num).toDouble(),
      plan: json['plan'] as String,
      subscriptionStatus: json['subscriptionStatus'] as String,
    );

Map<String, dynamic> _$$CompanyBillingSummaryImplToJson(
        _$CompanyBillingSummaryImpl instance) =>
    <String, dynamic>{
      'companyId': instance.companyId,
      'companyName': instance.companyName,
      'totalTripsThisMonth': instance.totalTripsThisMonth,
      'billableTripsThisMonth': instance.billableTripsThisMonth,
      'discardedTripsThisMonth': instance.discardedTripsThisMonth,
      'totalAmountThisMonth': instance.totalAmountThisMonth,
      'monthlyTripLimit': instance.monthlyTripLimit,
      'tripCostPerTrip': instance.tripCostPerTrip,
      'minimumKmForBilling': instance.minimumKmForBilling,
      'plan': instance.plan,
      'subscriptionStatus': instance.subscriptionStatus,
    };
