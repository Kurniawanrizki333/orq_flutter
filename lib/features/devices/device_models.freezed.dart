// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Capability {

 String get id; String get key; String get name;/// One of: boolean, number, range, color.
 String get type;/// One of: read, write, read_write.
 String get mode; num? get min; num? get max; String? get unit;
/// Create a copy of Capability
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CapabilityCopyWith<Capability> get copyWith => _$CapabilityCopyWithImpl<Capability>(this as Capability, _$identity);

  /// Serializes this Capability to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Capability&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,name,type,mode,min,max,unit);

@override
String toString() {
  return 'Capability(id: $id, key: $key, name: $name, type: $type, mode: $mode, min: $min, max: $max, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $CapabilityCopyWith<$Res>  {
  factory $CapabilityCopyWith(Capability value, $Res Function(Capability) _then) = _$CapabilityCopyWithImpl;
@useResult
$Res call({
 String id, String key, String name, String type, String mode, num? min, num? max, String? unit
});




}
/// @nodoc
class _$CapabilityCopyWithImpl<$Res>
    implements $CapabilityCopyWith<$Res> {
  _$CapabilityCopyWithImpl(this._self, this._then);

  final Capability _self;
  final $Res Function(Capability) _then;

/// Create a copy of Capability
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? name = null,Object? type = null,Object? mode = null,Object? min = freezed,Object? max = freezed,Object? unit = freezed,}) {
  return _then(Capability(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as num?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as num?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Capability].
extension CapabilityPatterns on Capability {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Capability value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Capability() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Capability value)  $default,){
final _that = this;
switch (_that) {
case _Capability():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Capability value)?  $default,){
final _that = this;
switch (_that) {
case _Capability() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String type,  String mode,  num? min,  num? max,  String? unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Capability() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.type,_that.mode,_that.min,_that.max,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String type,  String mode,  num? min,  num? max,  String? unit)  $default,) {final _that = this;
switch (_that) {
case _Capability():
return $default(_that.id,_that.key,_that.name,_that.type,_that.mode,_that.min,_that.max,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String name,  String type,  String mode,  num? min,  num? max,  String? unit)?  $default,) {final _that = this;
switch (_that) {
case _Capability() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.type,_that.mode,_that.min,_that.max,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Capability implements Capability {
  const _Capability({required this.id, required this.key, required this.name, required this.type, required this.mode, this.min, this.max, this.unit});
  factory _Capability.fromJson(Map<String, dynamic> json) => _$CapabilityFromJson(json);

@override final  String id;
@override final  String key;
@override final  String name;
/// One of: boolean, number, range, color.
@override final  String type;
/// One of: read, write, read_write.
@override final  String mode;
@override final  num? min;
@override final  num? max;
@override final  String? unit;

/// Create a copy of Capability
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CapabilityCopyWith<_Capability> get copyWith => __$CapabilityCopyWithImpl<_Capability>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CapabilityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Capability&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,name,type,mode,min,max,unit);

@override
String toString() {
  return 'Capability(id: $id, key: $key, name: $name, type: $type, mode: $mode, min: $min, max: $max, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$CapabilityCopyWith<$Res> implements $CapabilityCopyWith<$Res> {
  factory _$CapabilityCopyWith(_Capability value, $Res Function(_Capability) _then) = __$CapabilityCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String name, String type, String mode, num? min, num? max, String? unit
});




}
/// @nodoc
class __$CapabilityCopyWithImpl<$Res>
    implements _$CapabilityCopyWith<$Res> {
  __$CapabilityCopyWithImpl(this._self, this._then);

  final _Capability _self;
  final $Res Function(_Capability) _then;

/// Create a copy of Capability
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? name = null,Object? type = null,Object? mode = null,Object? min = freezed,Object? max = freezed,Object? unit = freezed,}) {
  return _then(_Capability(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as num?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as num?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Device {

 String get id; String get name;@JsonKey(name: 'product_id') String get productId; bool get online; List<Capability> get capabilities;
/// Create a copy of Device
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceCopyWith<Device> get copyWith => _$DeviceCopyWithImpl<Device>(this as Device, _$identity);

  /// Serializes this Device to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Device&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.online, online) || other.online == online)&&const DeepCollectionEquality().equals(other.capabilities, capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,productId,online,const DeepCollectionEquality().hash(capabilities));

@override
String toString() {
  return 'Device(id: $id, name: $name, productId: $productId, online: $online, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class $DeviceCopyWith<$Res>  {
  factory $DeviceCopyWith(Device value, $Res Function(Device) _then) = _$DeviceCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'product_id') String productId, bool online, List<Capability> capabilities
});




}
/// @nodoc
class _$DeviceCopyWithImpl<$Res>
    implements $DeviceCopyWith<$Res> {
  _$DeviceCopyWithImpl(this._self, this._then);

  final Device _self;
  final $Res Function(Device) _then;

/// Create a copy of Device
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? productId = null,Object? online = null,Object? capabilities = null,}) {
  return _then(Device(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,capabilities: null == capabilities ? _self.capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<Capability>,
  ));
}

}


