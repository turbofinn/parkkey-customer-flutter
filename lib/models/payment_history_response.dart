import 'package:json_annotation/json_annotation.dart';

part 'payment_history_response.g.dart';

@JsonSerializable()
class PaymentHistoryResponse {
  final String amount;
  final String modeOfPayment;
  final String step;
  final String parkingName;
  final String createdDate;

  PaymentHistoryResponse({
    required this.amount,
    required this.modeOfPayment,
    required this.step,
    required this.parkingName,
    required this.createdDate,
  });

  /// Factory constructor for creating a new `PaymentHistoryResponse` instance from a map.
  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryResponseFromJson(json);

  /// Method to convert a `PaymentHistoryResponse` instance into a map.
  Map<String, dynamic> toJson() => _$PaymentHistoryResponseToJson(this);
}
