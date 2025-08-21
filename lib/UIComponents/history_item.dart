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
import '../utils/time_formatter.dart';

class HistoryItem extends StatefulWidget {
  String name, vehicleNo, vehicleType;
  String? address, time, date, timer, parkingCharges;
  bool isFromAddVehicle;
  final VoidCallback getVehicleHistory;
  HistoryItem(
    this.name,
    this.vehicleNo,
    this.vehicleType,
    this.address,
    this.time,
    this.date,
    this.timer,
    this.isFromAddVehicle,
    this.getVehicleHistory,
    this.parkingCharges, {
    super.key,
  });

  @override
  State<HistoryItem> createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  bool isLoading = false;
  bool isLoadingDeletion = false;
  bool isDefaultSet = false;

  @override
  void initState() {
    super.initState();
    checkIfDefaultVehicleSet();
  }

  @override
  Widget build(BuildContext context) {
    bool isVisibleFullCard =
        widget.address != null && widget.address!.isNotEmpty;
    IconData vehicleIcon;
    Color vehicleColor;

    switch (widget.vehicleType) {
      case 'Car':
        vehicleIcon = Icons.directions_car;
        vehicleColor = Color(CustomColors.PURPLE_DARK);
        break;
      case 'Bike':
        vehicleIcon = Icons.motorcycle;
        vehicleColor = Color(CustomColors.GREEN_BUTTON);
        break;
      case 'Heavy Vehicle':
        vehicleIcon = Icons.local_shipping;
        vehicleColor = Color(CustomColors.PURPLE_DARK);
        break;
      default:
        vehicleIcon = Icons.directions_bike;
        vehicleColor = Color(CustomColors.PURPLE_DARK);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: vehicleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(vehicleIcon, color: vehicleColor, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.name.isNotEmpty)
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                            fontFamily: "Poppins",
                          ),
                        ),
                      if (widget.vehicleNo.isNotEmpty) ...[
                        SizedBox(height: 2),
                        Text(
                          widget.vehicleNo,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.vehicleType.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: vehicleColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.vehicleType,
                      style: TextStyle(
                        fontSize: 11,
                        color: vehicleColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
              ],
            ),
            if (widget.isFromAddVehicle) ...[
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isLoading
                      ? Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(CustomColors.GREEN_BUTTON),
                            ),
                            strokeWidth: 4,
                          ),
                        )
                      : isDefaultSet
                      ? SizedBox()
                      : OutlinedButton(
                          onPressed: () {
                            addVehicle(widget.vehicleNo, widget.vehicleType);
                          },
                          child: Text(
                            'Set Default',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(
                              CustomColors.GREEN_DARK,
                            ).withOpacity(0.7),
                            side: BorderSide(
                              color: Color(CustomColors.GREEN_DARK),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                  SizedBox(width: 8),
                  isLoadingDeletion
                      ? Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(CustomColors.GREEN_BUTTON),
                            ),
                            strokeWidth: 4,
                          ),
                        )
                      : OutlinedButton(
                          onPressed: () {
                            deleteVehicle(widget.vehicleNo);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Color(
                              CustomColors.GREEN_DARK,
                            ).withOpacity(0.7),
                            side: BorderSide(
                              color: Color(CustomColors.GREEN_DARK),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                ],
              ),
            ],
            if (isVisibleFullCard) ...[
              SizedBox(height: 16),
              if (widget.address != null && widget.address!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.place_rounded,
                        color: Colors.grey[500],
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.address!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700],
                            fontFamily: "Poppins",
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 12),
              Row(
                children: [
                  if (widget.timer != null && widget.timer!.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(
                            CustomColors.GREEN_BUTTON,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: Color(CustomColors.GREEN_BUTTON),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                formatDurationFromString(widget.timer!),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  fontFamily: "Poppins",
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.timer != null &&
                      widget.timer!.isNotEmpty &&
                      widget.date != null &&
                      widget.date!.isNotEmpty)
                    SizedBox(width: 8),
                  if (widget.date != null && widget.date!.isNotEmpty)
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Color(
                            CustomColors.PURPLE_DARK,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: Color(CustomColors.PURPLE_DARK),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                widget.date!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(CustomColors.PURPLE_DARK),
                                  fontFamily: "Poppins",
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.parkingCharges != null &&
                  widget.parkingCharges!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Color(CustomColors.GREEN_BUTTON),
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Charges: ${widget.parkingCharges}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(CustomColors.GREEN_BUTTON),
                              fontFamily: "Poppins",
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
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
        AddVehicleRequest(userID!, vehicleNo, vehicleType),
      );

      sharedPreferences.setString(Constants.VEHICLE_ID, response.vehicleID);
      sharedPreferences.setString(Constants.VEHICLE_NO, vehicleNo);
      sharedPreferences.setString(Constants.VEHICLE_TYPE, vehicleType);
      CommonUtil().showToast("Default Vehicle Changed");
    } on DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? "Error adding vehicle";
      print("errorMessage---$errorMessage");
      CommonUtil().showToast(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
  }

  void deleteVehicle(String vehicleNo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    String defaultVehicleNo =
        sharedPreferences.getString(Constants.VEHICLE_NO) ?? "";
    if (defaultVehicleNo == widget.vehicleNo) {
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
      if (message == "") {
        CommonUtil().showToast("Vehicle Deleted Successfully");
        widget.getVehicleHistory();
      } else {
        CommonUtil().showToast(message);
      }
    } on DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? "Error deleting vehicle";
      print("errorMessage---$errorMessage");
      CommonUtil().showToast(errorMessage);
    }
    setState(() {
      isLoadingDeletion = false;
    });
  }

  Future<void> checkIfDefaultVehicleSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? defaultVehicleID = prefs.getString(Constants.VEHICLE_ID);
    if (defaultVehicleID == widget.vehicleNo) {
      setState(() {
        isDefaultSet = true;
      });
    } else {
      setState(() {
        isDefaultSet = false;
      });
    }
  }
}
