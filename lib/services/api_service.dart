import 'package:dio/dio.dart';
import 'package:parkey_customer/models/add_vehicle_request.dart';
import 'package:parkey_customer/models/add_vehicle_response.dart';
import 'package:parkey_customer/models/create_ticket_request.dart';
import 'package:parkey_customer/models/customer_vehicle_details_response.dart';
import 'package:parkey_customer/models/send_otp_request.dart';
import 'package:parkey_customer/models/parked_vehicle_history_resposne.dart';
import 'package:parkey_customer/models/update_customer_details_request.dart';
import 'package:parkey_customer/models/vehicle_details_response.dart';
import 'package:parkey_customer/models/verify_otp_request.dart';
import 'package:parkey_customer/models/verify_otp_response.dart';
import 'package:parkey_customer/models/response.dart';
import 'package:retrofit/http.dart';

import '../models/create_ticket_response.dart';
import '../models/customer_details_response.dart';
import '../models/delete_vehicle_response.dart';
import '../models/get_ticket_response.dart';
import '../models/parked_vehicle_response.dart';
import '../models/parking_location_response.dart';
import '../models/parking_space_info_response.dart';
import '../models/send_otp_response.dart';
import '../models/wallet_balance_response.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: 'https://xkzd75f5kd.execute-api.ap-south-1.amazonaws.com/prod')
abstract class ApiService{
  factory ApiService(Dio dio) = _ApiService;

  @POST('/login-service/send-otp')
  Future<SendOtpResponse> getOtp(@Body() SendOtpRequest sendOtpRequest);

  @POST('/login-service/verify-otp/customer')
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest verifyOtpRequest);

  @POST('/ticket-handler/create-ticket')
  Future<CreateTicketResponse> generateQR(@Body() CreateTicketRequest createTicketRequest);

  @POST('/customer-flow-handler/update-customer-details')
  Future<MyResponse> updateCustomerDetails(@Body() UpdateCustomerDetailsRequest updateCustomerDetailsRequest);

  @GET('/customer-flow-handler/get-vehicle-parking-history')
  Future<ParkedVehicleHistoryResponse> getVehicleParkingHistory(@Query('vehicleID') String param1);

  @GET('/customer-flow-handler/get-customer-vehicle-details')
  Future<CustomerVehicleDetailsResponse> getCustomerVehicleDetails(@Query('userID') String userID);

  @GET('/customer-flow-handler/get-customer-parking-history')
  Future<ParkedVehicleResponse> getCustomerParkingHistory(@Query('userID') String userID);

  @GET('/customer-flow-handler/get-customer-details')
  Future<CustomerDetailsResponse> getCustomerDetails(@Query('userID') String userID);

  @GET('/user-management/parking-space/fetch-parking-space-info/{parkingSpaceID}')
  Future<ParkingSpaceInfoResponse> getParkingSpaceInfo(@Path('parkingSpaceID') String parkingSpaceID);

  @GET('/ticket-handler/get-ticket')
  Future<GetTicketResponse> getTicket(@Query('parkingTicketID') String parkingTicketID);

  @GET('/customer-flow-handler/get-parking-space-by-city')
  Future<List<ParkingLocationResponse>> getParkingSpaceList(@Query('city') String city);

  @POST('/customer-flow-handler/add-vehicle')
  Future<AddVehicleResponse> addVehicle(@Body() AddVehicleRequest addVehicleRequest);

  @GET('/customer-flow-handler/get-vehicle-details')
  Future<VehicleDetailsResponse> getVehicleDetails(@Query('vehicleNo') String vehicleNo);

  @GET('/customer-flow-handler/get-wallet-details')
  Future<WalletBalanceResponse> getWalletDetails(@Query('userID') String userID);

  @DELETE('/customer-flow-handler/delete-vehilcle')
  Future<DeleteVehicleResponse> deleteVehicle(@Query('vehicleNo') String vehicleNo);


}