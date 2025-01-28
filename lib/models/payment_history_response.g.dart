// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentHistoryResponse _$PaymentHistoryResponseFromJson(
        Map<String, dynamic> json) =>
    PaymentHistoryResponse(
      amount: json['amount'] as String,
      modeOfPayment: json['modeOfPayment'] as String,
      step: json['step'] as String,
      parkingName: json['parkingName'] as String,
      createdDate: json['createdDate'] as String,
    );

Map<String, dynamic> _$PaymentHistoryResponseToJson(
        PaymentHistoryResponse instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'modeOfPayment': instance.modeOfPayment,
      'step': instance.step,
      'parkingName': instance.parkingName,
      'createdDate': instance.createdDate,
    };
