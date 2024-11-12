import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final TextEditingController vehicleNumberInputController =
      TextEditingController();
  String? vehicleType;
  final List<String> _items = ['Car', 'Bike', 'Heavy Vehicle', 'Bicycle'];
  bool isLoadingList = true;
  List<CustomerVehicleResponse> customerVehicleResponseList = [];
  bool isSaving = false;
  String errorMessage="Some Error Occurred";

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
      child: SafeArea(
          child: Material(
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
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
                Column(
                  children: [
                    BackTopTitle('assets/images/arrow_back.png', Colors.black,
                        'Add Vehicle', ''),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      child: Text('My Vehicles'),
                    ),
                    isLoadingList
                        ?  Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              height: 270,
                              width: widthParent * 0.9,
                              child: errorMessage != "" ? Center(child: Container(child: Text(errorMessage),),) : SizedBox(
                                child: Transform.scale(
                                  scale: 0.2,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(CustomColors.GREEN_BUTTON)),
                                    strokeWidth: 25,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
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
                                    true,getVehicleHistory, null);
                                  },
                                ),
                              ),
                            ),
                          ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 30),
                      child: Text('Add New Vehicle'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 32),
                            child: Text(
                              'Vehicle No: ',
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
                                controller: vehicleNumberInputController,
                                maxLength: 10,
                                inputFormatters: [UpperCaseTextFormatter()],
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Vehicle Number',
                                  isCollapsed: true,
                                    counterText: ''
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Text(
                              'Vehicle Type: ',
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
                              padding: const EdgeInsets.only(left: 12),
                              child: DropdownButton<String>(
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
                          )
                        ],
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
                        :
                    Container(
                            margin: EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                addVehicle(vehicleNumberInputController.text,
                                    vehicleType!);
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
                )
              ],
            )
          ],
        ),
      )),
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
    try{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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

      if(tempList.isEmpty){
        setState(() {
          errorMessage = Constants.EMPTY_VEHICLE_LIST;
        });
        return;
      }

      setState(() {
        customerVehicleResponseList = tempList;
        isLoadingList = false;
      });

      print("getVehicleH"+response.toString());

    } on DioException catch (e) {
      if(e.response?.statusCode == 400){
       // String errorMessage = e.response?.data['message'];
        print("errorMessage1---" + errorMessage.toString());
        CommonUtil().showToast(errorMessage);
        setState(() {
          this.errorMessage = errorMessage;
          isLoadingList = false;
        });
      }
      else{
        print("errorMessage2---" + errorMessage.toString());

        CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      }
    }
    }catch(e){

      setState(() {
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
      });
      print("errorMessage6---" + e.toString());


      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }
}
