import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:parkey_customer/Clippers/edit_profile_clipper.dart';
import 'package:parkey_customer/Fragment/edit_profile.dart';
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
import 'add_vehicle_fragment.dart';

class ProfileFragment extends StatefulWidget {
  BuildContext context;
  ProfileFragment({required this.context, super.key});

  @override
  State<ProfileFragment> createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  @override
  void initState() {
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
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                    Colors.grey[50]!,
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(CustomColors.PURPLE_DARK),
                        fontFamily: "Poppins-Bold",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? _buildLoadingState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            fetchProfileDetails();
                          },
                          color: Color(CustomColors.GREEN_BUTTON),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileCard(),
                                SizedBox(height: 16),
                                _buildAccountSettings(),
                                SizedBox(height: 24),
                                _buildLogoutButton(),
                                SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(CustomColors.GREEN_BUTTON),
                ),
                strokeWidth: 3.5,
              ),
            ),
          ),
          SizedBox(height: 28),
          Text(
            'Loading profile details...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait a moment',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(CustomColors.GREEN_BUTTON),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
                backgroundColor: Colors.transparent,
                radius: 40,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerName.isEmpty ? 'Welcome User' : customerName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(CustomColors.PURPLE_DARK),
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '+91 $mobileNo',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      fontFamily: "Poppins",
                    ),
                  ),
                  if (emailID.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        emailID,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  // SizedBox(height: 12),
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 16,
                  //       vertical: 8,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Color(
                  //         CustomColors.GREEN_BUTTON,
                  //       ).withOpacity(0.1),
                  //       borderRadius: BorderRadius.circular(20),
                  //       border: Border.all(
                  //         color: Color(
                  //           CustomColors.GREEN_BUTTON,
                  //         ).withOpacity(0.3),
                  //         width: 1,
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Update Image',
                  //       style: TextStyle(
                  //         color: Color(CustomColors.GREEN_BUTTON),
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //         fontFamily: "Poppins-Bold",
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Settings',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: "Poppins-Bold",
              ),
            ),
            SizedBox(height: 16),
            _buildSettingsTile(
              icon: Iconsax.user_cirlce_add,
              title: 'Edit Profile',
              subtitle: 'Change your name, email',
              onTap: () {
                setState(() {
                  isEditable = true;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfile(name: customerName, email: emailID),
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 12),
            _buildSettingsTile(
              icon: Iconsax.car,
              title: 'Update Vehicle',
              subtitle: 'Modify your vehicle details',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddVehicleFragment()),
                );
              },
            ),
            SizedBox(height: 12),
            _buildSettingsTile(
              icon: Iconsax.notification,
              title: 'Notification',
              subtitle: 'Manage your alert preferences',
              onTap: () {},
            ),
            SizedBox(height: 12),
            _buildSettingsTile(
              icon: Icons.help_center,
              title: 'Help',
              subtitle: 'Need help!',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(CustomColors.PURPLE_LIGHT).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(CustomColors.PURPLE_LIGHT).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Color(CustomColors.GREEN_BUTTON),
                  size: 22,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => setState(() {}),
        onTapUp: (_) => setState(() {}),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(1.0),
          child: Container(
            width: 250,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color.fromARGB(255, 232, 85, 75),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 232, 85, 75).withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences sharedPrefernces =
                    await SharedPreferences.getInstance();
                sharedPrefernces.clear();
                Navigator.pushReplacement(
                  widget.context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Log out',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 232, 82, 72),
                  fontFamily: "Poppins-Bold",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void fetchProfileDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

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

      try {
        final response = await apiService.getCustomerDetails(userID!);

        setState(() {
          if (response.customerName != null) {
            customerName = response.customerName == null
                ? ""
                : response.customerName!;
            mobileNo = response.mobileNo == null ? "" : response.mobileNo!;
            gender = response.gender == null ? "" : response.gender!;
            primaryVehicle = response.primaryVehicle == null
                ? ""
                : response.primaryVehicle!;
            emailID = response.emailID == null ? "" : response.emailID!;
          }

          sharedPreferences.setString(Constants.CUSTOMER_NAME, customerName);

          isEditable = false;
          isLoading = false;
        });

        print(response.toString());

        print('response' + (response.customerName ?? ""));
      } on DioException catch (e) {
        setState(() {
          isLoading = false;
        });
        if (e.response?.statusCode == 400) {
          print("errorMessage---" + "errorMessage.toString()");
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
            customerNameInputController.text,
          ),
        );

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
        setState(() {
          isLoading = false;
        });
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          print("errorMessage---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
        } else {
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
