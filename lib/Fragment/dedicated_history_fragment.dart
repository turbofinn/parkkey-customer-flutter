import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/Clippers/dedicated_history_clipper1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_screen_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';

class DedicatedHistoryFragment extends StatefulWidget {
  String parkingTicketID;
  DedicatedHistoryFragment({required this.parkingTicketID});

  @override
  State<DedicatedHistoryFragment> createState() =>
      _DedicatedHistoryFragmentState();
}

class _DedicatedHistoryFragmentState extends State<DedicatedHistoryFragment> {
  late String name = "";
  late String parkDate = "";
  late String vehicleNo = "";
  late String duration = "";
  late String location = "";
  late String otp = "";
  late String phone = "";
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('ticketid----' + widget.parkingTicketID);
    fetchVehicleExitInfo();
  }

  @override
  Widget build(BuildContext context) {
    double parentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
                  'Vehicle info',
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Color(CustomColors.PURPLE_DARK)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.01),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              //    margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(CustomColors.PURPLE_LIGHT).withOpacity(0.01),
                Color(CustomColors.PURPLE_DARK).withOpacity(0.2)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(
                children: [
                  Container(
                    height: parentHeight * 0.43,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 9,
                          blurRadius: 9,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 30, top: 150, right: 30),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 40, top: 2),
                          width: 270,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(CustomColors.PURPLE_DARK)
                                    .withOpacity(0.5),
                                width: 1.5),
                            color: Color(CustomColors.PURPLE_DARK)
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Name of Parker: $name',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(CustomColors.PURPLE_DARK)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              padding: EdgeInsets.only(top: 2),
                              width: 150,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(CustomColors.GREEN_DARK)
                                        .withOpacity(0.5),
                                    width: 1.5),
                                color: Color(CustomColors.GREEN_DARK)
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: Color(CustomColors.GREEN_DARK),
                                      size: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    textAlign: TextAlign.center,
                                    parkDate,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(CustomColors.GREEN_DARK)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              // margin: EdgeInsets.only(left: 30),
                              //padding: EdgeInsets.only(top: 2),
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(CustomColors.GREEN_DARK)
                                        .withOpacity(0.5),
                                    width: 1.5),
                                color: Color(CustomColors.GREEN_DARK)
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Text('otp: $otp',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(CustomColors.GREEN_DARK))),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13, right: 13),
                          child: Divider(
                            height: 30,
                            color: Colors.grey.withOpacity(0.5),
                            thickness: 1.5,
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.only(left: 40, top: 2),
                          width: 270,
                          height: 40,
                          padding: EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.5),
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Parking location: $location',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      //  fontWeight: FontWeight.w500,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              //   padding: EdgeInsets.only(left: 20, top: 2),
                              width: 150,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(CustomColors.PURPLE_DARK)
                                        .withOpacity(0.5),
                                    width: 1.5),
                                color: Color(CustomColors.PURPLE_DARK)
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 7),
                                    child: Icon(
                                      Icons.confirmation_number_outlined,
                                      color: Color(CustomColors.PURPLE_DARK),
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(vehicleNo,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color(CustomColors.PURPLE_DARK))),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              // margin: EdgeInsets.only(left: 30),
                              //   padding: EdgeInsets.only(left: 20, top: 2),
                              padding: EdgeInsets.only(top: 2),
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(CustomColors.PURPLE_DARK)
                                        .withOpacity(0.5),
                                    width: 1.5),
                                color: Color(CustomColors.PURPLE_DARK)
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'SU2560',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(CustomColors.PURPLE_DARK)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 270,
                          height: 40,
                          padding: EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(CustomColors.GREEN_DARK)
                                    .withOpacity(0.5),
                                width: 1.5),
                            color:
                                Color(CustomColors.GREEN_DARK).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.phone,
                                size: 20,
                                color: Color(CustomColors.GREEN_DARK),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'mobile number :' + phone,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(CustomColors.GREEN_DARK)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 270,
                          height: 40,
                          padding: EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(CustomColors.GREEN_DARK)
                                    .withOpacity(0.5),
                                width: 1.5),
                            color:
                                Color(CustomColors.GREEN_DARK).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.lock_clock,
                                size: 25,
                                color: Color(CustomColors.GREEN_DARK),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                duration,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(CustomColors.GREEN_DARK)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchVehicleExitInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);
    // print('userid--'+userID!);

    try {
      final response = await apiService.getTicket(widget.parkingTicketID);

      setState(() {
        if (response.customerName != null) {
          name = response.customerName!;
        }

        parkDate = response.parkDate!;
        vehicleNo = response.vehicleNo;
        duration = response.parkedDuration!;
        location = response.parkingLocation!;
        phone = response.mobileNo;
        otp = response.exitOTP!;
      });

      print(response.toString());

      print('response' + response.customerName!);
    } catch (e) {
      print('error123' + e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }
}
