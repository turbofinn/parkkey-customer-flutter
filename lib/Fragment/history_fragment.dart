import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/UIComponents/back_top_title.dart';
import 'package:parkey_customer/UIComponents/history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/CustomColors.dart';
import '../models/parked_vehicle_response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class HistoryFragment extends StatefulWidget {
  const HistoryFragment({super.key});

  @override
  State<HistoryFragment> createState() => _HistoryFragmentState();
}

class _HistoryFragmentState extends State<HistoryFragment> {
  List<CustomerVehicleResponse> customerVehicleResponseList = [];
  bool isLoading = true;
  String errorMessage="";
  String ?customerName;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleHistory();
  }

  @override
  Widget build(BuildContext context) {
    double parentHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Material(
      child: Column(
        children: [
          BackTopTitle('', Colors.black,
              'Parking History', ''),
          isLoading ? Center(
            child: Container(
              margin: EdgeInsets.only(top: parentHeight*0.2),
              height: 300,
              width: 300,
              child: errorMessage != "" ? Center(child: Container(child: Text(errorMessage),),) : SizedBox(
                child: Transform.scale(
                  scale: 0.2,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(CustomColors.GREEN_BUTTON)),
                    strokeWidth: 25,
                  ),
                ),
              ),
            ),
          )
          : Expanded(
            child: ListView.builder(
              shrinkWrap: true, // Adapt size to content
              itemCount: customerVehicleResponseList.length,
              itemBuilder: (context, index) {
                final item = customerVehicleResponseList[index];
                return HistoryItem(
                    customerName == null ? item.customerName ?? "NA" : customerName!,
                    item.vehicleNo,
                    item.vehicleType,
                    item.parkingLocation!,
                    item.parkDate!,
                    item.parkingStatus!,
                    item.parkedDuration!,false,getVehicleHistory,item.parkingCharges);
              },
            ),
          )

        ],
      ),
    ));
  }

  void getVehicleHistory() async {
    print('histrotry-frag');
    try{


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String? userID = sharedPreferences.getString(Constants.USER_ID);
    customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME);

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);

    try {
      final response = await apiService.getCustomerParkingHistory(userID!);

      if(response.customerVehicleList.isEmpty){
        setState(() {
          errorMessage = Constants.EMPTY_VEHICLE_LIST;
        });
        return;
      }

      List<CustomerVehicleResponse> tempList = [];
      int len = response.customerVehicleList.length;
      print('length--' + len.toString());
      for (int i = 0; i < len; i++) {
          tempList.add(response.customerVehicleList.elementAt(i));
      }

      print("historyFragment-->" + jsonEncode(tempList));
      print("historyFragment1-->" + jsonEncode(response.customerVehicleList));

      setState(() {
        customerVehicleResponseList = tempList;
        isLoading = false;
        print('HistoryFragment1');

      });

      print(response.toString());

    } on DioException catch (e) {
      if(e.response?.statusCode == 400){
        String errorMessage = e.response?.data['message'];
        print("errorMessage---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
        setState(() {
          this.errorMessage = errorMessage;
        });
      }
      else{
        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }
    }
    }catch(e){
      print('HistoryFragment2');

      setState(() {
          errorMessage = Constants.GENERIC_ERROR_MESSAGE;
        });
    }
  }
}
