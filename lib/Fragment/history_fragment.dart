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
    double parentWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
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
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(CustomColors.PURPLE_LIGHT).withOpacity(0.01),
            Color(CustomColors.PURPLE_DARK).withOpacity(0.2),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: isLoading
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
                    //BackTopTitle('', Colors.black, 'Parking History', ''),
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
                                  width: parentWidth * 0.88,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                          spreadRadius: 6)
                                    ],
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 1.5,
                                        color: Color(CustomColors.GREEN_DARK)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.history,
                                          color: Color(CustomColors.GREEN_DARK)
                                              .withOpacity(0.9),
                                          size: 28,
                                        ),
                                        Text(selectedItem ?? "All Vehicles",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Color(
                                                        CustomColors.GREEN_DARK)
                                                    .withOpacity(0.9))),
                                        Icon(
                                          isDropdownExpanded
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                          color: Color(CustomColors.GREEN_DARK),
                                          size: 28,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              // Dropdown Items
                              if (isDropdownExpanded)
                                Container(
                                  width: parentWidth * 0.88,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 9,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                          spreadRadius: 8)
                                    ],
                                    border:
                                        Border.all(color: Colors.grey.shade300),
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
                                  final item =
                                      customerVehicleResponseList[index];
                                  String assetImage = 'assets/Icons/';
                                  if (item.vehicleType == 'Car') {
                                    assetImage += 'car.png';
                                  } else if (item.vehicleType == 'Bike') {
                                    assetImage += 'bycicle.png';
                                  } else if (item.vehicleType ==
                                      'Heavy Vehicle') {
                                    assetImage += 'truck.png';
                                  } else {
                                    assetImage += 'cycle.png';
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 8, right: 8),
                                    child: Container(
                                      height: parentHeight * 0.33,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 7,
                                              spreadRadius: 8),
                                        ],
                                      ),
                                      child: Container(
                                        width: parentWidth * 0.7,
                                        margin: EdgeInsets.only(
                                            top: 15,
                                            left: 18,
                                            right: 18,
                                            bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    // color: Color(CustomColors.GREEN_DARK).withOpacity(0.2),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Image(
                                                      height: 50,
                                                      width: 50,
                                                      image: AssetImage(
                                                          assetImage),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(
                                                    //   item.parkingName ?? "",
                                                    //   style: TextStyle(
                                                    //     fontWeight:
                                                    //         FontWeight.w600,
                                                    //     fontSize: 14,
                                                    //     color: Colors.black
                                                    //         .withOpacity(0.7),
                                                    //   ),
                                                    // ),
                                                    Container(
                                                      width: 180,
                                                      height: 36,
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                      decoration: BoxDecoration(
                                                        color: Color(CustomColors
                                                                .GREEN_BUTTON)
                                                            .withOpacity(0.3),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Color(
                                                                CustomColors
                                                                    .GREEN_DARK)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Text(
                                                        item.vehicleNo ?? "",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18,
                                                          color: Color(
                                                              CustomColors
                                                                  .GREEN_DARK),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Color(
                                                                    CustomColors
                                                                        .PURPLE_DARK)
                                                                .withOpacity(
                                                                    0.3),
                                                            width: 1),
                                                        color: Color(CustomColors
                                                                .PURPLE_DARK)
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3.0),
                                                        child: Text(
                                                          textAlign:
                                                              TextAlign.center,
                                                          item.vehicleType ??
                                                              "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                thickness: 1.5,
                                                height: 10,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 40,
                                                  padding: EdgeInsets.only(
                                                      bottom: 5, top: 5),
                                                  width: 280,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12.0),
                                                        child: Icon(
                                                          Icons.location_on,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 224, 1, 1),
                                                          size: 30,
                                                        ),
                                                      ),
                                                      Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'Parked At: ${item.parkingLocation ?? ""}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: 220,
                                              decoration: BoxDecoration(
                                                color: Color(CustomColors
                                                        .PURPLE_DARK)
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Color(
                                                      CustomColors.PURPLE_DARK),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: Icon(
                                                        Icons
                                                            .punch_clock_rounded,
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                        size: 22),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Text(
                                                      '${item.entryTime ?? ""}',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: 220,
                                              decoration: BoxDecoration(
                                                color: Color(CustomColors
                                                        .PURPLE_DARK)
                                                    .withOpacity(0.4),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Color(
                                                      CustomColors.PURPLE_DARK),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Icon(
                                                        Icons.timer_outlined,
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                        size: 22),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            7.0),
                                                    child: Text(
                                                      'Exit time: ${item.exitTime ?? ""}',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK),
                                                      ),
                                                    ),
                                                  ),
                                                ],
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
