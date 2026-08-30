import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import 'automation_models.dart';

class AutomationRepository {
  AutomationRepository(this._client);

  final ApiClient _client;

  Future<List<Automation>> list() async {
    final res = await _client.dio.get(Endpoints.automations);
    return (res.data as List).map((e) => Automation.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AutomationDraft> generate(String prompt) async {
    final res = await _client.dio.post(Endpoints.automationGenerate, data: {'prompt': prompt});
    return AutomationDraft.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Automation> create({
    required String name,
    required List<AutomationAction> actions,
    Map<String, dynamic>? trigger,
  }) async {
    final res = await _client.dio.post(
      Endpoints.automations,
      data: {
        'name': name,
        'actions': actions.map((a) => a.toJson()).toList(),
        'trigger': ?trigger,
      },
    );
    return Automation.fromJson(res.data as Map<String, dynamic>);
  }
}
