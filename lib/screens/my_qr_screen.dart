import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/models/create_ticket_request.dart';
import 'package:parkey_customer/screens/home_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';

class MyQr extends StatefulWidget {
  const MyQr({super.key});

  @override
  State<MyQr> createState() => _MyQrState();
}

class _MyQrState extends State<MyQr> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateQR();
  }

  bool isLoading = true;
  late String parkingId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(
                  index: 0,
                  path: '/',
                )));
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        index: 0,
                        path: '/',
                      )));
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                weight: 50,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              'Scan QR Code',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 33,
              ),
            )
          ],
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(CustomColors.PURPLE_DARK).withOpacity(0.6),
            Color(CustomColors.PURPLE_LIGHT).withOpacity(0.0)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ListView(
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ClipPath(
                      //   clipper: LoginDoneClipper1(),
                      //   child: Container(
                      //     height: 150,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         gradient: LinearGradient(
                      //       begin: Alignment.topLeft,
                      //       end: Alignment.bottomCenter,
                      //       colors: [
                      //         Color(CustomColors.PURPLE_LIGHT),
                      //         Color(CustomColors.PURPLE_DARK).withOpacity(0.5)
                      //       ],
                      //     )),
                      //   ),
                      // ),
                      // ClipPath(
                      //   clipper: LoginScreenClipper2(),
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //         gradient: LinearGradient(
                      //       begin: Alignment.centerLeft,
                      //       end: Alignment.bottomCenter,
                      //       colors: [
                      //         Color(CustomColors.GREEN_LIGHT).withOpacity(0.1),
                      //         Color(CustomColors.GREEN_LIGHT).withOpacity(0.2)
                      //       ],
                      //     )),
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                // Container(
                                //     height: 30,
                                //     width: 30,
                                //     decoration: BoxDecoration(
                                //         color: Colors.white,
                                //         borderRadius:
                                //             BorderRadius.circular(10)),
                                //     child: GestureDetector(
                                //       onTap: () {
                                //         Navigator.of(context).pushReplacement(
                                //             MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     HomeScreen(
                                //                       index: 0,
                                //                       path: '/',
                                //                     )));
                                //       },
                                //       child: Padding(
                                //         padding: const EdgeInsets.all(8.0),
                                //         child: Image(
                                //             image: AssetImage(
                                //                 'assets/images/arrow_back.png')),
                                //       ),
                                //     )),
                                // Container(
                                //   margin: EdgeInsets.only(left: 20),
                                //   child: Text(
                                //     'Parking Id',
                                //     style: TextStyle(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w600),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: Container(
                              // margin: EdgeInsets.all(),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),
                                    blurRadius: 9,
                                    offset: Offset(-4, -4),
                                  ),
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),
                                    blurRadius: 9,
                                    offset: Offset(9, 9),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(40),
                                color: const Color.fromARGB(255, 255, 252, 252),
                              ),
                              child: Column(
                                children: [
                                  // Center(
                                  //   child: Container(
                                  //     child: Text(
                                  //       'Permanent Parking Id',
                                  //       style: TextStyle(
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.w500),
                                  //     ),
                                  //   ),
                                  // ),
                                  Center(
                                    child: isLoading
                                        ? Container(
                                            margin: EdgeInsets.only(top: 50),
                                            height: 300,
                                            width: 300,
                                            child: SizedBox(
                                              child: Transform.scale(
                                                scale: 0.15,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(CustomColors
                                                              .GREEN_BUTTON)),
                                                  strokeWidth: 30,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(top: 60),
                                            padding: EdgeInsets.all(25),
                                            height: 330,
                                            width: 300,
                                            // decoration: BoxDecoration(
                                            //   boxShadow: [
                                            //     BoxShadow(
                                            //       color: Colors.grey.withOpacity(0.9),
                                            //       blurRadius: 9,
                                            //       offset: Offset(-4, -4),
                                            //     ),
                                            //     BoxShadow(
                                            //       color: Colors.grey.withOpacity(0.9),
                                            //       blurRadius: 9,
                                            //       offset: Offset(9, 9),
                                            //     )
                                            //   ],
                                            //   borderRadius: BorderRadius.circular(20),
                                            //   color: const Color.fromARGB(
                                            //       255, 255, 252, 252),
                                            // ),
                                            child: QrImageView(
                                              data: parkingId,
                                            ),
                                          ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 2),
                                    child: Center(
                                      child: Text(
                                        'Parking QR',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'For Parking Aproval',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                  // Center(
                                  //   child: Container(
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.9,
                                  //     child: Text(
                                  //       'Make Sure Superintendent Of Parking Should Scan And Verify Your Parking',
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.w400,
                                  //           fontSize: 12),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  void generateQR() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String? userID = sharedPreferences.getString(Constants.USER_ID);
    String? vehicleID = sharedPreferences.getString(Constants.VEHICLE_ID);
    String? vehicleNo = sharedPreferences.getString(Constants.VEHICLE_NO);
    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    print('userid--' + userID!);

    final ApiService apiService = ApiService(dio);

    try {
      final response = await apiService.generateQR(
          CreateTicketRequest(userID!, vehicleID!, 'CREATE_TICKET'));

      if (response.errorMessage == "Vehicle is already parked") {
        final response = await apiService.getVehicleDetails(vehicleNo!);
        setState(() {
          parkingId = response.parkingTicketID;
          isLoading = false;
        });
      } else {
        setState(() {
          parkingId = response.parkingTicketID.toString();
          isLoading = false;
        });
      }

      print('responseGenQR' + response.toString());
    } catch (e) {
      final response = await apiService.getVehicleDetails(vehicleNo!);

      setState(() {
        parkingId = response.parkingTicketID;
        isLoading = false;
      });

      print('error123' + e.toString());
    }
  }
}
