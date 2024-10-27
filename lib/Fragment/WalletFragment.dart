import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/UIComponents/back_top_title.dart';
import 'package:parkey_customer/UIComponents/custom_alert_dialog.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:pinput/pinput.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';

class WalletFragment extends StatefulWidget {
  const WalletFragment({super.key});

  @override
  State<WalletFragment> createState() => _WalletFragmentState();
}

class _WalletFragmentState extends State<WalletFragment> {
  Razorpay razorpay = Razorpay();
  double amount = 0;
  final TextEditingController amountInputController = TextEditingController();
  double walletBalance = 0;
  bool showPaymentSuccessDialog = false;
  bool isLoading = false;
  String ?customerName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchWalletBalance();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
    double heightParent = MediaQuery.of(context).size.height;

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    return SafeArea(
        child: Material(
      child: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: widthParent,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        color: Color(0xff1F6857).withOpacity(0.8)),
                  ),
                  ClipPath(
                    clipper: LoginScreenClipper2(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
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
              Stack(
                children: [
                  ClipPath(
                    clipper: LoginDoneClipper1(),
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: Color(0xff1F6857)),
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black
                            .withOpacity(0.5), // Adjust opacity as needed
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  BackTopTitle('',
                      Colors.white, 'My Wallet', ''),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          'Hello,',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          customerName ?? "NA",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            // Adjust the shadow color and opacity
                            //blurRadius: 7, // Adjust the blur radius of the shadow
                            offset: Offset(0, 3), // Offset of the shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 18),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Your Wallet Balance',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            isLoading ? Container(
                              margin: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(CustomColors.GREEN_BUTTON)),
                                    strokeWidth: 5,
                                  ),
                                ),
                              ),
                            ) : Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '₹ $walletBalance /-',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recharge Your Wallet:',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 16, top: 14, right: 16, bottom: 14),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              amountInputController.setText('100');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 22, right: 22, top: 4, bottom: 4),
                                child: Text(
                                  '100',
                                  style: TextStyle(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              amountInputController.setText('200');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 22, right: 22, top: 4, bottom: 4),
                                child: Text(
                                  '200',
                                  style: TextStyle(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              amountInputController.setText('500');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 22, right: 22, top: 4, bottom: 4),
                                child: Text(
                                  '500',
                                  style: TextStyle(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 6),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Amount:',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Container(
                      width: widthParent,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: Color(CustomColors.GREEN_BUTTON),
                              width: 1.5)),
                      child: TextField(
                        controller: amountInputController,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 10),
                        decoration: InputDecoration(
                            hintText: 'Enter Amount You Want To Add On Wallet',
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(10),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 16, right: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          startPayment();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            child: Text(
                              'Add Money',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(CustomColors.GREEN_BUTTON),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                  visible: showPaymentSuccessDialog,
                  child: showPaymentSuccessDialogFunction())
            ],
          ),
        ],
      ),
    ));
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {

    walletBalance += amount;
    amountInputController.clear();
    amount = 0;
    setState(() {
      showPaymentSuccessDialog = true;
    });

  }

  _handlePaymentError(PaymentFailureResponse response) {

    print("Error-->" + response.error.toString());

    CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);

  }

  void startPayment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String mobileNo = sharedPreferences.getString(Constants.MOBILE_NUMBER)!;

    if(amountInputController.text == "" || amountInputController.text == null){
      CommonUtil().showToast('Please Enter Amount');
    }

    amount = double.parse(amountInputController.text);

    var options = {
      'key': 'rzp_live_MhFMxh3USLjA7x',
      'amount': amount * 100,
      'name': 'Parkey India',
      'description': 'Add Money To Wallet',
      'prefill': {
        'contact': mobileNo,
      },
      'notes' : {
        'userID' : sharedPreferences.getString(Constants.USER_ID)
      },
      'theme': {
        'color': '#458274' // Change the color as needed
      }
    };

    print('options-->' + jsonEncode(options));

    razorpay.open(options);
  }

  Widget showPaymentSuccessDialogFunction(){
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
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
            Container(
              margin: EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    //blurRadius: 7, // Adjust the blur radius of the shadow
                    offset: Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Padding(
                            padding: EdgeInsets.all(50),
                            child: Image(
                              image: AssetImage('assets/images/tick.png'),
                            )),
                      ),
                      Positioned(
                          top: 40,
                          left: 50,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 130,
                          left: 40,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 170,
                          left: 100,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 170,
                          right: 70,
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 130,
                          right: 50,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 33,
                          right: 50,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                    ],
                  ),
                  Container(
                    child: Text(
                      'Successfully Added Balance',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(CustomColors.GREEN_BUTTON)),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 16, right: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          updatePayment();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            child: Text(
                              'Continue',
                              style:
                              TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(CustomColors.GREEN_BUTTON),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius
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
      ),
    );
  }

  void updatePayment() {
    setState(() {
      showPaymentSuccessDialog = false;
    });
  }

  void fetchWalletBalance() async{
    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME) ?? "";

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);
    // print('userid--'+userID!);

    try {
      final response = await apiService.getWalletDetails(sharedPreferences.getString(Constants.USER_ID)!);

      if(response != null){
        setState(() {
          this.walletBalance = response.walletAmount;
          isLoading = false;
        });
      }

    }on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        String errorMessage = e.response?.data['message'];
        print("errorMessage---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
      } else {
        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }
      setState(() {
        isLoading = false;
      });
    }


  }
}
