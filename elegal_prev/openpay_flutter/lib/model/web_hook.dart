import 'package:openpay_flutter/model/open_pay_base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'web_hook.g.dart';

@JsonSerializable(nullable: false)
class WebHook extends OpenPayBaseModel {
  WebHook({this.url, this.user, this.password, this.event_types, this.status});

  String url;
  String user;
  String password;
  List<String> event_types;
  String status;

  factory WebHook.fromJson(Map<String, dynamic> json) =>
      _$WebHookFromJson(json);
      WebHook fromJson(Map<String, dynamic> json) =>
      _$WebHookFromJson(json);
  Map<String, dynamic> toJson() => _$WebHookToJson(this);

  void addEventType(String eventType) {
    if (this.event_types == null) {
      this.event_types = new List<String>();
    }
    this.event_types.add(eventType);
  }
}
