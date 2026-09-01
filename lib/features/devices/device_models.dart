import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_models.freezed.dart';
part 'device_models.g.dart';

/// Live values keyed by capability `key` (e.g. `{"power": true, "brightness": 80}`).
/// A raw map is enough — no capability-specific model needed (PRD §17: one renderer, no per-product code).
typedef DeviceState = Map<String, dynamic>;

@freezed
abstract class Capability with _$Capability {
  const factory Capability({
    required String id,
    required String key,
    required String name,

    /// One of: boolean, number, range, color.
    required String type,

    /// One of: read, write, read_write.
    required String mode,
    @JsonKey(name: 'min_value') num? min,
    @JsonKey(name: 'max_value') num? max,
    String? unit,
  }) = _Capability;

  factory Capability.fromJson(Map<String, dynamic> json) =>
      _$CapabilityFromJson(json);
}

@freezed
abstract class Device with _$Device {
  const factory Device({
    required String id,
    required String name,
    @JsonKey(name: 'product_id') required String productId,

    /// One of: UNCLAIMED, ONLINE, OFFLINE, DISABLED.
    @Default('UNCLAIMED') String status,
    @Default([]) List<Capability> capabilities,
  }) = _Device;

  const Device._();

  bool get online => status == 'ONLINE';

  factory Device.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    return _$DeviceFromJson({
      ...json,
      if (json['product_id'] == null && product is Map)
        'product_id': product['id'],
    });
  }
}
