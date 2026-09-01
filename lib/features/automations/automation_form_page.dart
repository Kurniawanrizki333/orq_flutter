import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/responsive_page.dart';
import '../../core/widgets/section_card.dart';
import '../devices/device_models.dart';
import '../devices/device_providers.dart';
import 'automation_models.dart';
import 'automation_providers.dart';

class AutomationFormPage extends ConsumerStatefulWidget {
  const AutomationFormPage({super.key});

  @override
  ConsumerState<AutomationFormPage> createState() => _AutomationFormPageState();
}

class _AutomationFormPageState extends ConsumerState<AutomationFormPage> {
  final _manualKey = GlobalKey<FormState>();
  final _prompt = TextEditingController();
  final _manualName = TextEditingController();
  final _manualValue = TextEditingController();
  final _triggerValue = TextEditingController();
  String _mode = 'ai';
  String _triggerOperator = '>';
  String _triggerType = 'device';
  String? _triggerDeviceId;
  String? _triggerCapability;
  String? _actionDeviceId;
  String? _actionCapability;

  AutomationDraft? _draft;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _prompt.dispose();
    _manualName.dispose();
    _manualValue.dispose();
    _triggerValue.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_prompt.text.trim().isEmpty) {
      setState(() => _error = 'Describe the automation first.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final draft = await ref
          .read(automationRepositoryProvider)
          .generate(_prompt.text.trim());
      setState(() => _draft = draft);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDraft() async {
    final draft = _draft;
    if (draft == null) return;
    await _save(
      name: draft.summary,
      actions: draft.actions,
      trigger: draft.trigger,
    );
  }

  static dynamic _coerce(String raw) {
    final t = raw.trim();
    if (t == 'true') return true;
    if (t == 'false') return false;
    return num.tryParse(t) ?? t;
  }

  Capability? _capability(List<Device> devices, String? deviceId, String? key) {
    final device = devices.where((item) => item.id == deviceId).firstOrNull;
    return device?.capabilities.where((item) => item.key == key).firstOrNull;
  }

  Future<void> _saveManual() async {
    if (!_manualKey.currentState!.validate()) return;
    final actionDeviceId = _actionDeviceId;
    final actionCapability = _actionCapability;
    final triggerDeviceId = _triggerDeviceId;
    final triggerCapability = _triggerCapability;
    if (actionDeviceId == null || actionCapability == null) {
      setState(() => _error = 'Select action device and capability first.');
      return;
    }
    if (_triggerType == 'device' &&
        (triggerDeviceId == null || triggerCapability == null)) {
      setState(() => _error = 'Select trigger device and capability first.');
      return;
    }
    await _save(
      name: _manualName.text.trim(),
      actions: [
        AutomationAction(
          deviceId: actionDeviceId,
          capability: actionCapability,
          value: _coerce(_manualValue.text),
        ),
      ],
      trigger: _triggerType == 'schedule'
          ? {'type': 'schedule', 'at': _triggerValue.text.trim()}
          : {
              'type': 'device',
              'device_id': triggerDeviceId,
              'capability': triggerCapability,
              'operator': _triggerOperator,
              'value': _coerce(_triggerValue.text),
            },
    );
  }

  Future<void> _save({
    required String name,
    required List<AutomationAction> actions,
    Map<String, dynamic>? trigger,
  }) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(automationRepositoryProvider)
          .create(name: name, actions: actions, trigger: trigger);
      ref.invalidate(automationsProvider);
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final devices = ref.watch(myDevicesProvider).value ?? const <Device>[];
    final triggerCapability = _capability(
      devices,
      _triggerDeviceId,
      _triggerCapability,
    );
    final actionCapability = _capability(
      devices,
      _actionDeviceId,
      _actionCapability,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('New automation')),
      body: ListView(
        children: [
          ResponsivePage(
            maxWidth: 760,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Build automation',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create AI-assisted or manual rules for capability-driven devices.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'ai',
                            label: Text('AI assistant'),
                            icon: Icon(Icons.auto_awesome),
                          ),
                          ButtonSegment(
                            value: 'manual',
                            label: Text('Manual'),
                            icon: Icon(Icons.tune),
                          ),
                        ],
                        selected: {_mode},
                        onSelectionChanged: (value) =>
                            setState(() => _mode = value.first),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_error != null) ...[
                  _ErrorBanner(message: _error!),
                  const SizedBox(height: 16),
                ],
                if (_mode == 'ai')
                  _AiBuilder(
                    draft: _draft,
                    busy: _busy,
                    prompt: _prompt,
                    onGenerate: _generate,
                    onConfirm: _confirmDraft,
                  ),
                if (_mode == 'manual')
                  _ManualBuilder(
                    formKey: _manualKey,
                    busy: _busy,
                    devices: devices,
                    name: _manualName,
                    triggerType: _triggerType,
                    triggerValue: _triggerValue,
                    actionValue: _manualValue,
                    triggerOperator: _triggerOperator,
                    triggerDeviceId: _triggerDeviceId,
                    triggerCapability: _triggerCapability,
                    actionDeviceId: _actionDeviceId,
                    actionCapability: _actionCapability,
                    triggerCapabilityModel: triggerCapability,
                    actionCapabilityModel: actionCapability,
                    onTriggerTypeChanged: (v) =>
                        setState(() => _triggerType = v),
                    onOperatorChanged: (v) =>
                        setState(() => _triggerOperator = v ?? '>'),
                    onTriggerDeviceChanged: (v) => setState(() {
                      _triggerDeviceId = v;
                      _triggerCapability = null;
                    }),
                    onTriggerCapabilityChanged: (v) => setState(() {
                      _triggerCapability = v;
                      final type = _capability(
                        devices,
                        _triggerDeviceId,
                        v,
                      )?.type;
                      _triggerOperator = type == 'number' || type == 'range'
                          ? '>'
                          : '=';
                      _triggerValue.clear();
                    }),
                    onActionDeviceChanged: (v) => setState(() {
                      _actionDeviceId = v;
                      _actionCapability = null;
                    }),
                    onActionCapabilityChanged: (v) => setState(() {
                      _actionCapability = v;
                      _manualValue.clear();
                    }),
                    onSave: _saveManual,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiBuilder extends StatelessWidget {
  const _AiBuilder({
    required this.draft,
    required this.busy,
    required this.prompt,
    required this.onGenerate,
    required this.onConfirm,
  });

  final AutomationDraft? draft;
  final bool busy;
  final TextEditingController prompt;
  final VoidCallback onGenerate;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Describe it',
      subtitle: 'Example: Turn off the living room lights at 11pm.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: prompt,
            decoration: const InputDecoration(
              hintText: 'What should Orqestra automate?',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: busy ? null : onGenerate,
            icon: busy
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.auto_awesome),
            label: const Text('Generate draft'),
          ),
          if (draft != null) ...[
            const SizedBox(height: 16),
            Text(
              draft!.summary,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Trigger: ${draft!.trigger ?? 'Not specified'}'),
            const SizedBox(height: 8),
            for (final action in draft!.actions)
              Text(
                '${action.deviceId}: ${action.capability} = ${action.value}',
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: busy ? null : onConfirm,
              child: const Text('Confirm & save'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ManualBuilder extends StatelessWidget {
  const _ManualBuilder({
    required this.formKey,
    required this.busy,
    required this.devices,
    required this.name,
    required this.triggerType,
    required this.triggerValue,
    required this.actionValue,
    required this.triggerOperator,
    required this.triggerDeviceId,
    required this.triggerCapability,
    required this.actionDeviceId,
    required this.actionCapability,
    required this.triggerCapabilityModel,
    required this.actionCapabilityModel,
    required this.onTriggerTypeChanged,
    required this.onOperatorChanged,
    required this.onTriggerDeviceChanged,
    required this.onTriggerCapabilityChanged,
    required this.onActionDeviceChanged,
    required this.onActionCapabilityChanged,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final bool busy;
  final List<Device> devices;
  final TextEditingController name;
  final String triggerType;
  final TextEditingController triggerValue;
  final TextEditingController actionValue;
  final String triggerOperator;
  final String? triggerDeviceId;
  final String? triggerCapability;
  final String? actionDeviceId;
  final String? actionCapability;
  final Capability? triggerCapabilityModel;
  final Capability? actionCapabilityModel;
  final ValueChanged<String> onTriggerTypeChanged;
  final ValueChanged<String?> onOperatorChanged;
  final ValueChanged<String?> onTriggerDeviceChanged;
  final ValueChanged<String?> onTriggerCapabilityChanged;
  final ValueChanged<String?> onActionDeviceChanged;
  final ValueChanged<String?> onActionCapabilityChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Manual rule',
      subtitle: 'One trigger and one action are supported in this MVP flow.',
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Rule name'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Rule name required' : null,
            ),
            const SizedBox(height: 16),
            Text('When', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'device', label: Text('Device state')),
                ButtonSegment(value: 'schedule', label: Text('Schedule')),
              ],
              selected: {triggerType},
              onSelectionChanged: (value) => onTriggerTypeChanged(value.first),
            ),
            const SizedBox(height: 12),
            if (triggerType == 'schedule')
              TextFormField(
                controller: triggerValue,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'HH:mm',
                ),
                validator: (value) =>
                    RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(value ?? '')
                    ? null
                    : 'Use 24-hour HH:mm',
              )
            else ...[
              _DeviceDropdown(
                value: triggerDeviceId,
                devices: devices,
                label: 'Trigger device',
                onChanged: onTriggerDeviceChanged,
              ),
              const SizedBox(height: 8),
              _CapabilityDropdown(
                deviceId: triggerDeviceId,
                value: triggerCapability,
                devices: devices,
                label: 'Trigger capability',
                readable: true,
                onChanged: onTriggerCapabilityChanged,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                key: ValueKey(
                  '${triggerCapabilityModel?.type}:$triggerOperator',
                ),
                initialValue:
                    _operators(triggerCapabilityModel).contains(triggerOperator)
                    ? triggerOperator
                    : null,
                decoration: const InputDecoration(labelText: 'Operator'),
                items: [
                  for (final operator in _operators(triggerCapabilityModel))
                    DropdownMenuItem(
                      value: operator,
                      child: Text(_operatorLabel(operator)),
                    ),
                ],
                onChanged: onOperatorChanged,
              ),
              const SizedBox(height: 8),
              _TypedValueField(
                capability: triggerCapabilityModel,
                controller: triggerValue,
                label: 'Trigger value',
              ),
            ],
            const SizedBox(height: 16),
            Text('Then', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            _DeviceDropdown(
              value: actionDeviceId,
              devices: devices,
              label: 'Action device',
              onChanged: onActionDeviceChanged,
            ),
            const SizedBox(height: 8),
            _CapabilityDropdown(
              deviceId: actionDeviceId,
              value: actionCapability,
              devices: devices,
              label: 'Action capability',
              readable: false,
              onChanged: onActionCapabilityChanged,
            ),
            const SizedBox(height: 8),
            _TypedValueField(
              capability: actionCapabilityModel,
              controller: actionValue,
              label: 'Action value',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: busy ? null : onSave,
              child: const Text('Save manual rule'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceDropdown extends StatelessWidget {
  const _DeviceDropdown({
    required this.value,
    required this.devices,
    required this.label,
    required this.onChanged,
  });

  final String? value;
  final List<Device> devices;
  final String label;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final device in devices)
          DropdownMenuItem(value: device.id, child: Text(device.name)),
      ],
      onChanged: onChanged,
      validator: (v) => v == null ? '$label required' : null,
    );
  }
}

class _CapabilityDropdown extends StatelessWidget {
  const _CapabilityDropdown({
    required this.deviceId,
    required this.value,
    required this.devices,
    required this.label,
    required this.readable,
    required this.onChanged,
  });

  final String? deviceId;
  final String? value;
  final List<Device> devices;
  final String label;
  final bool readable;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final device = devices.where((d) => d.id == deviceId).firstOrNull;
    final capabilities = (device?.capabilities ?? const <Capability>[])
        .where(
          (capability) =>
              const {
                'boolean',
                'number',
                'range',
                'color',
              }.contains(capability.type) &&
              (readable
                  ? capability.mode == 'read' || capability.mode == 'read_write'
                  : capability.mode == 'write' ||
                        capability.mode == 'read_write'),
        )
        .toList();
    return DropdownButtonFormField<String>(
      initialValue: capabilities.any((c) => c.key == value) ? value : null,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final capability in capabilities)
          DropdownMenuItem(value: capability.key, child: Text(capability.name)),
      ],
      onChanged: capabilities.isEmpty ? null : onChanged,
      validator: (v) => v == null ? '$label required' : null,
    );
  }
}

List<String> _operators(Capability? capability) {
  return capability?.type == 'number' || capability?.type == 'range'
      ? const ['>', '<', '=', 'changes_to']
      : const ['=', 'changes_to'];
}

String _operatorLabel(String operator) => switch (operator) {
  '>' => 'greater than',
  '<' => 'less than',
  '=' => 'equals',
  _ => 'changes to',
};

class _TypedValueField extends StatefulWidget {
  const _TypedValueField({
    required this.capability,
    required this.controller,
    required this.label,
  });

  final Capability? capability;
  final TextEditingController controller;
  final String label;

  @override
  State<_TypedValueField> createState() => _TypedValueFieldState();
}

class _TypedValueFieldState extends State<_TypedValueField> {
  @override
  Widget build(BuildContext context) {
    final capability = widget.capability;
    if (capability == null) {
      return TextFormField(
        controller: widget.controller,
        enabled: false,
        decoration: InputDecoration(labelText: widget.label),
      );
    }
    if (capability.type == 'boolean') {
      final value = widget.controller.text == 'true'
          ? 'true'
          : widget.controller.text == 'false'
          ? 'false'
          : null;
      return DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: widget.label),
        items: const [
          DropdownMenuItem(value: 'true', child: Text('On / true')),
          DropdownMenuItem(value: 'false', child: Text('Off / false')),
        ],
        onChanged: (value) => widget.controller.text = value ?? '',
        validator: (value) => value == null ? '${widget.label} required' : null,
      );
    }
    if (capability.type == 'range') {
      final min = (capability.min ?? 0).toDouble();
      final max = (capability.max ?? 100).toDouble();
      final value = (num.tryParse(widget.controller.text)?.toDouble() ?? min)
          .clamp(min, max)
          .toDouble();
      widget.controller.text = _numberText(value);
      return InputDecorator(
        decoration: InputDecoration(labelText: widget.label),
        child: Column(
          children: [
            Slider(
              value: value,
              min: min,
              max: max,
              onChanged: (next) =>
                  setState(() => widget.controller.text = _numberText(next)),
            ),
            Text('${widget.controller.text}${capability.unit ?? ''}'),
          ],
        ),
      );
    }
    if (capability.type == 'color') {
      const colors = ['#ff0000', '#00ff00', '#0000ff', '#ffffff', '#000000'];
      final value = colors.contains(widget.controller.text)
          ? widget.controller.text
          : null;
      return DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: widget.label),
        items: [
          for (final color in colors)
            DropdownMenuItem(value: color, child: Text(color)),
        ],
        onChanged: (value) => widget.controller.text = value ?? '',
        validator: (value) => value == null ? '${widget.label} required' : null,
      );
    }
    if (capability.type == 'number') {
      return TextFormField(
        controller: widget.controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: widget.label,
          suffixText: capability.unit,
        ),
        validator: (raw) {
          final value = num.tryParse(raw ?? '');
          if (value == null) return 'Enter a valid number';
          if (capability.min case final min? when value < min) {
            return 'Minimum is $min';
          }
          if (capability.max case final max? when value > max) {
            return 'Maximum is $max';
          }
          return null;
        },
      );
    }
    return TextFormField(
      controller: widget.controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: widget.label,
        helperText: 'Unsupported capability type: ${capability.type}',
      ),
      validator: (_) => 'Unsupported capability type',
    );
  }

  String _numberText(double value) =>
      value % 1 == 0 ? value.round().toString() : value.toStringAsFixed(2);
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
