import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkey_customer/Clippers/edit_profile_clipper.dart';
import 'package:parkey_customer/models/update_customer_details_request.dart';
import 'package:parkey_customer/screens/login_screen.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
import '../screens/home_screen.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';

class ProfileFragment extends StatefulWidget {
  BuildContext context;
  ProfileFragment({required this.context,super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProfileDetails();
  }

  bool isEditable = false, isLoading = false;
  String customerName = "";
  String mobileNo = "";
  String gender = "";
  String primaryVehicle = "";
  String emailID = "";
  final TextEditingController genderInputController = TextEditingController();
  final TextEditingController emailIDInputController = TextEditingController();
  final TextEditingController primaryVehicleInputController =
      TextEditingController();
  final TextEditingController customerNameInputController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: ListView(
        children: [
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipPath(
                    clipper: LoginDoneClipper1(),
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
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    ClipPath(
                      clipper: EditProfileClipper(),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 18, bottom: 18),
                                child: Text(
                                  'Profile',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      border: Border.all(
                                          color:
                                              Color(CustomColors.GREEN_BUTTON),
                                          width: 5)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/images/avatar.png'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Color(
                                                  CustomColors.GREEN_BUTTON),
                                              width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/edit_profile.png'),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            Visibility(
                              visible: !isEditable,
                              child: Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  customerName,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !isEditable,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 40),
                                child: Text(
                                  '+91' + mobileNo,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !isEditable,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEditable = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50, top: 30),
                              child: Row(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/edit_profile_person.png')),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(widget.context).push(MaterialPageRoute(builder: (context) => HomeScreen(index: -1,path: '/AddVehicle',)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50, top: 20),
                              child: Row(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/edit_profile_car.png')),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      'Update Vehicle',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50, top: 20),
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'assets/images/edit_profile_bell.png')),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    'Notification',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50, top: 20),
                            child: Row(
                              children: [
                                Image(
                                    image: AssetImage(
                                        'assets/images/edit_profile_help.png')),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    'Help',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences sharedPrefernces = await SharedPreferences.getInstance();
                              sharedPrefernces.clear();
                              Navigator.pushReplacement(widget.context, MaterialPageRoute(builder: (context) => LoginScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50, top: 20),
                              child: Row(
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/images/edit_profile_logout.png')),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isEditable,
                child: Container(
                  margin: EdgeInsets.only(top: 270),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                'Name: ',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: customerNameInputController,
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Name',
                                    isCollapsed: true,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                'Gender: ',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: genderInputController,
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Gender',
                                    isCollapsed: true,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                'Email: ',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: emailIDInputController,
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Email',
                                    isCollapsed: true,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      isLoading
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
                              margin: EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  updateCustomerDetails();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 50, right: 50),
                                  child: Container(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color(CustomColors.GREEN_BUTTON),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0), // Set border radius
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Version 1.0245'),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  void fetchProfileDetails() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);
      setState(() {
        mobileNo = sharedPreferences.getString(Constants.MOBILE_NUMBER)!;
      });
      // print('userid--'+userID!);

      try {
        final response = await apiService.getCustomerDetails(userID!);

        setState(() {
          if (response.customerName != null) {
            customerName = response.customerName == null ? "" : response.customerName!;
            mobileNo = response.mobileNo == null ? "" : response.mobileNo!;
            gender = response.gender == null ? "" : response.gender!;
            primaryVehicle = response.primaryVehicle == null ? "" : response.primaryVehicle!;
            emailID = response.emailID == null ? "" : response.emailID!;
          }

          isEditable = false;
        });

        print(response.toString());

        print('response' + (response.customerName ?? ""));
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
       //   String errorMessage = e.response?.data['message'];
          print("errorMessage---" + "errorMessage.toString()");
          // CommonUtil().showToast(errorMessage);
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
      }
    } catch (e) {
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      print(e.toString());
    }
  }

  void updateCustomerDetails() async {
    try {
      if (genderInputController.text == '' ||
          emailIDInputController.text == '' ||
          !emailIDInputController.text.contains("@") ||
          customerNameInputController.text == '') {
        CommonUtil().showToast('Invalid Details');
      }

      setState(() {
        isLoading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);
      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      print('userid--' + userID!);

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.updateCustomerDetails(
            UpdateCustomerDetailsRequest(
                'CUSTOMER_APP',
                userID,
                genderInputController.text,
                emailIDInputController.text,
                '',
                customerNameInputController.text));

        if (response.message == Constants.MSG_DETAILS_UPDATE_SUCCESSFUL) {
          setState(() {
            isEditable = false;
            customerName = customerNameInputController.text;
          });
          sharedPreferences.setString(Constants.CUSTOMER_NAME, customerName);
          CommonUtil().showToast('Profile Updated Successfully');
        }

        setState(() {
          isLoading = false;
        });

        print('response' + response.message.toString());
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          print("errorMessage---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
      }
    } catch (e) {
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }
}
