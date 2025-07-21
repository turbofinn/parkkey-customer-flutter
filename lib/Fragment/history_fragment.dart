import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/UIComponents/back_top_title.dart';
import 'package:parkey_customer/UIComponents/history_item.dart';
import 'package:parkey_customer/models/parked_vehicle_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/CustomColors.dart';
import '../models/customer_vehicle_details_response.dart';
import '../models/parked_vehicle_history_resposne.dart';
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
  List<ParkingResponse> customerVehicleResponseList = [];
  List<ParkingResponse> originalList = []; // Holds unfiltered data
  bool isLoading = true;
  String errorMessage = "";
  String? customerName;
  String? selectedItem;
  List<String> uniqueVehicles = [];
  bool isDropdownExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleHistory();
    getCustomerVehicleHistory();
  }

  @override
  Widget build(BuildContext context) {
    double parentHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Center(
          child: Container(
            margin: EdgeInsets.only(top: parentHeight * 0.2),
            height: 300,
            width: 300,
            child: errorMessage != ""
                ? Center(
              child: Text(errorMessage),
            )
                : Transform.scale(
              scale: 0.2,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(CustomColors.GREEN_BUTTON)),
                strokeWidth: 25,
              ),
            ),
          ),
        )
            : Column(
          children: [
            BackTopTitle('', Colors.black, 'Parking History', ''),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      // Dropdown Header
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDropdownExpanded = !isDropdownExpanded;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedItem ?? "All"),
                              Icon(isDropdownExpanded
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),

                      // Dropdown Items
                      if (isDropdownExpanded)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: uniqueVehicles.map((value) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedItem = value;
                                    isDropdownExpanded = false;
                                    filterHistory(selectedItem!);
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      // Parking History List
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: customerVehicleResponseList.length,
                        itemBuilder: (context, index) {
                          final item = customerVehicleResponseList[index];
                          String assetImage = 'assets/images/';
                          if (item.vehicleType == 'Car') {
                            assetImage += 'car.png';
                          } else if (item.vehicleType == 'Bike') {
                            assetImage += 'bike.png';
                          } else if (item.vehicleType == 'Heavy Vehicle') {
                            assetImage += 'truck.png';
                          } else {
                            assetImage += 'cycle.png';
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image(
                                          height: 50,
                                          width: 50,
                                          image: AssetImage(assetImage),
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.parkingName ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            Text(
                                              item.vehicleNo ?? "",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'Vehicle Type: ${item.vehicleType ?? ""}',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Parked At: ${item.parkingLocation ?? ""}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color:
                                            Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                        Text(
                                          'Parking Charges: ${item.parkingCharges ?? ""}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Entry Time: ${item.entryTime ?? ""}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                    Text(
                                      'Exit Time: ${item.exitTime ?? ""}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                        Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  void getVehicleHistory([String? searchParam]) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);
      customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      final response = await apiService.getCustomerVehicleDetails(userID!);

      Set<String> uniqueVehicle = {"All"};

      int len = response.customerVehicleList.length;
      for (int i = 0; i < len; i++) {
        String vno = response.customerVehicleList.elementAt(i).vehicleNo;
        uniqueVehicle.add(vno);
      }

      if (response.customerVehicleList.isEmpty) {
        setState(() {
          errorMessage = Constants.EMPTY_VEHICLE_LIST;
          isLoading = false;
        });
        return;
      }

      setState(() {
        uniqueVehicles = uniqueVehicle.toList();
      });
    } catch (e) {
      setState(() {
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
        isLoading = false;
      });
    }
  }

  void getCustomerVehicleHistory() async {

    print("Called");
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);
      customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      final response = await apiService.getCustomerParkingHistory(userID!);

      // Convert list of maps to JSON string
      String jsonString = jsonEncode(response);

      // Print the JSON string
      print(" fdvfdv -->" + jsonString);

      setState(() {
        originalList =
            response.parkedVehicleHistoryList; // Save unfiltered list
        customerVehicleResponseList = [
          ...originalList
        ]; // Initialize filtered list
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
        isLoading = false;
      });
    }
  }

  void filterHistory(String query) {
    setState(() {
      if (query.isEmpty || query == "All") {
        // Reset to the original unfiltered list
        customerVehicleResponseList = [...originalList];
      } else {
        // Filter based on vehicle number or parking location
        customerVehicleResponseList = originalList.where((item) {
          final vehicleNoMatch =
              item.vehicleNo?.toLowerCase().contains(query.toLowerCase());
          final parkingLocationMatch = (item.parkingLocation
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ??
              false);
          return vehicleNoMatch! || parkingLocationMatch;
        }).toList();
      }
    });
  }
}
