import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';


@JsonSerializable()
class User {
  @JsonKey(name: 'userID')
  String userId;
  @JsonKey(name: 'mobileNo')
  String mobileNumber;
  @JsonKey(name: 'createdDate')
  String createdDate;
  @JsonKey(name: 'updatedDate')
  String updatedDate;


  User(this.userId, this.mobileNumber, this.createdDate, this.updatedDate);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}