// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Capability _$CapabilityFromJson(Map<String, dynamic> json) => _Capability(
  id: json['id'] as String,
  key: json['key'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  mode: json['mode'] as String,
  min: json['min_value'] as num?,
  max: json['max_value'] as num?,
  unit: json['unit'] as String?,
);

Map<String, dynamic> _$CapabilityToJson(_Capability instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'name': instance.name,
      'type': instance.type,
      'mode': instance.mode,
      'min_value': instance.min,
      'max_value': instance.max,
      'unit': instance.unit,
    };

_Device _$DeviceFromJson(Map<String, dynamic> json) => _Device(
  id: json['id'] as String,
  name: json['name'] as String,
  productId: json['product_id'] as String,
  status: json['status'] as String? ?? 'UNCLAIMED',
  capabilities:
      (json['capabilities'] as List<dynamic>?)
          ?.map((e) => Capability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DeviceToJson(_Device instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'product_id': instance.productId,
  'status': instance.status,
  'capabilities': instance.capabilities,
};
