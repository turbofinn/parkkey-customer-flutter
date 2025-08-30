// ignore_for_file: library_private_types_in_public_api

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
  final String name;
  final String email;
  const EditProfile({super.key, required this.name, required this.email});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isEditable = false, isLoading = false;
  String customerName = "";
  String mobileNo = "";
  String gender = 'Male';
  String primaryVehicle = "";
  String emailID = "";
  final TextEditingController emailIDInputController = TextEditingController();
  final TextEditingController primaryVehicleInputController =
      TextEditingController();
  final TextEditingController customerNameInputController =
      TextEditingController();
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    emailIDInputController.text = widget.email;
    customerNameInputController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Poppins-SemiBold",
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 36),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 400),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(28),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(CustomColors.GREEN_DARK),
                                      Color(
                                        CustomColors.GREEN_DARK,
                                      ).withOpacity(0.8),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              SizedBox(height: 24),
                              _buildInputField(
                                controller: customerNameInputController,
                                label: 'Full Name',
                                icon: Icons.person_outline,
                                hint: 'Enter your full name',
                              ),
                              SizedBox(height: 20),
                              _buildGenderDropdown(),
                              SizedBox(height: 20),
                              _buildInputField(
                                controller: emailIDInputController,
                                label: 'Email Address',
                                icon: Icons.email_outlined,
                                hint: 'Enter email address',
                              ),
                              SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          updateCustomerDetails();
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(
                                      CustomColors.GREEN_DARK,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),

            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Container(
                margin: EdgeInsets.only(left: 16, right: 12),
                child: Icon(
                  icon,
                  color: Color(CustomColors.GREEN_DARK),
                  size: 20,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 48),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(CustomColors.GREEN_DARK).withOpacity(0.2),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(CustomColors.GREEN_DARK).withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(CustomColors.GREEN_DARK),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: gender,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Select gender',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Container(
                margin: EdgeInsets.only(left: 16, right: 12),
                child: Icon(
                  Icons.wc_outlined,
                  color: Color(CustomColors.GREEN_DARK),
                  size: 20,
                ),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 48),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(CustomColors.GREEN_DARK).withOpacity(0.2),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(CustomColors.GREEN_DARK).withOpacity(0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(CustomColors.GREEN_DARK),
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: _genderOptions.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  gender = newValue;
                });
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a gender';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  void updateCustomerDetails() async {
    try {
      if (customerNameInputController.text.isEmpty ||
          gender == null ||
          emailIDInputController.text.isEmpty ||
          !emailIDInputController.text.contains("@gmail.com")) {
        CommonUtil().showToast('Invalid Details');
        return;
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
            gender!,
            emailIDInputController.text,
            '',
            customerNameInputController.text,
          ),
        );

        if (response.message == Constants.MSG_DETAILS_UPDATE_SUCCESSFUL) {
          setState(() {
            isEditable = false;
            customerName = customerNameInputController.text;
            emailID = emailIDInputController.text;
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
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      setState(() {
        isLoading = false;
      });
    }
  }
}
