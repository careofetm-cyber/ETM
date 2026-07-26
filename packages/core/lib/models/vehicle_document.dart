import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_document.freezed.dart';
part 'vehicle_document.g.dart';

@freezed
class VehicleDocument with _$VehicleDocument {
  const factory VehicleDocument({
    required String id,
    @JsonKey(name: 'vehicle_id') required String vehicleId,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'document_type') required String documentType,
    @JsonKey(name: 'document_number') String? documentNumber,
    @JsonKey(name: 'issue_date') String? issueDate,
    @JsonKey(name: 'expiry_date') String? expiryDate,
    @JsonKey(name: 'document_url') @Default('') String documentUrl,
    @Default('valid') String status,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _VehicleDocument;

  factory VehicleDocument.fromJson(Map<String, dynamic> json) => _$VehicleDocumentFromJson(json);
}
