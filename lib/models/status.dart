import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';


@JsonSerializable()
class Status {
  @JsonKey(name: 'code')
  int code;
  @JsonKey(name: 'message')
  String message;

  Status({required this.code, required this.message});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  Map<String, dynamic> toJson() => _$StatusToJson(this);
}