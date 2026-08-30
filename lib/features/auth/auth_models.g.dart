// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  fullName: json['full_name'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'username': instance.username,
  'full_name': instance.fullName,
};

_AuthResult _$AuthResultFromJson(Map<String, dynamic> json) => _AuthResult(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResultToJson(_AuthResult instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'user': instance.user,
    };
