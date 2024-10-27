import 'package:json_annotation/json_annotation.dart';
part 'response.g.dart';

@JsonSerializable()
class MyResponse{
  final String message;

  MyResponse(this.message);

  factory MyResponse.fromJson(Map<String, dynamic> json) =>
      _$MyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyResponseToJson(this);


}