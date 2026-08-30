// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AutomationAction _$AutomationActionFromJson(Map<String, dynamic> json) =>
    _AutomationAction(
      deviceId: json['device_id'] as String,
      capability: json['capability'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$AutomationActionToJson(_AutomationAction instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'capability': instance.capability,
      'value': instance.value,
    };

_Automation _$AutomationFromJson(Map<String, dynamic> json) => _Automation(
  id: json['id'] as String,
  name: json['name'] as String,
  enabled: json['enabled'] as bool? ?? true,
  actions:
      (json['actions'] as List<dynamic>?)
          ?.map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  trigger: json['trigger'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AutomationToJson(_Automation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enabled': instance.enabled,
      'actions': instance.actions,
      'trigger': instance.trigger,
    };

_AutomationDraft _$AutomationDraftFromJson(Map<String, dynamic> json) =>
    _AutomationDraft(
      summary: json['summary'] as String,
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map((e) => AutomationAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      trigger: json['trigger'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AutomationDraftToJson(_AutomationDraft instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'actions': instance.actions,
      'trigger': instance.trigger,
    };
