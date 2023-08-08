// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_hook.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebHook _$WebHookFromJson(Map<String, dynamic> json) {
  return WebHook(
      url: json['url'] as String,
      user: json['user'] as String,
      password: json['password'] as String,
      event_types:
          (json['event_types'] as List).map((e) => e as String).toList(),
      status: json['status'] as String)
    ..id = json['id'] as String;
}

Map<String, dynamic> _$WebHookToJson(WebHook instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'user': instance.user,
      'password': instance.password,
      'event_types': instance.event_types,
      'status': instance.status
    };
