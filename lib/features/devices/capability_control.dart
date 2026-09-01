import 'package:flutter/material.dart';

import 'device_models.dart';

/// One control maps every product capability by type and mode.
class CapabilityControl extends StatelessWidget {
  const CapabilityControl({
    super.key,
    required this.capability,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.pending = false,
  });

  final Capability capability;
  final dynamic value;
  final Future<void> Function(dynamic) onChanged;
  final bool enabled;
  final bool pending;

  bool get _writable =>
      capability.mode == 'write' || capability.mode == 'read_write';

  @override
  Widget build(BuildContext context) {
    if (!_writable) return _MetricTile(capability: capability, value: value);

    switch (capability.type) {
      case 'boolean':
        return SwitchListTile(
          title: Text(capability.name),
          subtitle: Text(pending ? 'Sending…' : (value == true ? 'On' : 'Off')),
          secondary: pending
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : null,
          value: value == true,
          onChanged: enabled ? (next) => onChanged(next) : null,
        );
      case 'range':
        return _RangeTile(
          capability: capability,
          value: value,
          onChanged: onChanged,
          enabled: enabled,
          pending: pending,
        );
      case 'number':
        return _NumberTile(
          capability: capability,
          value: value,
          onChanged: onChanged,
          enabled: enabled,
          pending: pending,
        );
      case 'color':
        return _ColorTile(
          capability: capability,
          value: value,
          onChanged: onChanged,
          enabled: enabled,
          pending: pending,
        );
      default:
        return _MetricTile(capability: capability, value: value);
    }
  }
}

class _NumberTile extends StatefulWidget {
  const _NumberTile({
    required this.capability,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.pending,
  });

  final Capability capability;
  final dynamic value;
  final Future<void> Function(dynamic) onChanged;
  final bool enabled;
  final bool pending;

  @override
  State<_NumberTile> createState() => _NumberTileState();
}

class _NumberTileState extends State<_NumberTile> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value?.toString() ?? '',
  );
  String? _error;

  @override
  void didUpdateWidget(_NumberTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !widget.pending) {
      _controller.text = widget.value?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = num.tryParse(_controller.text);
    final min = widget.capability.min;
    final max = widget.capability.max;
    final error = value == null
        ? 'Enter a valid number'
        : min != null && value < min
        ? 'Minimum is $min'
        : max != null && value > max
        ? 'Maximum is $max'
        : null;
    setState(() => _error = error);
    if (error == null) widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.capability.name),
      subtitle: TextField(
        controller: _controller,
        enabled: widget.enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          errorText: _error,
          suffixText: widget.capability.unit,
        ),
        onSubmitted: (_) => _submit(),
      ),
      trailing: widget.pending
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              tooltip: 'Send value',
              onPressed: widget.enabled ? _submit : null,
              icon: const Icon(Icons.send),
            ),
    );
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
      trailing: Text(
        '${value ?? '—'}${unit != null ? ' $unit' : ''}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _RangeTile extends StatefulWidget {
  const _RangeTile({
    required this.capability,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.pending,
  });
  final Capability capability;
  final dynamic value;
  final Future<void> Function(dynamic) onChanged;
  final bool enabled;
  final bool pending;

  @override
  State<_RangeTile> createState() => _RangeTileState();
}

class _RangeTileState extends State<_RangeTile> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final min = (widget.capability.min ?? 0).toDouble();
    final max = (widget.capability.max ?? 100).toDouble();
    final current =
        _dragValue ??
        ((widget.value as num?)?.toDouble() ?? min).clamp(min, max).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.capability.name}: ${_format(current)}${_unit(widget.capability.unit)}',
                ),
              ),
              if (widget.pending)
                const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
        Slider(
          value: current,
          min: min,
          max: max,
          onChanged: widget.enabled
              ? (next) => setState(() => _dragValue = next)
              : null,
          onChangeEnd: widget.enabled
              ? (next) {
                  setState(() => _dragValue = null);
                  widget.onChanged(_wireValue(next));
                }
              : null,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Text('${_format(min)}${_unit(widget.capability.unit)}'),
              const Spacer(),
              Text('${_format(max)}${_unit(widget.capability.unit)}'),
            ],
          ),
        ),
      ],
    );
  }

  num _wireValue(double value) =>
      value % 1 == 0 ? value.round() : double.parse(value.toStringAsFixed(2));

  String _format(double value) =>
      value % 1 == 0 ? value.round().toString() : value.toStringAsFixed(1);

  String _unit(String? unit) => unit == null || unit.isEmpty ? '' : ' $unit';
}

// ponytail: swatch grid, not a full HSV wheel — no color-picker dependency.
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
  const _ColorTile({
    required this.capability,
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.pending,
  });
  final Capability capability;
  final dynamic value;
  final Future<void> Function(dynamic) onChanged;
  final bool enabled;
  final bool pending;

  Color get _current {
    final hex = value is String ? value as String : null;
    if (hex == null || hex.length < 6) return Colors.grey;
    final clean = hex.replaceFirst('#', '');
    if (!RegExp(r'^[0-9a-fA-F]{6}$').hasMatch(clean)) return Colors.grey;
    return Color(int.parse('FF$clean', radix: 16));
  }

  String _toHex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  Future<void> _pick(BuildContext context) async {
    final picked = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final color in _swatches)
              Semantics(
                button: true,
                label: 'Select color ${_toHex(color)}',
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => Navigator.of(context).pop(color),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (picked != null) await onChanged(_toHex(picked));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(capability.name),
      subtitle: Text(_toHex(_current)),
      trailing: pending
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _current,
                shape: BoxShape.circle,
                border: Border.all(),
              ),
            ),
      enabled: enabled,
      onTap: enabled ? () => _pick(context) : null,
    );
  }
}
