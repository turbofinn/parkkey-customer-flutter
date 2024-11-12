import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/Fragment/add_vehicle_fragment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/CustomColors.dart';
import '../models/add_vehicle_request.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';
class HistoryItem extends StatefulWidget {
  String name,vehicleNo,vehicleType;
  String? address,time,date,timer,parkingCharges;
  bool isFromAddVehicle;
  final VoidCallback getVehicleHistory;
   HistoryItem(this.name,this.vehicleNo,this.vehicleType,this.address,this.time,this.date,this.timer,this.isFromAddVehicle,this.getVehicleHistory, this.parkingCharges,{super.key});

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  bool isLoading = false;
  bool isLoadingDeletion = false;

  @override
  Widget build(BuildContext context) {
    String assetImage = 'assets/images/';
    bool isVisibleFullCard = false;
    bool isFromAddVehicle = widget.isFromAddVehicle;

    if(widget.address != null){
      isVisibleFullCard = true;
    }

    if(widget.vehicleType == 'Car'){
      assetImage += 'car.png';
    }
    else if(widget.vehicleType == 'Bike'){
      assetImage += 'bike.png';
    }
    else if(widget.vehicleType == 'Heavy Vehicle'){
      assetImage += 'truck.png';
    }
    else{
      assetImage += 'cycle.png';
    }
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 8,left: 12,right: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                // Adjust the shadow color and opacity
                blurRadius: 7, // Adjust the blur radius of the shadow
                //offset: Offset(2, 2,), // Offset of the shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: Image(
                        height: 50,
                        width: 50,
                        image: AssetImage(assetImage),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            widget.vehicleNo,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text('Vehicle Type: ' + widget.vehicleType,style: TextStyle(fontSize: 12),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          isFromAddVehicle ? Visibility(
                              visible: isFromAddVehicle,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isLoading ? Container(
                                      margin: EdgeInsets.only(left: 30),
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(CustomColors.GREEN_BUTTON)),
                                        strokeWidth: 4,
                                      ),
                                    ) : Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          addVehicle(widget.vehicleNo,
                                              widget.vehicleType);
                                        },
                                        child: Container(
                                          child: Text(
                                            'Make Default',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 10),
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
                                    ),
                                  ],
                                ),
                              ))
                              : Container(),
                          isFromAddVehicle ? Visibility(
                              visible: isFromAddVehicle,
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    isLoadingDeletion ? Container(
                                      margin: EdgeInsets.only(top: 50),
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Color(CustomColors.GREEN_BUTTON)),
                                        strokeWidth: 4,
                                      ),
                                    ) : Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          deleteVehicle(widget.vehicleNo);
                                        },
                                        child: Container(
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 10),
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
                                    ),
                                  ],
                                ),
                              ))
                              : Container(),
                        ],)
                      ],
                    ),

                  ],
                ),
                isVisibleFullCard ? Visibility(
                  visible: isVisibleFullCard,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text('Parked At: '+widget.address!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: widget.parkingCharges != null ? Text('Parking Charges: '+(widget.parkingCharges ?? ""),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),) : Container(),
                        ),
                      ),
                    ],
                  ),
                ) : Container(),
                isVisibleFullCard ? Visibility(
                  visible: isVisibleFullCard,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(widget.date!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),),
                          ),
                          Container(
                            child: Text('Time: '+widget.time!,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),),
                          ),
                        ],
                      )
                  ),
                ) : Container(),
                isVisibleFullCard ? Visibility(
                  visible: isVisibleFullCard,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text('Parking Timer: '+widget.timer!,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black.withOpacity(0.5)),),
                    ),
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      )
    );
  }
  void addVehicle(String vehicleNo, String vehicleType) async {

    setState(() {
      isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String? userID = sharedPreferences.getString(Constants.USER_ID);

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);

    try {
      final response = await apiService.addVehicle(
          AddVehicleRequest(userID!, vehicleNo,vehicleType));

      sharedPreferences.setString(Constants.VEHICLE_ID, response.vehicleID);
      sharedPreferences.setString(Constants.VEHICLE_NO, vehicleNo);
      sharedPreferences.setString(Constants.VEHICLE_TYPE, vehicleType);
      CommonUtil().showToast("Default Vehicle Changed");

    } on DioException catch (e) {
      String errorMessage = e.response?.data['message'];
      print("errorMessage---" + errorMessage.toString());
      CommonUtil().showToast(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteVehicle(String vehicleNo) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String defaultVehicleNo = sharedPreferences.getString(Constants.VEHICLE_NO) ?? "";
    if(defaultVehicleNo == widget.vehicleNo){
      CommonUtil().showToast("Cannot Delete Default Vehicle");
      return;
    }
    setState(() {
      isLoadingDeletion = true;
    });

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));

    final ApiService apiService = ApiService(dio);

    try {
      final response = await apiService.deleteVehicle(vehicleNo);
      String message = response.message ?? "";
      if(message == ""){
        CommonUtil().showToast("Vehicle Deleted Successfully");
        widget.getVehicleHistory();
      }else{
        CommonUtil().showToast(message);
      }

    } on DioException catch (e) {
      String errorMessage = e.response?.data['message'];
      print("errorMessage---" + errorMessage.toString());
      CommonUtil().showToast(errorMessage);
    }
    setState(() {
      isLoadingDeletion = false;
    });
  }

}
