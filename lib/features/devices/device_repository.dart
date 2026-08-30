import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import 'device_models.dart';

class DeviceRepository {
  DeviceRepository(this._client);

  final ApiClient _client;

  Future<List<Device>> myDevices() async {
    final res = await _client.dio.get(Endpoints.myDevices);
    return (res.data as List).map((e) => Device.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<DeviceState> deviceState(String deviceId) async {
    final res = await _client.dio.get(Endpoints.deviceState(deviceId));
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<void> sendCommand(String deviceId, {required String capability, required dynamic value}) {
    return _client.dio.post(Endpoints.deviceCommands(deviceId), data: {'capability': capability, 'value': value});
  }

  Future<Device> claim({required String deviceCode, required String pairingToken}) async {
    final res = await _client.dio.post(
      Endpoints.claimDevice,
      data: {'device_code': deviceCode, 'pairing_token': pairingToken},
    );
    return Device.fromJson(res.data as Map<String, dynamic>);
  }
}
