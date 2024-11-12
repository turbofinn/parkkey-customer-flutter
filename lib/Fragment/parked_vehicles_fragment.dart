import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/UIComponents/back_top_title.dart';
import 'package:parkey_customer/UIComponents/history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/CustomColors.dart';
import '../models/customer_vehicle_details_response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class ParkedFragment extends StatefulWidget {
  const ParkedFragment({super.key});

  @override
  State<ParkedFragment> createState() => _ParkedFragmentState();
}

class _ParkedFragmentState extends State<ParkedFragment> {
  List<CustomerVehicleResponse> customerVehicleResponseList = [];
  bool isLoadding = true;
  String errorMessage = "";
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
    double parentWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Material(
      child: Column(
        children: [
          BackTopTitle('', Colors.black,
              'Parked Vehicle', ''),
          isLoadding
              ? Center(
                  child: Container(
                    margin: EdgeInsets.only(top: parentHeight * 0.2),
                    height: 300,
                    width: 300,
                    child: errorMessage != ""
                        ? Center(
                            child: Container(
                              child: Text(errorMessage),
                            ),
                          )
                        : SizedBox(
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
                    shrinkWrap: true,
                    itemCount: customerVehicleResponseList.length,
                    itemBuilder: (context, index) {
                      final item = customerVehicleResponseList[index];
                      return GestureDetector(
                        onTap: () {
                          print('item---' + item.parkingTicketID!);
                          Navigator.of(context).pushNamed(
                              '/DedicatedHistoryFragment',
                              arguments: item.parkingTicketID);
                        },
                        child: HistoryItem(
                            customerName == null ? "NA" : customerName!,
                            item.vehicleNo,
                            item.vehicleType,
                            item.parkingLocation!,
                            item.parkingDateTime!.substring(0, 10),
                            item.parkingDateTime!.substring(11, 16),
                            item.parkingDuration!,false,getVehicleHistory, null),
                      );
                    },
                  ),
                )
        ],
      ),
    ));
  }

  void getVehicleHistory() async {
    print('pvf');
    try{


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String? userID = sharedPreferences.getString(Constants.USER_ID);
    customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME);

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);

    try {
      final response = await apiService.getCustomerVehicleDetails(userID!);

      List<CustomerVehicleResponse> tempList = [];
      int len = response.customerVehicleList.length;
      print('length--' + len.toString());
      for (int i = 0; i < len; i++) {
        if (response.customerVehicleList.elementAt(i).parkingLocation != null) {
          print('location--' +
              response.customerVehicleList.elementAt(i).parkingLocation!);
          tempList.add(response.customerVehicleList.elementAt(i));
        }
      }

      var json = jsonEncode(tempList);
      print("History-->" + jsonEncode(response.customerVehicleList));
      print('ParkedList-->' + json);

      if (tempList.isEmpty) {
        setState(() {
          errorMessage = Constants.EMPTY_VEHICLE_LIST;
        });
        return;
      }

      setState(() {
        customerVehicleResponseList = tempList;
        isLoadding = false;
      });

      print(response.toString());

      print('response' +
          response.customerVehicleList.elementAt(2).vehicleType.toString());
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        String errorMessage = e.response?.data['message'];
        print("errorMessage---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
        setState(() {
          this.errorMessage = errorMessage;
        });
      } else {
        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }
    }
    }catch(e){
setState(() {
  errorMessage = Constants.GENERIC_ERROR_MESSAGE;
});
    }
  }
}
