import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkey_customer/Clippers/login_screen_clipper1.dart';
import 'package:parkey_customer/HomeFragment.dart';
import 'package:parkey_customer/models/add_vehicle_request.dart';
import 'package:parkey_customer/models/send_otp_request.dart';
import 'package:parkey_customer/models/send_otp_response.dart';
import 'package:parkey_customer/models/verify_otp_request.dart';
import 'package:parkey_customer/models/verify_otp_response.dart';
import 'package:parkey_customer/screens/home_screen.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/upper_text_formatter.dart';

class PostLoginScreen extends StatefulWidget {
  const PostLoginScreen({super.key});

  @override
  State<PostLoginScreen> createState() => _PostLoginScreenState();
}

class _PostLoginScreenState extends State<PostLoginScreen> {
  final TextEditingController vehicleNumberInputController =
  TextEditingController();
  String? vehicleType;
  final List<String> _items = ['Car', 'Bike', 'Heavy Vehicle', 'Bicycle'];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Material(
          child: ListView(
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipPath(
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
                                  Color(CustomColors.PURPLE_DARK).withOpacity(
                                      0.5)
                                ],
                              )),
                        ),
                      ),
                      ClipPath(
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
                                  Color(CustomColors.GREEN_LIGHT).withOpacity(
                                      0.1),
                                  Color(CustomColors.GREEN_LIGHT).withOpacity(
                                      0.2)
                                ],
                              )),
                        ),
                      ),
                    ],
                  ),
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
                    children: [
                      Image.asset('assets/images/post_login_img1.png'),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          'Vehicle No.', style: TextStyle(fontWeight: FontWeight
                            .w600),),
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Container(
                            height: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color(CustomColors.PURPLE_DARK),
                                    width: 2)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Image(
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'assets/images/post_login_img2.png'),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 7),
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: vehicleNumberInputController,
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        maxLength: 10,
                                        style: TextStyle(fontSize: 22),
                                        onChanged: (text) {
                                          if (text.length == 10) {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                          hintText: "Enter Vehicle Number",
                                          counterText: '',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                            border: Border.all(
                                color: Color(CustomColors.GREEN_BUTTON),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,top: 7,bottom: 7),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: vehicleType,
                            hint: Text('Select Vehicle Type'),
                            items: _items.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                vehicleType = newValue;
                              });
                            },
                          ),
                        ),
                      ),

                      isLoading ? Container(
                        margin: EdgeInsets.only(top: 50),
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color(CustomColors.GREEN_BUTTON)),
                          strokeWidth: 4,
                        ),
                      ) : Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.5,
                        margin: EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          onPressed: () {
                            try{
                              addVehicle(vehicleNumberInputController.text,vehicleType!);
                            }catch(e){
                              Fluttertoast.showToast(
                                msg: 'Select Vehicle Type',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }

                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Color(CustomColors.GREEN_BUTTON)),
                          child: const Text('Next',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white)),
                        ),
                      ),

                      Center(
                          child: Text(
                            'Please Enter\nYour Default Vehicle',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 24),
                          )),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addVehicle(String vehicleNo, String vehicleType) async {

    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String? userID = sharedPreferences.getString(Constants.USER_ID);

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);

    try {
      final response = await apiService.addVehicle(
          AddVehicleRequest(userID!, vehicleNo,vehicleType));

      sharedPreferences.setString(Constants.VEHICLE_ID, response.vehicleID);
      sharedPreferences.setString(Constants.VEHICLE_NO, vehicleNumberInputController.text);
      sharedPreferences.setString(Constants.VEHICLE_TYPE, vehicleType);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

    } on DioException catch (e) {
      String errorMessage = e.response?.data['message'];
      print("errorMessage---" + errorMessage.toString());
      CommonUtil().showToast(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }
}


