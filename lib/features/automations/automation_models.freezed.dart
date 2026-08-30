// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'automation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AutomationAction {

@JsonKey(name: 'device_id') String get deviceId; String get capability; dynamic get value;
/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationActionCopyWith<AutomationAction> get copyWith => _$AutomationActionCopyWithImpl<AutomationAction>(this as AutomationAction, _$identity);

  /// Serializes this AutomationAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationAction&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.capability, capability) || other.capability == capability)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,capability,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'AutomationAction(deviceId: $deviceId, capability: $capability, value: $value)';
}


}

/// @nodoc
abstract mixin class $AutomationActionCopyWith<$Res>  {
  factory $AutomationActionCopyWith(AutomationAction value, $Res Function(AutomationAction) _then) = _$AutomationActionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'device_id') String deviceId, String capability, dynamic value
});




}
/// @nodoc
class _$AutomationActionCopyWithImpl<$Res>
    implements $AutomationActionCopyWith<$Res> {
  _$AutomationActionCopyWithImpl(this._self, this._then);

  final AutomationAction _self;
  final $Res Function(AutomationAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? capability = null,Object? value = freezed,}) {
  return _then(AutomationAction(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,capability: null == capability ? _self.capability : capability // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationAction].
extension AutomationActionPatterns on AutomationAction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationAction value)  $default,){
final _that = this;
switch (_that) {
case _AutomationAction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationAction value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'device_id')  String deviceId,  String capability,  dynamic value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
return $default(_that.deviceId,_that.capability,_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'device_id')  String deviceId,  String capability,  dynamic value)  $default,) {final _that = this;
switch (_that) {
case _AutomationAction():
return $default(_that.deviceId,_that.capability,_that.value);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'device_id')  String deviceId,  String capability,  dynamic value)?  $default,) {final _that = this;
switch (_that) {
case _AutomationAction() when $default != null:
return $default(_that.deviceId,_that.capability,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationAction implements AutomationAction {
  const _AutomationAction({@JsonKey(name: 'device_id') required this.deviceId, required this.capability, required this.value});
  factory _AutomationAction.fromJson(Map<String, dynamic> json) => _$AutomationActionFromJson(json);

@override@JsonKey(name: 'device_id') final  String deviceId;
@override final  String capability;
@override final  dynamic value;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationActionCopyWith<_AutomationAction> get copyWith => __$AutomationActionCopyWithImpl<_AutomationAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationAction&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.capability, capability) || other.capability == capability)&&const DeepCollectionEquality().equals(other.value, value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,capability,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'AutomationAction(deviceId: $deviceId, capability: $capability, value: $value)';
}


}

/// @nodoc
abstract mixin class _$AutomationActionCopyWith<$Res> implements $AutomationActionCopyWith<$Res> {
  factory _$AutomationActionCopyWith(_AutomationAction value, $Res Function(_AutomationAction) _then) = __$AutomationActionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'device_id') String deviceId, String capability, dynamic value
});




}
/// @nodoc
class __$AutomationActionCopyWithImpl<$Res>
    implements _$AutomationActionCopyWith<$Res> {
  __$AutomationActionCopyWithImpl(this._self, this._then);

  final _AutomationAction _self;
  final $Res Function(_AutomationAction) _then;

/// Create a copy of AutomationAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? capability = null,Object? value = freezed,}) {
  return _then(_AutomationAction(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,capability: null == capability ? _self.capability : capability // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}


/// @nodoc
mixin _$Automation {

 String get id; String get name; bool get enabled; List<AutomationAction> get actions; Map<String, dynamic>? get trigger;
/// Create a copy of Automation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationCopyWith<Automation> get copyWith => _$AutomationCopyWithImpl<Automation>(this as Automation, _$identity);

  /// Serializes this Automation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Automation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.actions, actions)&&const DeepCollectionEquality().equals(other.trigger, trigger));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,enabled,const DeepCollectionEquality().hash(actions),const DeepCollectionEquality().hash(trigger));

@override
String toString() {
  return 'Automation(id: $id, name: $name, enabled: $enabled, actions: $actions, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class $AutomationCopyWith<$Res>  {
  factory $AutomationCopyWith(Automation value, $Res Function(Automation) _then) = _$AutomationCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool enabled, List<AutomationAction> actions, Map<String, dynamic>? trigger
});




}
/// @nodoc
class _$AutomationCopyWithImpl<$Res>
    implements $AutomationCopyWith<$Res> {
  _$AutomationCopyWithImpl(this._self, this._then);

  final Automation _self;
  final $Res Function(Automation) _then;

/// Create a copy of Automation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? enabled = null,Object? actions = null,Object? trigger = freezed,}) {
  return _then(Automation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,trigger: freezed == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Automation].
extension AutomationPatterns on Automation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Automation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Automation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Automation value)  $default,){
final _that = this;
switch (_that) {
case _Automation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Automation value)?  $default,){
final _that = this;
switch (_that) {
case _Automation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool enabled,  List<AutomationAction> actions,  Map<String, dynamic>? trigger)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Automation() when $default != null:
return $default(_that.id,_that.name,_that.enabled,_that.actions,_that.trigger);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool enabled,  List<AutomationAction> actions,  Map<String, dynamic>? trigger)  $default,) {final _that = this;
switch (_that) {
case _Automation():
return $default(_that.id,_that.name,_that.enabled,_that.actions,_that.trigger);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool enabled,  List<AutomationAction> actions,  Map<String, dynamic>? trigger)?  $default,) {final _that = this;
switch (_that) {
case _Automation() when $default != null:
return $default(_that.id,_that.name,_that.enabled,_that.actions,_that.trigger);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Automation implements Automation {
  const _Automation({required this.id, required this.name, this.enabled = true,  List<AutomationAction> actions = const [],  Map<String, dynamic>? trigger}): _actions = actions,_trigger = trigger;
  factory _Automation.fromJson(Map<String, dynamic> json) => _$AutomationFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  bool enabled;
 final  List<AutomationAction> _actions;
@override@JsonKey() List<AutomationAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

 final  Map<String, dynamic>? _trigger;
@override Map<String, dynamic>? get trigger {
  final value = _trigger;
  if (value == null) return null;
  if (_trigger is EqualUnmodifiableMapView) return _trigger;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Automation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationCopyWith<_Automation> get copyWith => __$AutomationCopyWithImpl<_Automation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Automation&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._actions, _actions)&&const DeepCollectionEquality().equals(other._trigger, _trigger));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,enabled,const DeepCollectionEquality().hash(_actions),const DeepCollectionEquality().hash(_trigger));

@override
String toString() {
  return 'Automation(id: $id, name: $name, enabled: $enabled, actions: $actions, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class _$AutomationCopyWith<$Res> implements $AutomationCopyWith<$Res> {
  factory _$AutomationCopyWith(_Automation value, $Res Function(_Automation) _then) = __$AutomationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool enabled, List<AutomationAction> actions, Map<String, dynamic>? trigger
});




}
/// @nodoc
class __$AutomationCopyWithImpl<$Res>
    implements _$AutomationCopyWith<$Res> {
  __$AutomationCopyWithImpl(this._self, this._then);

  final _Automation _self;
  final $Res Function(_Automation) _then;

/// Create a copy of Automation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? enabled = null,Object? actions = null,Object? trigger = freezed,}) {
  return _then(_Automation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,trigger: freezed == trigger ? _self._trigger : trigger // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$AutomationDraft {

 String get summary; List<AutomationAction> get actions; Map<String, dynamic>? get trigger;
/// Create a copy of AutomationDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutomationDraftCopyWith<AutomationDraft> get copyWith => _$AutomationDraftCopyWithImpl<AutomationDraft>(this as AutomationDraft, _$identity);

  /// Serializes this AutomationDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutomationDraft&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.actions, actions)&&const DeepCollectionEquality().equals(other.trigger, trigger));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(actions),const DeepCollectionEquality().hash(trigger));

@override
String toString() {
  return 'AutomationDraft(summary: $summary, actions: $actions, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class $AutomationDraftCopyWith<$Res>  {
  factory $AutomationDraftCopyWith(AutomationDraft value, $Res Function(AutomationDraft) _then) = _$AutomationDraftCopyWithImpl;
@useResult
$Res call({
 String summary, List<AutomationAction> actions, Map<String, dynamic>? trigger
});




}
/// @nodoc
class _$AutomationDraftCopyWithImpl<$Res>
    implements $AutomationDraftCopyWith<$Res> {
  _$AutomationDraftCopyWithImpl(this._self, this._then);

  final AutomationDraft _self;
  final $Res Function(AutomationDraft) _then;

/// Create a copy of AutomationDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? actions = null,Object? trigger = freezed,}) {
  return _then(AutomationDraft(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,trigger: freezed == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AutomationDraft].
extension AutomationDraftPatterns on AutomationDraft {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AutomationDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AutomationDraft() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AutomationDraft value)  $default,){
final _that = this;
switch (_that) {
case _AutomationDraft():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AutomationDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AutomationDraft() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String summary,  List<AutomationAction> actions,  Map<String, dynamic>? trigger)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AutomationDraft() when $default != null:
return $default(_that.summary,_that.actions,_that.trigger);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String summary,  List<AutomationAction> actions,  Map<String, dynamic>? trigger)  $default,) {final _that = this;
switch (_that) {
case _AutomationDraft():
return $default(_that.summary,_that.actions,_that.trigger);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String summary,  List<AutomationAction> actions,  Map<String, dynamic>? trigger)?  $default,) {final _that = this;
switch (_that) {
case _AutomationDraft() when $default != null:
return $default(_that.summary,_that.actions,_that.trigger);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AutomationDraft implements AutomationDraft {
  const _AutomationDraft({required this.summary,  List<AutomationAction> actions = const [],  Map<String, dynamic>? trigger}): _actions = actions,_trigger = trigger;
  factory _AutomationDraft.fromJson(Map<String, dynamic> json) => _$AutomationDraftFromJson(json);

@override final  String summary;
 final  List<AutomationAction> _actions;
@override@JsonKey() List<AutomationAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

 final  Map<String, dynamic>? _trigger;
@override Map<String, dynamic>? get trigger {
  final value = _trigger;
  if (value == null) return null;
  if (_trigger is EqualUnmodifiableMapView) return _trigger;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AutomationDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AutomationDraftCopyWith<_AutomationDraft> get copyWith => __$AutomationDraftCopyWithImpl<_AutomationDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AutomationDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AutomationDraft&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._actions, _actions)&&const DeepCollectionEquality().equals(other._trigger, _trigger));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_actions),const DeepCollectionEquality().hash(_trigger));

@override
String toString() {
  return 'AutomationDraft(summary: $summary, actions: $actions, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class _$AutomationDraftCopyWith<$Res> implements $AutomationDraftCopyWith<$Res> {
  factory _$AutomationDraftCopyWith(_AutomationDraft value, $Res Function(_AutomationDraft) _then) = __$AutomationDraftCopyWithImpl;
@override @useResult
$Res call({
 String summary, List<AutomationAction> actions, Map<String, dynamic>? trigger
});




}
/// @nodoc
class __$AutomationDraftCopyWithImpl<$Res>
    implements _$AutomationDraftCopyWith<$Res> {
  __$AutomationDraftCopyWithImpl(this._self, this._then);

  final _AutomationDraft _self;
  final $Res Function(_AutomationDraft) _then;

/// Create a copy of AutomationDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? actions = null,Object? trigger = freezed,}) {
  return _then(_AutomationDraft(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<AutomationAction>,trigger: freezed == trigger ? _self._trigger : trigger // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
