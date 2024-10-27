
import 'package:json_annotation/json_annotation.dart';
part 'customer_details_response.g.dart';

@JsonSerializable()
class CustomerDetailsResponse{
  final String? customerName;
  final String? mobileNo;
  final String? gender;
  final String? primaryVehicle;
  final String? emailID;


  CustomerDetailsResponse(
      {this.customerName,
      this.mobileNo,
      this.gender,
      this.primaryVehicle,
      this.emailID});

  factory CustomerDetailsResponse.fromJson(Map<String, dynamic> json) => _$CustomerDetailsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerDetailsResponseToJson(this);

}