/// Adds pattern-matching-related methods to [Device].
extension DevicePatterns on Device {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Device value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Device() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Device value)  $default,){
final _that = this;
switch (_that) {
case _Device():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Device value)?  $default,){
final _that = this;
switch (_that) {
case _Device() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'product_id')  String productId,  bool online,  List<Capability> capabilities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Device() when $default != null:
return $default(_that.id,_that.name,_that.productId,_that.online,_that.capabilities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'product_id')  String productId,  bool online,  List<Capability> capabilities)  $default,) {final _that = this;
switch (_that) {
case _Device():
return $default(_that.id,_that.name,_that.productId,_that.online,_that.capabilities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'product_id')  String productId,  bool online,  List<Capability> capabilities)?  $default,) {final _that = this;
switch (_that) {
case _Device() when $default != null:
return $default(_that.id,_that.name,_that.productId,_that.online,_that.capabilities);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Device implements Device {
  const _Device({required this.id, required this.name, @JsonKey(name: 'product_id') required this.productId, this.online = false,  List<Capability> capabilities = const []}): _capabilities = capabilities;
  factory _Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'product_id') final  String productId;
@override@JsonKey() final  bool online;
 final  List<Capability> _capabilities;
@override@JsonKey() List<Capability> get capabilities {
  if (_capabilities is EqualUnmodifiableListView) return _capabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_capabilities);
}


/// Create a copy of Device
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceCopyWith<_Device> get copyWith => __$DeviceCopyWithImpl<_Device>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Device&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.online, online) || other.online == online)&&const DeepCollectionEquality().equals(other._capabilities, _capabilities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,productId,online,const DeepCollectionEquality().hash(_capabilities));

@override
String toString() {
  return 'Device(id: $id, name: $name, productId: $productId, online: $online, capabilities: $capabilities)';
}


}

/// @nodoc
abstract mixin class _$DeviceCopyWith<$Res> implements $DeviceCopyWith<$Res> {
  factory _$DeviceCopyWith(_Device value, $Res Function(_Device) _then) = __$DeviceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'product_id') String productId, bool online, List<Capability> capabilities
});




}
/// @nodoc
class __$DeviceCopyWithImpl<$Res>
    implements _$DeviceCopyWith<$Res> {
  __$DeviceCopyWithImpl(this._self, this._then);

  final _Device _self;
  final $Res Function(_Device) _then;

/// Create a copy of Device
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? productId = null,Object? online = null,Object? capabilities = null,}) {
  return _then(_Device(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,capabilities: null == capabilities ? _self._capabilities : capabilities // ignore: cast_nullable_to_non_nullable
as List<Capability>,
  ));
}


}

// dart format on
