// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletBalanceResponse _$WalletBalanceResponseFromJson(
        Map<String, dynamic> json) =>
    WalletBalanceResponse(
      (json['walletAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$WalletBalanceResponseToJson(
        WalletBalanceResponse instance) =>
    <String, dynamic>{
      'walletAmount': instance.walletAmount,
    };
