import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:parkey_customer/UIComponents/back_top_title.dart';
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
    // TODO: implement initState
    super.initState();
    getVehicleHistory();
  }

  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        print('onwillpop');
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
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
                    // Navigator.pop(context);
                  },
                  icon: Icon(
                    Iconsax.arrow_left_2,
                    color: Colors.white,
                  ))),
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Add Vehicle',
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
              child: ListView(
            children: [
              Stack(
                children: [
                  // Column(
                  //   children: [
                  //     ClipPath(
                  //       clipper: LoginDoneClipper1(),
                  //       child: Container(
                  //         height: 150,
                  //         width: MediaQuery.of(context).size.width,
                  //         decoration: BoxDecoration(
                  //             gradient: LinearGradient(
                  //           begin: Alignment.topLeft,
                  //           end: Alignment.bottomCenter,
                  //           colors: [
                  //             Color(CustomColors.PURPLE_LIGHT),
                  //             Color(CustomColors.PURPLE_DARK).withOpacity(0.5)
                  //           ],
                  //         )),
                  //       ),
                  //     ),
                  //     ClipPath(
                  //       clipper: LoginScreenClipper2(),
                  //       child: Container(
                  //         height: MediaQuery.of(context).size.height - 150,
                  //         width: MediaQuery.of(context).size.width,
                  //         decoration: BoxDecoration(
                  //             gradient: LinearGradient(
                  //           begin: Alignment.centerLeft,
                  //           end: Alignment.bottomCenter,
                  //           colors: [
                  //             Color(CustomColors.GREEN_LIGHT).withOpacity(0.1),
                  //             Color(CustomColors.GREEN_LIGHT).withOpacity(0.2)
                  //           ],
                  //         )),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.transparent,
                  //     borderRadius: BorderRadius.circular(20.0),
                  //   ),
                  //   child: BackdropFilter(
                  //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  //     child: Container(
                  //       color: Colors.transparent,
                  //     ),
                  //   ),
                  // ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'My Vehicles',
                            //  textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      isLoadingList
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    // border: Border.all(
                                    //     color: Color(CustomColors.GREEN_BUTTON),
                                    //     width: 2),
                                    borderRadius: BorderRadius.circular(20)),
                                height: 270,
                                width: widthParent * 0.9,
                                child: errorMessage != ""
                                    ? Center(
                                        child: Container(
                                          child: Text(errorMessage),
                                        ),
                                      )
                                    : SizedBox(
                                        child: Transform.scale(
                                          scale: 0.2,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(CustomColors
                                                        .GREEN_BUTTON)),
                                            strokeWidth: 25,
                                          ),
                                        ),
                                      ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  // Disable scrolling
                                  shrinkWrap: true,
                                  // Adapt size to content
                                  itemCount: customerVehicleResponseList.length,
                                  itemBuilder: (context, index) {
                                    final item =
                                        customerVehicleResponseList[index];
                                    return HistoryItem(
                                        item.customerName ?? "",
                                        item.vehicleNo,
                                        item.vehicleType,
                                        null,
                                        null,
                                        null,
                                        null,
                                        true,
                                        getVehicleHistory,
                                        null);
                                  },
                                ),
                              ),
                            ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 500,
                          margin: EdgeInsets.only(top: 10, bottom: 5),
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            'Add vehicle',
                            //  textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(5, 4),
                                  blurRadius: 15.0,
                                  spreadRadius: 2),
                              // BoxShadow(
                              //     color: Colors.white,
                              //     offset: Offset(-5, -5),
                              //     blurRadius: 4,
                              //     spreadRadius: 2)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Container(
                              width: 305.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Form(
                                key: _vnumber,
                                child: TextFormField(
                                  inputFormatters: [
                                    UpperCaseTextFormatter(),
                                  ],
                                  controller: vehicleNumberInputController,
                                  decoration: InputDecoration(

                                      //  hintText: 'Gj041299',
                                      prefixIcon: Icon(
                                        Icons.pedal_bike_rounded,
                                        color: Color(CustomColors.GREEN_DARK),
                                        size: 25,
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                      labelText: 'Enter vehicle Number',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color(CustomColors.GREEN_DARK),
                                            width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color(CustomColors.GREEN_DARK),
                                            width: 1.5),
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter vehicle number';
                                    }
                                    final RegExp reg = RegExp(
                                        r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$');
                                    if (!reg.hasMatch(value)) {
                                      return 'Invalid format';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.car_repair,
                                      size: 30,
                                      color: Color(CustomColors.GREEN_DARK),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: 220,
                                      child: Expanded(
                                        child: DropdownButton<String>(
                                          icon: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(Icons
                                                .keyboard_arrow_down_outlined),
                                          ),
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
                                  ],
                                ),
                              ),
                            ),
                            isSaving
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
                                    width: 250,
                                    margin: EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _vnumber.currentState!.validate();
                                        addVehicle(
                                            vehicleNumberInputController.text,
                                            vehicleType!);
                                      },
                                      child: Container(
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 244, 241, 241),
                                              fontSize: 13),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(CustomColors.GREEN_DARK)
                                                .withOpacity(0.5),
                                        side: BorderSide(
                                          color: Color(CustomColors.GREEN_DARK),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                ],
              )
            ],
          )),
        ),
      ),
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
        final response = await apiService
            .addVehicle(AddVehicleRequest(userID!, vehicleNo, vehicleType));

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
          // String errorMessage = e.response?.data['message'];
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
