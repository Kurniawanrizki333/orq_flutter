import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import 'device_models.dart';

class DeviceRepository {
  DeviceRepository(this._client);

  final ApiClient _client;

  Future<List<Device>> myDevices() async {
    final res = await _client.dio.get(Endpoints.myDevices);
    return (res.data as List)
        .map((e) => Device.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DeviceState> deviceState(String deviceId) async {
    final res = await _client.dio.get(Endpoints.deviceState(deviceId));
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<void> sendCommand(
    String deviceId, {
    required String capability,
    required dynamic value,
  }) {
    return _client.dio.post(
      Endpoints.deviceCommands(deviceId),
      data: {'capability': capability, 'value': value},
    );
  }

  Future<void> unclaim(String deviceId) {
    return _client.dio.delete(Endpoints.deviceClaim(deviceId));
  }

  Future<Device> claim({
    required String deviceCode,
    required String pairingToken,
  }) async {
    final res = await _client.dio.post(
      Endpoints.claimDevice,
      data: {'device_code': deviceCode, 'pairing_token': pairingToken},
    );
    return Device.fromJson(res.data as Map<String, dynamic>);
  }

  Future<ClaimPreview> claimPreview({
    required String deviceCode,
    required String pairingToken,
  }) async {
    final res = await _client.dio.post(
      Endpoints.claimPreview,
      data: {'device_code': deviceCode, 'pairing_token': pairingToken},
    );
    return ClaimPreview.fromJson(res.data as Map<String, dynamic>);
  }
}

class ClaimPreview {
  const ClaimPreview({
    required this.deviceCode,
    required this.name,
    required this.productId,
    required this.productName,
    required this.productCategory,
    required this.capabilities,
  });

  factory ClaimPreview.fromJson(Map<String, dynamic> json) {
    final device = json['device'] as Map<String, dynamic>;
    final product = json['product'] as Map<String, dynamic>;
    return ClaimPreview(
      deviceCode: device['device_code'] as String,
      name: device['name'] as String,
      productId: product['id'] as String,
      productName: product['name'] as String,
      productCategory: product['category'] as String?,
      capabilities: (json['capabilities'] as List)
          .map((item) => Capability.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final String deviceCode;
  final String name;
  final String productId;
  final String productName;
  final String? productCategory;
  final List<Capability> capabilities;
}
