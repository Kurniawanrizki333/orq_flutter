import 'package:freezed_annotation/freezed_annotation.dart';

part 'automation_models.freezed.dart';
part 'automation_models.g.dart';

@freezed
abstract class AutomationAction with _$AutomationAction {
  const factory AutomationAction({
    @JsonKey(name: 'device_id') required String deviceId,
    required String capability,
    required dynamic value,
  }) = _AutomationAction;

  factory AutomationAction.fromJson(Map<String, dynamic> json) =>
      _$AutomationActionFromJson(json);
}

@freezed
abstract class Automation with _$Automation {
  const factory Automation({
    required String id,
    required String name,
    @Default(true) bool enabled,
    @Default([]) List<AutomationAction> actions,

    /// Public trigger contract: device or schedule scalar payload.
    Map<String, dynamic>? trigger,
  }) = _Automation;

  factory Automation.fromJson(Map<String, dynamic> json) =>
      _$AutomationFromJson(json);
}

/// AI-generated preview — not persisted until the user confirms.
@freezed
abstract class AutomationDraft with _$AutomationDraft {
  const factory AutomationDraft({
    required String summary,
    @Default([]) List<AutomationAction> actions,
    Map<String, dynamic>? trigger,
  }) = _AutomationDraft;

  factory AutomationDraft.fromJson(Map<String, dynamic> json) =>
      _$AutomationDraftFromJson(json);
}
