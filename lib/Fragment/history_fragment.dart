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
  String errorMessage = "";
  String? customerName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleHistory();
  }

  @override
  Widget build(BuildContext context) {
    double parentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 77,
        leading: Container(
            margin: EdgeInsets.only(top: 18, left: 10, bottom: 17),
            height: 2,
            width: 20,
            decoration: BoxDecoration(
                color: Color(CustomColors.PURPLE_DARK),
                borderRadius: BorderRadius.circular(10)),
            child: IconButton(
                onPressed: () {
                  // Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))),
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Parking History',
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(CustomColors.PURPLE_DARK)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.01),
              // child: Text(
              //   'Add new Vehicle',
              //   style: TextStyle(
              //       fontSize: 15, color: Colors.grey.withOpacity(0.9)),
              // ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 20, top: 20),
        child: Column(
          children: [
            isLoading
                ? Center(
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(top: parentHeight * 0.2),
                      height: 400,
                      width: 250,
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
                      shrinkWrap: true, // Adapt size to content
                      itemCount: customerVehicleResponseList.length,
                      itemBuilder: (context, index) {
                        final item = customerVehicleResponseList[index];
                        return HistoryItem(
                            customerName == null
                                ? item.customerName ?? "NA"
                                : customerName!,
                            item.vehicleNo,
                            item.vehicleType,
                            item.parkingLocation!,
                            item.parkDate!,
                            item.parkingStatus!,
                            item.parkedDuration!,
                            false,
                            getVehicleHistory,
                            item.parkingCharges);
                      },
                    ),
                  )
          ],
        ),
      )),
    );
  }

  void getVehicleHistory() async {
    print('histrotry-frag');
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);
      customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.getCustomerParkingHistory(userID!);

        if (response.customerVehicleList.isEmpty) {
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
    } catch (e) {
      print('HistoryFragment2');

      setState(() {
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
      });
    }
  }
}
