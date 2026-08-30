import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'automation_models.dart';
import 'automation_providers.dart';

/// AI prompt generates a draft; a manual rule form is the fallback when
/// generation isn't available (PRD: keep a manual path as stage fallback).
class AutomationFormPage extends ConsumerStatefulWidget {
  const AutomationFormPage({super.key});

  @override
  ConsumerState<AutomationFormPage> createState() => _AutomationFormPageState();
}

class _AutomationFormPageState extends ConsumerState<AutomationFormPage> {
  final _prompt = TextEditingController();
  final _manualName = TextEditingController();
  final _manualDeviceId = TextEditingController();
  final _manualCapability = TextEditingController();
  final _manualValue = TextEditingController();
  final _triggerDeviceId = TextEditingController();
  final _triggerCapability = TextEditingController();
  final _triggerValue = TextEditingController();
  String _triggerOperator = '>';

  AutomationDraft? _draft;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _prompt.dispose();
    _manualName.dispose();
    _manualDeviceId.dispose();
    _manualCapability.dispose();
    _manualValue.dispose();
    _triggerDeviceId.dispose();
    _triggerCapability.dispose();
    _triggerValue.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_prompt.text.trim().isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final draft = await ref.read(automationRepositoryProvider).generate(_prompt.text.trim());
      setState(() => _draft = draft);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _confirmDraft() async {
    final draft = _draft;
    if (draft == null) return;
    await _save(name: draft.summary, actions: draft.actions, trigger: draft.trigger);
  }

  /// The backend types values per capability (bool / number / "#RRGGBB"), so a
  /// raw text field would be rejected for anything but a color.
  static dynamic _coerce(String raw) {
    final t = raw.trim();
    if (t == 'true') return true;
    if (t == 'false') return false;
    return num.tryParse(t) ?? t;
  }

  Future<void> _saveManual() async {
    if (_manualName.text.trim().isEmpty ||
        _manualDeviceId.text.trim().isEmpty ||
        _manualCapability.text.trim().isEmpty ||
        _triggerDeviceId.text.trim().isEmpty ||
        _triggerCapability.text.trim().isEmpty) {
      return;
    }
    await _save(
      name: _manualName.text.trim(),
      actions: [
        AutomationAction(
          deviceId: _manualDeviceId.text.trim(),
          capability: _manualCapability.text.trim(),
          value: _coerce(_manualValue.text),
        ),
      ],
      trigger: {
        'device_id': _triggerDeviceId.text.trim(),
        'capability': _triggerCapability.text.trim(),
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
      await ref.read(automationRepositoryProvider).create(name: name, actions: actions, trigger: trigger);
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
    final draft = _draft;
    return Scaffold(
      appBar: AppBar(title: const Text('New automation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Describe it', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _prompt,
            decoration: const InputDecoration(
              hintText: 'e.g. Turn off the living room lights at 11pm',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _busy ? null : _generate, child: const Text('Generate')),
          if (draft != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(draft.summary, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    for (final a in draft.actions) Text('• ${a.deviceId}: ${a.capability} = ${a.value}'),
                    const SizedBox(height: 12),
                    FilledButton(onPressed: _busy ? null : _confirmDraft, child: const Text('Confirm & save')),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 32),
          const Divider(),
          Text('Or build one manually', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(controller: _manualName, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 16),
          Text('When', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(controller: _triggerDeviceId, decoration: const InputDecoration(labelText: 'Trigger device ID')),
          const SizedBox(height: 8),
          TextField(
            controller: _triggerCapability,
            decoration: const InputDecoration(labelText: 'Trigger capability key'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _triggerOperator,
            decoration: const InputDecoration(labelText: 'Operator'),
            items: const [
              DropdownMenuItem(value: '>', child: Text('greater than')),
              DropdownMenuItem(value: '<', child: Text('less than')),
              DropdownMenuItem(value: '=', child: Text('equals')),
              DropdownMenuItem(value: 'changes_to', child: Text('changes to')),
            ],
            onChanged: (v) => setState(() => _triggerOperator = v ?? '>'),
          ),
          const SizedBox(height: 8),
          TextField(controller: _triggerValue, decoration: const InputDecoration(labelText: 'Trigger value')),
          const SizedBox(height: 16),
          Text('Then', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          TextField(controller: _manualDeviceId, decoration: const InputDecoration(labelText: 'Action device ID')),
          const SizedBox(height: 8),
          TextField(
            controller: _manualCapability,
            decoration: const InputDecoration(labelText: 'Action capability key'),
          ),
          const SizedBox(height: 8),
          TextField(controller: _manualValue, decoration: const InputDecoration(labelText: 'Action value')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: _busy ? null : _saveManual, child: const Text('Save manual rule')),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 16), child: Text(_error!)),
        ],
      ),
    );
  }
}
