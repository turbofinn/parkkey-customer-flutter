import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
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
  ProfileFragment({required this.context, super.key});

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
    double Screenheight = MediaQuery.of(context).size.height;
    double Screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () {},
      //       icon: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Icon(
      //           Iconsax.arrow_left,
      //           size: 31,
      //           weight: 20.0,
      //         ),
      //       )),
      //   title: Text(
      //     'Profile',
      //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      //   ),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              ClipPath(
                clipper: TopCurveClipper(),
                child: Container(
                  height: Screenheight * 0.3, // Only top part is curved
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                        Color(CustomColors.PURPLE_LIGHT),
                        Color(CustomColors.PURPLE_DARK),
                      ])),
                  // color: Color(
                  //     CustomColors.PURPLE_LIGHT), // Purple color like the image
                ),
              ),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color(CustomColors.GREEN_DARK), width: 3)),
                    margin: EdgeInsets.only(top: Screenheight * 0.03),
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                      backgroundColor: Colors.transparent,
                      radius: 50,
                    ),
                  ),
                  Text(
                    '+91' + mobileNo,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {},
                        child: Text('Update Image',
                            style: TextStyle(
                                color: Color(CustomColors.GREEN_DARK),
                                fontSize: 16))),
                  ),
                  SizedBox(
                    height: Screenheight * 0.05,
                  ),
                  Divider(
                    indent: 19,
                    endIndent: 19,
                    thickness: 2,
                    height: Screenheight * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Account settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: Screenheight * 0.02,
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          )
                        ]),
                    child: Column(
                      children: [
                        ListTile(
                          tileColor:
                              Color(CustomColors.PURPLE_LIGHT).withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            Iconsax.user_cirlce_add,
                            size: 25,
                            weight: 200,
                            color: Color(CustomColors.GREEN_DARK),
                          ),
                          title: Text('Edit Profile',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                // color: Color(CustomColors.GREEN_DARK)
                              )),
                          subtitle: Text('Change your name,mail'),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  isEditable = true;
                                });
                              },
                              icon: Icon(Icons.arrow_forward_ios)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          tileColor:
                              Color(CustomColors.PURPLE_LIGHT).withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            Iconsax.car,
                            size: 25,
                            weight: 200,
                            color: Color(CustomColors.GREEN_DARK),
                          ),
                          title: Text('Update Vehicle',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                // color: Color(CustomColors.GREEN_DARK)
                              )),
                          subtitle: Text('Modify your vehicle details'),
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.of(widget.context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                              index: -1,
                                              path: '/AddVehicle',
                                            )));
                              },
                              icon: Icon(Icons.arrow_forward_ios)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          tileColor:
                              Color(CustomColors.PURPLE_LIGHT).withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            Iconsax.notification,
                            size: 25,
                            weight: 200,
                            color: Color(CustomColors.GREEN_DARK),
                          ),
                          title: Text('Notification',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                // color: Color(CustomColors.GREEN_DARK)
                              )),
                          subtitle: Text('Manage your alert preferences'),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          tileColor:
                              Color(CustomColors.PURPLE_LIGHT).withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          leading: Icon(
                            Icons.help_center,
                            size: 25,
                            weight: 200,
                            color: Color(CustomColors.GREEN_DARK),
                          ),
                          title: Text('Help',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                // color: Color(CustomColors.GREEN_DARK)
                              )),
                          subtitle: Text('Need help!'),
                          trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.arrow_forward_ios)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 300, // set your desired width
                    height: 50, // set your desired height
                    child: OutlinedButton(
                      onPressed: () async {
                        SharedPreferences sharedPrefernces =
                            await SharedPreferences.getInstance();
                        sharedPrefernces.clear();
                        Navigator.pushReplacement(
                            widget.context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color.fromARGB(255, 232, 85, 75),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 17,
                          // fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 232, 82, 72),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
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
            customerName =
                response.customerName == null ? "" : response.customerName!;
            mobileNo = response.mobileNo == null ? "" : response.mobileNo!;
            gender = response.gender == null ? "" : response.gender!;
            primaryVehicle =
                response.primaryVehicle == null ? "" : response.primaryVehicle!;
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

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
