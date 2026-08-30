import 'package:flutter/material.dart';

import 'device_models.dart';

/// PRD §17 centerpiece: ONE widget maps (type, mode) → control for every
/// product/capability. No per-product screens — new capability types just
/// need a new branch here, not a new page anywhere in the app.
class CapabilityControl extends StatelessWidget {
  const CapabilityControl({super.key, required this.capability, required this.value, required this.onChanged});

  final Capability capability;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  bool get _writable => capability.mode == 'write' || capability.mode == 'read_write';

  @override
  Widget build(BuildContext context) {
    if (!_writable) return _MetricTile(capability: capability, value: value);

    switch (capability.type) {
      case 'boolean':
        return SwitchListTile(
          title: Text(capability.name),
          value: value == true,
          onChanged: (v) => onChanged(v),
        );
      case 'range':
        return _RangeTile(capability: capability, value: value, onChanged: onChanged);
      case 'color':
        return _ColorTile(capability: capability, value: value, onChanged: onChanged);
      default:
        return _MetricTile(capability: capability, value: value);
    }
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.capability, required this.value});
  final Capability capability;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final unit = capability.unit;
    return ListTile(
      title: Text(capability.name),
      trailing: Text('${value ?? '—'}${unit != null ? ' $unit' : ''}', style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _RangeTile extends StatelessWidget {
  const _RangeTile({required this.capability, required this.value, required this.onChanged});
  final Capability capability;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    final min = (capability.min ?? 0).toDouble();
    final max = (capability.max ?? 100).toDouble();
    final current = ((value as num?)?.toDouble() ?? min).clamp(min, max);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Text('${capability.name}: ${current.round()}${capability.unit ?? ''}'),
        ),
        Slider(
          value: current,
          min: min,
          max: max,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}

// ponytail: swatch grid, not a full HSV wheel — no color-picker dependency
// installed. Swap for flutter_colorpicker if design wants a richer picker.
const _swatches = <Color>[
  Colors.red,
  Colors.orange,
  Colors.amber,
  Colors.yellow,
  Colors.green,
  Colors.teal,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.white,
];

class _ColorTile extends StatelessWidget {
  const _ColorTile({required this.capability, required this.value, required this.onChanged});
  final Capability capability;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  Color get _current {
    final hex = value is String ? value as String : null;
    if (hex == null || hex.length < 6) return Colors.grey;
    final clean = hex.replaceFirst('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  String _toHex(Color c) => '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  Future<void> _pick(BuildContext context) async {
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pick a color'),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in _swatches)
                InkWell(
                  onTap: () => Navigator.of(context).pop(c),
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all()),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
    if (picked != null) onChanged(_toHex(picked));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(capability.name),
      trailing: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: _current, shape: BoxShape.circle, border: Border.all()),
      ),
      onTap: () => _pick(context),
    );
  }
}
