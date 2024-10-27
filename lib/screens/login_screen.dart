import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkey_customer/Clippers/login_screen_clipper1.dart';
import 'package:parkey_customer/HomeFragment.dart';
import 'package:parkey_customer/models/send_otp_request.dart';
import 'package:parkey_customer/models/send_otp_response.dart';
import 'package:parkey_customer/models/verify_otp_request.dart';
import 'package:parkey_customer/models/verify_otp_response.dart';
import 'package:parkey_customer/screens/home_screen.dart';
import 'package:parkey_customer/screens/post_login_screen.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileNumberInputController =
      TextEditingController();
  bool isVisibleOtpTextField = false;
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool isOtpValid = true, isOtpEntered = false, isLoading = false,isWhatsAppAvailable = false;
  final apiService =
      ApiService(Dio(BaseOptions(contentType: "application/json")));

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
                          width: MediaQuery.of(context).size.width,
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
                      ClipPath(
                        clipper: LoginScreenClipper2(),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 150,
                          width: MediaQuery.of(context).size.width,
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
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/images/hand.png'),
                      Center(
                          child: Text(
                        'Verify Your Mobile Number',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      )),
                      Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Center(
                                child: Text(
                              'Please Let Us Know Your Mobile Number For Verification purpose',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ))),
                      ),
                      Center(
                        child: Container(
                            margin: EdgeInsets.only(top: 50),
                            height: 50,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: isVisibleOtpTextField
                                ? Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Pinput(
                                      controller: pinController,
                                      focusNode: focusNode,
                                      defaultPinTheme: PinTheme(
                                        width: 40,
                                        height: 45,
                                        textStyle: const TextStyle(
                                          fontSize: 22,
                                          color: Color(0xff000000),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: isOtpValid
                                              ? null
                                              : Border.all(
                                                  color: Color(0xffFF0000)),
                                        ),
                                      ),
                                      separatorBuilder: (index) =>
                                          const SizedBox(width: 36),
                                      // validator: (value) {
                                      //   return value == '2222' ? null : '';
                                      // },
                                      hapticFeedbackType:
                                          HapticFeedbackType.lightImpact,
                                      onCompleted: (pin) {
                                        setState(() {
                                          isOtpEntered = true;
                                        });
                                        debugPrint('onCompleted: $pin');
                                      },
                                      onChanged: (value) {
                                        debugPrint('onChanged: $value');
                                      },
                                      cursor: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 9),
                                            width: 22,
                                            height: 1,
                                            color: Color(
                                                CustomColors.GREEN_BUTTON),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey, width: 2)),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text('+91 '),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(bottom: 7),
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: mobileNumberInputController,
                                                maxLength: 10,
                                                onChanged: (text) {
                                                  if (text.length == 10) {
                                                    FocusScope.of(context).unfocus();
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    isCollapsed: true,
                                                    counterText: '',
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                      ),
                      !isVisibleOtpTextField
                          ? Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 30),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      activeColor: Color(CustomColors.GREEN_BUTTON),
                                        value: isWhatsAppAvailable, onChanged: (value) {
                                          setState(() {
                                            isWhatsAppAvailable = value!;
                                          });
                                          print('checkboc--' + isWhatsAppAvailable.toString());
                                          print('checkboc--' + value.toString());
                                    }),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Center(
                                            child: Text(
                                                'Is This Same Number In \nWhatsapp',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(CustomColors
                                                        .GREEN_DARK),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14))))
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Center(
                        child: isLoading
                            ? Container(
                                margin: EdgeInsets.only(top: 50),
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(CustomColors.GREEN_BUTTON)),
                                  strokeWidth: 4,
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                margin: EdgeInsets.only(top: 50),
                                child: ElevatedButton(
                                  onPressed: () {
                                    !isVisibleOtpTextField
                                        ? sendOtp(
                                            mobileNumberInputController.text)
                                        : verifyOtp(
                                            mobileNumberInputController.text,
                                            pinController.text);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color(CustomColors.GREEN_BUTTON)),
                                  child: isVisibleOtpTextField
                                      ? const Text('Verify',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white))
                                      : const Text('Send',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                ),
                              ),
                      ),
                      isVisibleOtpTextField ?
                      GestureDetector(
                        onTap: (){
                          sendOtp(
                              mobileNumberInputController.text);
                        },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 6),
                            child: Text('Resend OTP',
                              style: TextStyle(
                                fontSize: 16,),
                          ),
                        )
                                            ,
                      )) : Container()],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendOtp(String mobileNo) async {
    print('inside click: ' + mobileNo);

    if(mobileNo.length != 10){
      CommonUtil().showToast(Constants.INVALID_PHONE_NUMBER);
      return;
    }

    setState(() {
      isLoading = true;
    });
    final SendOtpResponse sendOtpResponse =
    await apiService.getOtp(SendOtpRequest(mobileNo,isWhatsAppAvailable));
    try {

      print(sendOtpResponse.message);
      if (sendOtpResponse.message == 'OTP Sent Successfully.') {
        print(sendOtpResponse.message);
        setState(() {
          isVisibleOtpTextField = true;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      print(e.toString());
    }
  }

  verifyOtp(String mobileNo, String otp) async {
    print('inside verifyotp ' + otp);

    if(otp.length != 4){
      setState(() {
        isOtpValid = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      final VerifyOtpResponse response =
          await apiService.verifyOtp(VerifyOtpRequest(mobileNo, otp));
      String defaultVehicle = response.defaultVehicleNo ?? "";
      print('verify--' + defaultVehicle);
      if (response.status?.code == 1001) {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? userID = response.user?.userId;
        sharedPreferences.setString(Constants.USER_ID, userID!);
        sharedPreferences.setString(Constants.MOBILE_NUMBER, mobileNo);
        sharedPreferences.setString(Constants.ACCESS_TOKEN, response.token!);
        sharedPreferences.setString(
            Constants.REFRESH_TOKEN, response.refreshToken!);

        if(defaultVehicle == ""){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PostLoginScreen()));
        }else{
          final jsonDecoded = jsonDecode(defaultVehicle);
          String defaultVehicleNo = jsonDecoded['vehicleNo'];
          String defaultVehicleType = jsonDecoded['vehicleType'];
          String defaultVehicleID = jsonDecoded['vehicleID'];

          print('number-->' + defaultVehicleNo + " type-->" + defaultVehicleType + " id-->" + defaultVehicleID);

          sharedPreferences.setString(Constants.VEHICLE_ID, defaultVehicleID);
          sharedPreferences.setString(Constants.VEHICLE_NO, defaultVehicleNo);
          sharedPreferences.setString(Constants.VEHICLE_TYPE, defaultVehicleType);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

        }

      }
      else{
        CommonUtil().showToast(response.message!);
      }
      setState(() {
        isLoading = false;
      });
    } on DioException catch (e) {
      if(e.response?.statusCode == 400){
        String errorMessage = e.response?.data['message'];
        print("errorMessage---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
        setState(() {
          isOtpValid = false;
          isLoading = false;
        });
      }
      else{
        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }


      print(e.toString());
    }
  }
}
