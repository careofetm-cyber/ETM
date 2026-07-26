// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VehicleDocumentImpl _$$VehicleDocumentImplFromJson(
        Map<String, dynamic> json) =>
    _$VehicleDocumentImpl(
      id: json['id'] as String,
      vehicleId: json['vehicle_id'] as String,
      companyId: json['company_id'] as String,
      documentType: json['document_type'] as String,
      documentNumber: json['document_number'] as String?,
      issueDate: json['issue_date'] as String?,
      expiryDate: json['expiry_date'] as String?,
      documentUrl: json['document_url'] as String? ?? '',
      status: json['status'] as String? ?? 'valid',
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$VehicleDocumentImplToJson(
        _$VehicleDocumentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle_id': instance.vehicleId,
      'company_id': instance.companyId,
      'document_type': instance.documentType,
      'document_number': instance.documentNumber,
      'issue_date': instance.issueDate,
      'expiry_date': instance.expiryDate,
      'document_url': instance.documentUrl,
      'status': instance.status,
      'created_at': instance.createdAt,
    };
