import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';

class DedicatedHistoryFragment extends StatefulWidget {
  String parkingTicketID;
  DedicatedHistoryFragment({required this.parkingTicketID});

  @override
  State<DedicatedHistoryFragment> createState() =>
      _DedicatedHistoryFragmentState();
}

class _DedicatedHistoryFragmentState extends State<DedicatedHistoryFragment>
    with SingleTickerProviderStateMixin {
  late String name = "";
  late String parkDate = "";
  late String vehicleNo = "";
  late String duration = "";
  late String location = "";
  late String otp = "";
  late String phone = "";
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    fetchVehicleExitInfo();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          'Parking Details',
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: isLoading
                        ? Container(
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(CustomColors.GREEN_BUTTON),
                                    ),
                                    strokeWidth: 3,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading Details...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Poppins-Medium",
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            constraints: BoxConstraints(maxWidth: 350),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(CustomColors.GREEN_BUTTON),
                                            Color(
                                              CustomColors.GREEN_BUTTON,
                                            ).withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.directions_car,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'PARKING TICKET',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Poppins-Bold",
                                              color: Colors.white,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          _buildCleanInfoRow(
                                            Icons.directions_car_outlined,
                                            vehicleNo.toUpperCase(),
                                            'Vehicle Number',
                                          ),
                                          SizedBox(height: 12),
                                          _buildCleanInfoRow(
                                            Icons.person_outline,
                                            name.isNotEmpty ? name : 'N/A',
                                            'Customer Name',
                                          ),
                                          SizedBox(height: 12),
                                          _buildCleanInfoRow(
                                            Icons.phone_outlined,
                                            phone.isNotEmpty
                                                ? '+91 $phone'
                                                : 'N/A',
                                            'Phone Number',
                                          ),
                                          SizedBox(height: 12),
                                          _buildCleanInfoRow(
                                            Icons.location_on_outlined,
                                            location,
                                            'Location',
                                          ),
                                          SizedBox(height: 12),
                                          _buildCleanInfoRow(
                                            Icons.calendar_today_outlined,
                                            parkDate,
                                            'Parking Date',
                                          ),
                                          SizedBox(height: 12),
                                          _buildCleanInfoRow(
                                            Icons.access_time_outlined,
                                            duration,
                                            'Duration',
                                          ),
                                          SizedBox(height: 20),

                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 20,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                CustomColors.GREEN_BUTTON,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(
                                                  CustomColors.GREEN_BUTTON,
                                                ).withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.key,
                                                      color: Color(
                                                        CustomColors
                                                            .GREEN_BUTTON,
                                                      ),
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      'Exit OTP',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily:
                                                            "Poppins-Medium",
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  otp,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: "Poppins-Bold",
                                                    color: Color(
                                                      CustomColors.GREEN_BUTTON,
                                                    ),
                                                    letterSpacing: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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

  Widget _buildCleanInfoRow(IconData icon, String value, String label) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(CustomColors.GREEN_BUTTON), size: 16),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: "Poppins",
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins-SemiBold",
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void fetchVehicleExitInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken!));
    final ApiService apiService = ApiService(dio);
    try {
      final response = await apiService.getTicket(widget.parkingTicketID);
      setState(() {
        if (response.customerName != null) {
          name = response.customerName!;
        }
        parkDate = response.parkDate!;
        vehicleNo = response.vehicleNo;
        duration = response.parkedDuration!;
        location = response.parkingLocation!;
        phone = response.mobileNo;
        otp = response.exitOTP!;
        isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
