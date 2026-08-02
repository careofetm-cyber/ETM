// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingRecordImpl _$$BillingRecordImplFromJson(Map<String, dynamic> json) =>
    _$BillingRecordImpl(
      id: (json['id'] ?? '').toString(),
      companyId: (json['companyId'] ?? json['company_id'] ?? '').toString(),
      tripId: (json['tripId'] ?? json['trip_id'] ?? '').toString(),
      tripCost: _toDouble(json['tripCost'] ?? json['trip_cost']),
      distance: _toDouble(json['distance'] ?? json['total_distance']),
      duration: _toDoubleNullable(json['duration']),
      passengers: _toIntNullable(json['passengers']),
      isBillable: json['isBillable'] ?? json['is_billable'],
      discardReason: json['discardReason'] ?? json['discard_reason'] as String?,
      completedAt: _parseDateTime(json['completedAt'] ?? json['completed_at']),
      month: json['month'] as String?,
      createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
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
      id: (json['id'] ?? '').toString(),
      companyId: (json['companyId'] ?? json['company_id'] ?? '').toString(),
      month: (json['month'] ?? '').toString(),
      totalTrips: _toInt(json['totalTrips'] ?? json['trip_count']),
      billableTrips: _toInt(json['billableTrips'] ?? json['billable_trips'] ?? 0),
      discardedTrips: _toInt(json['discardedTrips'] ?? json['discarded_trips'] ?? 0),
      totalAmount: _toDouble(json['totalAmount'] ?? json['total_amount']),
      status: (json['status'] ?? 'pending').toString(),
      dueDate: _parseDateTime(json['dueDate'] ?? json['due_date']),
      paidAt: _parseDateTime(json['paidAt'] ?? json['paid_at']),
      createdAt: _parseDateTime(json['createdAt'] ?? json['created_at']),
      updatedAt: _parseDateTime(json['updatedAt'] ?? json['updated_at']),
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
      companyId: (json['companyId'] ?? json['company_id'] ?? '').toString(),
      companyName: (json['companyName'] ?? json['company_name'] ?? '').toString(),
      totalTripsThisMonth: _toInt(json['totalTripsThisMonth'] ?? json['total_trips_this_month'] ?? json['totalTrips'] ?? json['total_trips'] ?? 0),
      billableTripsThisMonth: _toInt(json['billableTripsThisMonth'] ?? json['billable_trips_this_month'] ?? json['billableTrips'] ?? json['billable_trips'] ?? 0),
      discardedTripsThisMonth: _toInt(json['discardedTripsThisMonth'] ?? json['discarded_trips_this_month'] ?? 0),
      totalAmountThisMonth: _toDouble(json['totalAmountThisMonth'] ?? json['total_amount_this_month'] ?? json['totalAmount'] ?? json['total_amount'] ?? 0),
      monthlyTripLimit: _toInt(json['monthlyTripLimit'] ?? json['monthly_trip_limit'] ?? 0),
      tripCostPerTrip: _toDouble(json['tripCostPerTrip'] ?? json['trip_cost_per_trip'] ?? 0),
      minimumKmForBilling: _toDouble(json['minimumKmForBilling'] ?? json['minimum_km_for_billing'] ?? 0),
      plan: (json['plan'] ?? 'basic').toString(),
      subscriptionStatus: (json['subscriptionStatus'] ?? json['subscription_status'] ?? 'active').toString(),
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

double _toDouble(dynamic v) => (v as num?)?.toDouble() ?? 0.0;
double? _toDoubleNullable(dynamic v) => (v as num?)?.toDouble();
int _toInt(dynamic v) => (v as num?)?.toInt() ?? 0;
int? _toIntNullable(dynamic v) => (v as num?)?.toInt();
DateTime? _parseDateTime(dynamic v) {
  if (v == null) return null;
  try { return DateTime.parse(v.toString()); } catch (_) { return null; }
}
