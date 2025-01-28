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

class HistoryFragment extends StatefulWidget {
  const HistoryFragment({super.key});

  @override
  State<HistoryFragment> createState() => _HistoryFragmentState();
}

class _HistoryFragmentState extends State<HistoryFragment> {
  List<CustomerVehicleResponse> customerVehicleResponseList = [];
  List<CustomerVehicleResponse> originalList = []; // Holds unfiltered data
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
        BackTopTitle('', Colors.black, 'Parking History', ''),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            onChanged: (query) {
              filterHistory(query); // Call search logic
            },
            decoration: InputDecoration(
              hintText: 'Search by vehicle number or location',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        isLoading
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
                  shrinkWrap: true, // Adapt size to content
                  itemCount: customerVehicleResponseList.length,
                  itemBuilder: (context, index) {
                    final item = customerVehicleResponseList[index];
                    return item.parkingLocation != null
                        ? HistoryItem(
                            customerName ?? "NA",
                            item.vehicleNo,
                            item.vehicleType,
                            item.parkingLocation!,
                            item.parkingDateTime!.substring(0, 10),
                            item.parkingDateTime!.substring(11, 16),
                            item.parkingDuration!,
                            false,
                            getVehicleHistory)
                        : HistoryItem(
                            customerName ?? "NA",
                            item.vehicleNo,
                            item.vehicleType,
                            null,
                            null,
                            null,
                            null,
                            false,
                            getVehicleHistory);
                  },
                ),
              )
      ],
    ),
  ));
}

  
  void getVehicleHistory([String? searchParam]) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String? userID = sharedPreferences.getString(Constants.USER_ID);
    customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME);

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);

    final response = await apiService.getCustomerVehicleDetails(userID!);

    if (response.customerVehicleList.isEmpty) {
      setState(() {
        errorMessage = Constants.EMPTY_VEHICLE_LIST;
        isLoading = false;
      });
      return;
    }

    setState(() {
      originalList = response.customerVehicleList; // Save unfiltered list
      customerVehicleResponseList = [...originalList]; // Initialize filtered list
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      errorMessage = Constants.GENERIC_ERROR_MESSAGE;
      isLoading = false;
    });
  }
}

void filterHistory(String query) {
  setState(() {
    if (query.isEmpty) {
      // Reset to the original unfiltered list
      customerVehicleResponseList = [...originalList];
    } else {
      // Filter based on vehicle number or parking location
      customerVehicleResponseList = originalList.where((item) {
        final vehicleNoMatch = item.vehicleNo.toLowerCase().contains(query.toLowerCase());
        final parkingLocationMatch =
            (item.parkingLocation?.toLowerCase().contains(query.toLowerCase()) ?? false);
        return vehicleNoMatch || parkingLocationMatch;
      }).toList();
    }
  });
}


}
