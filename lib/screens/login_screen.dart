import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkey_customer/models/send_otp_request.dart';
import 'package:parkey_customer/models/send_otp_response.dart';
import 'package:parkey_customer/models/verify_otp_request.dart';
import 'package:parkey_customer/models/verify_otp_response.dart';
import 'package:parkey_customer/screens/home_screen.dart';
import 'package:parkey_customer/screens/post_login_screen.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import 'dart:async';

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
  bool isOtpValid = true,
      isOtpEntered = false,
      isLoading = false,
      isWhatsAppAvailable = false;
  Timer? _timer;
  int _resendCountdown = 0;
  bool _canResend = true;

  final apiService = ApiService(
    Dio(BaseOptions(contentType: "application/json")),
  );

  @override
  void dispose() {
    _timer?.cancel();
    mobileNumberInputController.dispose();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 30;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(CustomColors.PURPLE_DARK).withOpacity(0.05),
                    Colors.grey[50]!,
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    40, // Increased padding
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/hand.png',
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Verify Your Mobile Number',
                      style: TextStyle(
                        color: Color(CustomColors.PURPLE_DARK),
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        fontFamily: "Poppins-Bold",
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        'Please Let Us Know Your Mobile Number For Verification purpose',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(
                              CustomColors.PURPLE_DARK,
                            ).withOpacity(0.08),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 48,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: isVisibleOtpTextField
                                ? Center(
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Pinput(
                                        controller: pinController,
                                        focusNode: focusNode,
                                        length: 4,
                                        defaultPinTheme: PinTheme(
                                          width: 48,
                                          height: 48,
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(
                                              CustomColors.PURPLE_DARK,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[50],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: isOtpValid
                                                  ? Colors.grey[300]!
                                                  : Colors.red,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        focusedPinTheme: PinTheme(
                                          width: 48,
                                          height: 48,
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Color(
                                              CustomColors.PURPLE_DARK,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Color(
                                                CustomColors.GREEN_BUTTON,
                                              ),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        separatorBuilder: (index) =>
                                            SizedBox(width: 10),
                                        onCompleted: (pin) {
                                          setState(() {
                                            isOtpEntered = true;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            isOtpValid = true;
                                          });
                                        },
                                        cursor: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              width: 20,
                                              height: 1,
                                              color: Color(
                                                CustomColors.GREEN_BUTTON,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Color(
                                              CustomColors.GREEN_BUTTON,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.phone_android,
                                              size: 18,
                                              color: Color(
                                                CustomColors.GREEN_BUTTON,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller:
                                                mobileNumberInputController,
                                            maxLength: 10,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                CustomColors.PURPLE_DARK,
                                              ),
                                            ),
                                            onChanged: (text) {
                                              if (text.length == 10) {
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              counterText: '',
                                              hintText: 'Enter mobile number',
                                              hintStyle: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          if (!isVisibleOtpTextField) ...[
                            SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: Checkbox(
                                      value: isWhatsAppAvailable,
                                      onChanged: (value) {
                                        setState(() {
                                          isWhatsAppAvailable = value!;
                                        });
                                      },
                                      activeColor: Color(
                                        CustomColors.GREEN_BUTTON,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Is this same number in whatsApp',
                                      style: TextStyle(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(height: 16),
                          if (isLoading)
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(CustomColors.GREEN_BUTTON),
                                ),
                                strokeWidth: 3,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () {
                                !isVisibleOtpTextField
                                    ? sendOtp(mobileNumberInputController.text)
                                    : verifyOtp(
                                        mobileNumberInputController.text,
                                        pinController.text,
                                      );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(CustomColors.GREEN_BUTTON),
                                      Color(
                                        CustomColors.GREEN_BUTTON,
                                      ).withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(
                                        CustomColors.GREEN_BUTTON,
                                      ).withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    isVisibleOtpTextField ? 'Verify' : 'Send',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (isVisibleOtpTextField) ...[
                            SizedBox(height: 12),
                            GestureDetector(
                              onTap: _canResend
                                  ? () {
                                      sendOtp(mobileNumberInputController.text);
                                    }
                                  : null,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Text(
                                  _canResend
                                      ? 'Resend OTP'
                                      : 'Resend OTP in ${_resendCountdown}s',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _canResend
                                        ? Color(CustomColors.GREEN_BUTTON)
                                        : Colors.grey[500],
                                    fontWeight: FontWeight.w600,
                                    decoration: _canResend
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 40), // Increased bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendOtp(String mobileNo) async {
    print('inside click: ' + mobileNo);

    if (mobileNo.length != 10) {
      CommonUtil().showToast(Constants.INVALID_PHONE_NUMBER);
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      final SendOtpResponse sendOtpResponse = await apiService.getOtp(
        SendOtpRequest(mobileNo, isWhatsAppAvailable),
      );
      print(sendOtpResponse.message);
      if (sendOtpResponse.message == 'OTP Sent Successfully.') {
        print(sendOtpResponse.message);
        setState(() {
          isVisibleOtpTextField = true;
        });
        _startResendTimer();
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

    if (otp.length != 4) {
      setState(() {
        isOtpValid = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      final VerifyOtpResponse response = await apiService.verifyOtp(
        VerifyOtpRequest(mobileNo, otp),
      );
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
          Constants.REFRESH_TOKEN,
          response.refreshToken!,
        );

        if (defaultVehicle == "") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PostLoginScreen()),
          );
        } else {
          final jsonDecoded = jsonDecode(defaultVehicle);
          String defaultVehicleNo = jsonDecoded['vehicleNo'];
          String defaultVehicleType = jsonDecoded['vehicleType'];
          String defaultVehicleID = jsonDecoded['vehicleID'];

          print(
            'number-->' +
                defaultVehicleNo +
                " type-->" +
                defaultVehicleType +
                " id-->" +
                defaultVehicleID,
          );

          sharedPreferences.setString(Constants.VEHICLE_ID, defaultVehicleID);
          sharedPreferences.setString(Constants.VEHICLE_NO, defaultVehicleNo);
          sharedPreferences.setString(
            Constants.VEHICLE_TYPE,
            defaultVehicleType,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(index: 0, path: '/'),
            ),
          );
        }
      } else {
        CommonUtil().showToast(response.message!);
      }
      setState(() {
        isLoading = false;
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        String errorMessage = e.response?.data['message'];
        print("errorMessage---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
        setState(() {
          isOtpValid = false;
          isLoading = false;
        });
      } else {
        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }

      print(e.toString());
    }
  }
}
