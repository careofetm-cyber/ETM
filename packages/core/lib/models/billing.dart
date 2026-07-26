import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing.freezed.dart';
part 'billing.g.dart';

@freezed
class BillingRecord with _$BillingRecord {
  const factory BillingRecord({
    required String id,
    required String companyId,
    required String tripId,
    required double tripCost,
    required double distance,
    double? duration,
    int? passengers,
    bool? isBillable,
    String? discardReason,
    DateTime? completedAt,
    String? month,
    DateTime? createdAt,
  }) = _BillingRecord;

  factory BillingRecord.fromJson(Map<String, dynamic> json) => _$BillingRecordFromJson(json);
}

@freezed
class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String companyId,
    required String month,
    required int totalTrips,
    required int billableTrips,
    required int discardedTrips,
    required double totalAmount,
    required String status,
    DateTime? dueDate,
    DateTime? paidAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
}

@freezed
class CompanyBillingSummary with _$CompanyBillingSummary {
  const factory CompanyBillingSummary({
    required String companyId,
    required String companyName,
    required int totalTripsThisMonth,
    required int billableTripsThisMonth,
    required int discardedTripsThisMonth,
    required double totalAmountThisMonth,
    required int monthlyTripLimit,
    required double tripCostPerTrip,
    required double minimumKmForBilling,
    required String plan,
    required String subscriptionStatus,
  }) = _CompanyBillingSummary;

  factory CompanyBillingSummary.fromJson(Map<String, dynamic> json) => _$CompanyBillingSummaryFromJson(json);
}
