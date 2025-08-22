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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: isLoading
                        ? Container(
                            padding: EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: Offset(0, 15),
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 30,
                                  offset: Offset(0, 15),
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
                                      padding: EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(CustomColors.GREEN_BUTTON),
                                            Color(
                                              CustomColors.GREEN_BUTTON,
                                            ).withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(24),
                                          topRight: Radius.circular(24),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Image.asset(
                                              'assets/images/logo.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              'PARKING TICKET',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: "Poppins-Bold",
                                                color: Colors.white,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      width: double.infinity,
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
                                        ],
                                      ),
                                    ),

                                    Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        20,
                                        20,
                                      ),
                                      padding: EdgeInsets.all(28),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(CustomColors.GREEN_BUTTON),
                                            Color(
                                              CustomColors.GREEN_BUTTON,
                                            ).withOpacity(0.8),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(
                                              CustomColors.GREEN_BUTTON,
                                            ).withOpacity(0.4),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.key_outlined,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'EXIT OTP',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Poppins-Bold",
                                              color: Colors.white,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 16,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              otp,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 36,
                                                fontFamily: "Poppins-Bold",
                                                color: Color(
                                                  CustomColors.GREEN_BUTTON,
                                                ),
                                                letterSpacing: 8,
                                              ),
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
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Color(CustomColors.GREEN_BUTTON), size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
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
