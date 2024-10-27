// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['userID'] as String,
      json['mobileNo'] as String,
      json['createdDate'] as String,
      json['updatedDate'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userID': instance.userId,
      'mobileNo': instance.mobileNumber,
      'createdDate': instance.createdDate,
      'updatedDate': instance.updatedDate,
    };
