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

  late String name="";
  late String parkDate="";
  late String vehicleNo="";
  late String duration="";
  late String location="";
  late String otp="";
  late String phone="";
  bool isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('ticketid----'+widget.parkingTicketID);
    fetchVehicleExitInfo();
  }


  @override
  Widget build(BuildContext context) {
    double parentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Material(
        child: isLoading ? Center(
          child: Container(
            height: 300,
            width: 300,
            child: SizedBox(
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
        ) : Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: ClipPath(
                    clipper: LoginScreenClipper1(),
                    child: Container(
                      height: 150,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(CustomColors.PURPLE_LIGHT),
                              Color(CustomColors.PURPLE_DARK).withOpacity(0.5)
                            ],
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: ClipPath(
                    clipper: LoginScreenClipper2(),
                    child: Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height - 150,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(CustomColors.GREEN_LIGHT).withOpacity(0.1),
                              Color(CustomColors.GREEN_LIGHT).withOpacity(0.2)
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 200,
              height: 200,
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
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30,bottom: 20),
                  width: double.infinity,
                  child: Center(child: Text('Vehicle Info',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20,color: Colors.black),)),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30,right: 30),
                              child: ClipPath(
                                clipper: DedicatedHistoryClipper1(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(CustomColors.PURPLE_LIGHT),
                                          Color(CustomColors.PURPLE_DARK).withOpacity(0.5)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Container(child: Image(
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.contain,
                                          image: AssetImage('assets/images/logo.png'),
                                        ),),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('Name of Parker:',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    child: Text(name,style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('Date:',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    child: Text(parkDate,style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('Parking No. :',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    child: Text('SU2560',style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('Vehicle No. :',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    child: Text(vehicleNo,style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('Duration :',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    child: Text(duration,style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('Parking Location :',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    width: 90,
                                                    child: Text(location,style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('Phone :',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    child: Text(phone,style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text('OTP :',style: TextStyle(fontSize: 10,color: Colors.white),),
                                                  ),
                                                  Container(
                                                    width: 90,
                                                    child: Text(otp,style: TextStyle(fontSize: 12,color: Colors.white),),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  void fetchVehicleExitInfo() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);
    // print('userid--'+userID!);

    try {
      final response = await apiService.getTicket(widget.parkingTicketID);

      setState(() {
        if(response.customerName != null){
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
