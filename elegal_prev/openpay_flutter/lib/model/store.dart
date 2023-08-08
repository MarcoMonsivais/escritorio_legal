import 'package:json_annotation/json_annotation.dart';

part 'store.g.dart';

@JsonSerializable(nullable: false)
class Store {
  Store({this.reference, this.barcode_url});

  String reference;
  String barcode_url;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
