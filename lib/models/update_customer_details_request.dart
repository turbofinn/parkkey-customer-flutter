
import 'package:json_annotation/json_annotation.dart';
part 'update_customer_details_request.g.dart';

@JsonSerializable()
class UpdateCustomerDetailsRequest{
  final String source;
  final String userID;
  final String gender;
  final String emailID;
  final String primaryVehicle;
  final String customerName;


  UpdateCustomerDetailsRequest(
      this.source, this.userID, this.gender, this.emailID, this.primaryVehicle, this.customerName);

  factory UpdateCustomerDetailsRequest.fromJson(Map<String, dynamic> json) => _$UpdateCustomerDetailsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateCustomerDetailsRequestToJson(this);

}