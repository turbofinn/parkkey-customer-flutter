import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:parkey_customer/Fragment/add_vehicle_fragment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/CustomColors.dart';
import '../models/add_vehicle_request.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class History extends StatefulWidget {
  String name, vehicleNo, vehicleType;
  String? address, time, date, timer, parkingCharges;
  bool isFromAddVehicle;
  final VoidCallback getVehicleHistory;
  final Function(String)? onDefaultVehicleChanged;
  bool isDefault;
  History(
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
    this.isDefault = false,
    this.onDefaultVehicleChanged,
    super.key,
  });

  @override
  State<History> createState() => _History();
}

class _History extends State<History> {
  bool isLoading = false;
  bool isLoadingDeletion = false;

  @override
  Widget build(BuildContext context) {
    String assetImage = 'assets/Icons/';
    bool isVisibleFullCard = false;
    bool isFromAddVehicle = widget.isFromAddVehicle;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (widget.address != null) {
      isVisibleFullCard = true;
    }

    if (widget.vehicleType == 'Car') {
      assetImage += 'car.png';
    } else if (widget.vehicleType == 'Bike') {
      assetImage += 'bycicle.png';
    } else if (widget.vehicleType == 'Heavy Vehicle') {
      assetImage += 'truck.png';
    } else {
      assetImage += 'cycle.png';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                        Color(CustomColors.PURPLE_LIGHT).withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image(
                      height: 46,
                      width: 46,
                      image: AssetImage(assetImage),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.vehicleNo,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Color(CustomColors.PURPLE_DARK),
                                fontFamily: "Poppins-Bold",
                              ),
                            ),
                          ),
                          if (widget.isDefault)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(
                                  CustomColors.GREEN_BUTTON,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(
                                    CustomColors.GREEN_BUTTON,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  fontFamily: "Poppins-Bold",
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(CustomColors.PURPLE_DARK),
                              Color(CustomColors.PURPLE_DARK).withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(
                                CustomColors.PURPLE_DARK,
                              ).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.vehicleType,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: "Poppins-Bold",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isFromAddVehicle) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  if (!widget.isDefault) ...[
                    Expanded(
                      child: isLoading
                          ? Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      CustomColors.GREEN_BUTTON,
                                    ).withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(CustomColors.GREEN_BUTTON),
                                    ),
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(CustomColors.GREEN_BUTTON),
                                    Color(
                                      CustomColors.GREEN_BUTTON,
                                    ).withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      CustomColors.GREEN_BUTTON,
                                    ).withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  addVehicle(
                                    widget.vehicleNo,
                                    widget.vehicleType,
                                  );
                                },
                                icon: Icon(
                                  Iconsax.tick_circle,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Set Default',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins-Bold",
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 12),
                  ],
                  if (!widget.isDefault)
                    Expanded(
                      child: isLoadingDeletion
                          ? Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color.fromARGB(
                                    255,
                                    232,
                                    85,
                                    75,
                                  ).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 232, 85, 75),
                                    ),
                                    strokeWidth: 3,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color.fromARGB(255, 232, 85, 75),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(
                                      255,
                                      232,
                                      85,
                                      75,
                                    ).withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  deleteVehicle(widget.vehicleNo);
                                },
                                icon: Icon(
                                  Iconsax.trash,
                                  size: 16,
                                  color: Color.fromARGB(255, 232, 85, 75),
                                ),
                                label: Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 232, 85, 75),
                                    fontSize: 13,
                                    fontFamily: "Poppins-Bold",
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                    ),
                ],
              ),
            ],
            if (isVisibleFullCard) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(CustomColors.PURPLE_LIGHT).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(CustomColors.PURPLE_LIGHT).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(
                              CustomColors.GREEN_BUTTON,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Color(CustomColors.GREEN_BUTTON),
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Parked At: ${widget.address!}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(
                                CustomColors.GREEN_BUTTON,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(
                                  CustomColors.GREEN_BUTTON,
                                ).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.date!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(CustomColors.GREEN_BUTTON),
                                fontFamily: "Poppins-Bold",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Color(
                                CustomColors.PURPLE_DARK,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(
                                  CustomColors.PURPLE_DARK,
                                ).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Color(CustomColors.PURPLE_DARK),
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  widget.time!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(CustomColors.PURPLE_DARK),
                                    fontFamily: "Poppins-Bold",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                            Color(CustomColors.GREEN_BUTTON).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(
                            CustomColors.GREEN_BUTTON,
                          ).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            color: Color(CustomColors.GREEN_BUTTON),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.timer!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(CustomColors.GREEN_BUTTON),
                              fontFamily: "Poppins-Bold",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

      if (widget.onDefaultVehicleChanged != null) {
        widget.onDefaultVehicleChanged!(vehicleNo);
      }

      widget.getVehicleHistory();
    } on DioException catch (e) {
      String errorMessage = e.response?.data['message'];
      print("errorMessage---" + errorMessage.toString());
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
    if (defaultVehicleNo == vehicleNo) {
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
      String errorMessage = e.response?.data['message'];
      print("errorMessage---" + errorMessage.toString());
      CommonUtil().showToast(errorMessage);
    }
    setState(() {
      isLoadingDeletion = false;
    });
  }
}
