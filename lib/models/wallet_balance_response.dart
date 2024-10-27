import 'package:json_annotation/json_annotation.dart';

part 'wallet_balance_response.g.dart';


@JsonSerializable()
class WalletBalanceResponse {
  @JsonKey(name: 'walletAmount')
  double walletAmount;


  WalletBalanceResponse(this.walletAmount);

  factory WalletBalanceResponse.fromJson(Map<String, dynamic> json) => _$WalletBalanceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WalletBalanceResponseToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}