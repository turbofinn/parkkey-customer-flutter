import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:parkey_customer/Fragment/ProfileFragment.dart';
import 'package:parkey_customer/Fragment/history.dart';
import 'package:parkey_customer/UIComponents/back_top_title.dart';
import 'package:parkey_customer/UIComponents/vehicle_card.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_done_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../UIComponents/history_item.dart';
import '../colors/CustomColors.dart';
import '../models/add_vehicle_request.dart';
import '../models/customer_vehicle_details_response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/upper_text_formatter.dart';

class AddVehicleFragment extends StatefulWidget {
  const AddVehicleFragment({super.key});

  @override
  State<AddVehicleFragment> createState() => _AddVehicleFragmentState();
}

class _AddVehicleFragmentState extends State<AddVehicleFragment> {
  final _vnumber = GlobalKey<FormState>();
  final TextEditingController vehicleNumberInputController =
      TextEditingController();
  String? vehicleType;
  final List<String> _items = ['Car', 'Bike', 'Heavy Vehicle', 'Bicycle'];
  bool isLoadingList = true;
  List<CustomerVehicleResponse> customerVehicleResponseList = [];
  bool isSaving = false;
  String errorMessage = "Some Error Occurred";

  @override
  void initState() {
    super.initState();
    getVehicleHistory();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        print('onwillpop');
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileFragment(context: context),
                            ),
                          );
                        },
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
                            'Add Vehicle',
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Vehicles',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),

                          isLoadingList
                              ? Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: errorMessage != ""
                                        ? Text(
                                            errorMessage,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          )
                                        : SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Color(
                                                      CustomColors.GREEN_BUTTON,
                                                    ),
                                                  ),
                                              strokeWidth: 2.5,
                                            ),
                                          ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(
                                                CustomColors.GREEN_DARK,
                                              ).withOpacity(0.1),
                                              Color(
                                                CustomColors.GREEN_DARK,
                                              ).withOpacity(0.05),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  CustomColors.GREEN_DARK,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.garage,
                                                color: Color(
                                                  CustomColors.GREEN_DARK,
                                                ),
                                                size: 18,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Registered Vehicles',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(
                                                  CustomColors.GREEN_DARK,
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  CustomColors.GREEN_DARK,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '${customerVehicleResponseList.length}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.35,
                                        ),
                                        child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(16),
                                          itemCount: customerVehicleResponseList
                                              .length,
                                          itemBuilder: (context, index) {
                                            final item =
                                                customerVehicleResponseList[index];
                                            return VehicleCard(
                                              customerName:
                                                  item.customerName ?? "",
                                              vehicleNo: item.vehicleNo,
                                              vehicleType: item.vehicleType,
                                              isVehicleCard: true,
                                              refreshCallback:
                                                  getVehicleHistory,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                          SizedBox(height: 32),

                          Text(
                            'Add New Vehicle',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
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
                                      Icons.directions_car,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(height: 24),

                                  _buildVehicleNumberField(),
                                  SizedBox(height: 20),

                                  _buildVehicleTypeDropdown(),
                                  SizedBox(height: 32),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: isSaving
                                          ? null
                                          : () {
                                              _vnumber.currentState!.validate();
                                              addVehicle(
                                                vehicleNumberInputController
                                                    .text,
                                                vehicleType!,
                                              );
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(
                                          CustomColors.GREEN_DARK,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                      ),
                                      child: isSaving
                                          ? SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Text(
                                              'Add Vehicle',
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

                          SizedBox(height: 40),
                        ],
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

  Widget _buildVehicleNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Number',
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
          child: Form(
            key: _vnumber,
            child: TextFormField(
              inputFormatters: [UpperCaseTextFormatter()],
              controller: vehicleNumberInputController,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Enter vehicle number',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  letterSpacing: 0,
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.only(left: 16, right: 12),
                  child: Icon(
                    Icons.directions_car_outlined,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter vehicle number';
                }
                final RegExp reg = RegExp(
                  r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$',
                );
                if (!reg.hasMatch(value)) {
                  return 'Invalid format';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
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
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(CustomColors.GREEN_DARK).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  color: Color(CustomColors.GREEN_DARK),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: vehicleType,
                    hint: Text(
                      'Select vehicle type',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(CustomColors.GREEN_DARK),
                    ),
                    underline: SizedBox(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  void addVehicle(String vehicleNo, String vehicleType) async {
    try {
      if (vehicleType == "") {
        Fluttertoast.showToast(
          msg: 'Select Vehicle Type',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      setState(() {
        isSaving = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.addVehicle(
          AddVehicleRequest(userID!, vehicleNo, vehicleType),
        );

        sharedPreferences.setString(Constants.VEHICLE_ID, response.vehicleID);
        sharedPreferences.setString(Constants.VEHICLE_TYPE, vehicleType);
        sharedPreferences.setString(Constants.VEHICLE_NO, vehicleNo);
        CommonUtil().showToast("Vehicle Added Successfully");
        getVehicleHistory();
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          print("errorMessage3---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
          setState(() {
            isSaving = false;
          });
        } else {
          print("errorMessage4---" + errorMessage.toString());
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
      }
      setState(() {
        vehicleNumberInputController.clear();
        isSaving = false;
      });
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      print("errorMessage5---" + errorMessage.toString());
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  void getVehicleHistory() async {
    print('avf');
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.getCustomerVehicleDetails(userID!);

        Set<String> uniqueVehicle = {};
        List<CustomerVehicleResponse> tempList = [];

        int len = response.customerVehicleList.length;
        for (int i = 0; i < len; i++) {
          String vno = response.customerVehicleList.elementAt(i).vehicleNo;
          if (!uniqueVehicle.contains(vno)) {
            tempList.add(response.customerVehicleList.elementAt(i));
          }
          uniqueVehicle.add(vno);
        }

        if (tempList.isEmpty) {
          setState(() {
            errorMessage = Constants.EMPTY_VEHICLE_LIST;
          });
          return;
        }

        setState(() {
          customerVehicleResponseList = tempList;
          isLoadingList = false;
        });

        print("getVehicleH" + response.toString());
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          print("errorMessage1---" + errorMessage.toString());
          CommonUtil().showToast(errorMessage);
          setState(() {
            this.errorMessage = errorMessage;
            isLoadingList = false;
          });
        } else {
          print("errorMessage2---" + errorMessage.toString());
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
      });
      print("errorMessage6---" + e.toString());
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }
}
