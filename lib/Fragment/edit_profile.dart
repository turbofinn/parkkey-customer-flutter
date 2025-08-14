import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/colors/CustomColors.dart';
import 'package:parkey_customer/models/update_customer_details_request.dart';
import 'package:parkey_customer/services/api_service.dart';
import 'package:parkey_customer/utils/Constants.dart';
import 'package:parkey_customer/utils/auth_interceptor.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
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
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                ))),
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(CustomColors.PURPLE_DARK)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0.01),
              // child: Text(
              //   'Add new Vehicle',
              //   style: TextStyle(
              //       fontSize: 15, color: Colors.grey.withOpacity(0.9)),
              // ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(CustomColors.PURPLE_LIGHT).withOpacity(0.01),
          Color(CustomColors.PURPLE_DARK).withOpacity(0.2)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: screenWidth * 0.1),
            width: screenWidth * 1,
            // height: screenHeight * 0.55,
            //  color: Colors.red,
            child: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.87,
                  child: TextFormField(
                    controller: customerNameInputController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: Color(CustomColors.GREEN_DARK),
                          size: 25,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        labelText: 'Enter Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(CustomColors.GREEN_DARK), width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(CustomColors.GREEN_DARK),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  width: screenWidth * 0.87,
                  child: TextFormField(
                    controller: genderInputController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.female_sharp,
                          color: Color(CustomColors.GREEN_DARK),
                          size: 25,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        labelText: 'Enter Gender',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(CustomColors.GREEN_DARK), width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(CustomColors.GREEN_DARK),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  width: screenWidth * 0.87,
                  child: TextFormField(
                    controller: emailIDInputController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color(CustomColors.GREEN_DARK),
                          size: 25,
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        labelText: 'Enter Email address',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(CustomColors.GREEN_DARK), width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(CustomColors.GREEN_DARK),
                              width: 1.5),
                          borderRadius: BorderRadius.circular(15),
                        )),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  width: screenWidth * 0.6,
                  margin: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      updateCustomerDetails();
                    },
                    child: Container(
                      child: Text(
                        'Save',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 244, 241, 241),
                            fontSize: 15),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(CustomColors.GREEN_DARK).withOpacity(0.5),
                      side: BorderSide(
                        color: Color(CustomColors.GREEN_DARK),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
