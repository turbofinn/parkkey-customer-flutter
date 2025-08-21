import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:parkey_customer/HomeFragment.dart';
import 'package:parkey_customer/UIComponents/history_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/CustomColors.dart';
import '../models/customer_vehicle_details_response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class ParkedFragment extends StatefulWidget {
  const ParkedFragment({super.key});

  @override
  State<ParkedFragment> createState() => _ParkedFragmentState();
}

class _ParkedFragmentState extends State<ParkedFragment> {
  List<CustomerVehicleResponse> customerVehicleResponseList = [];
  bool isLoading = true;
  String errorMessage = "";
  String? customerName;

  @override
  void initState() {
    super.initState();
    getVehicleHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(CustomColors.PURPLE_DARK).withOpacity(0.05),
                    Colors.grey[50]!,
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  child: Text(
                    'Parked Vehicles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(CustomColors.PURPLE_DARK),
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? _buildLoadingState()
                      : errorMessage.isNotEmpty
                      ? _buildErrorState()
                      : customerVehicleResponseList.isEmpty
                      ? _buildEmptyState()
                      : _buildVehicleList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(CustomColors.GREEN_BUTTON),
                ),
                strokeWidth: 3.5,
              ),
            ),
          ),
          SizedBox(height: 28),
          Text(
            'Loading parking history...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait a moment',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24),
        padding: EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red[400],
                size: 45,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontFamily: "Poppins-Bold",
              ),
            ),
            SizedBox(height: 12),
            Text(
              'We couldn\'t load the parking history.\nPlease check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 28),
            ElevatedButton(
              onPressed: getVehicleHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(CustomColors.GREEN_BUTTON),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          getVehicleHistory();
        },
        color: Color(CustomColors.GREEN_BUTTON),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(24),
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(CustomColors.PURPLE_DARK).withOpacity(0.08),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                        Color(CustomColors.PURPLE_DARK).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.local_parking_rounded,
                    color: Color(CustomColors.PURPLE_DARK),
                    size: 60,
                  ),
                ),
                SizedBox(height: 28),
                Text(
                  'No Parking History',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: "Poppins-Bold",
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'There are currently no vehicles in\nthe parking history.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    height: 1.4,
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Pull down to refresh',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(CustomColors.GREEN_BUTTON),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
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

  Widget _buildVehicleList() {
    return RefreshIndicator(
      onRefresh: () async {
        getVehicleHistory();
      },
      color: Color(CustomColors.GREEN_BUTTON),
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = customerVehicleResponseList[index];
                return GestureDetector(
                  onTap: () {
                    log('item---${item.parkingTicketID!}');
                    Navigator.of(context).pushNamed(
                      '/DedicatedHistoryFragment',
                      arguments: item.parkingTicketID,
                    );
                  },
                  child: HistoryItem(
                    customerName == null ? "NA" : customerName!,
                    item.vehicleNo,
                    item.vehicleType,
                    item.parkingLocation!,
                    item.parkingDateTime!.substring(11, 16),
                    item.parkingDateTime!.substring(0, 10),
                    item.parkingDuration!,
                    false,
                    getVehicleHistory,
                    null,
                  ),
                );
              }, childCount: customerVehicleResponseList.length),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  void getVehicleHistory() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);
      customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      final response = await apiService.getCustomerVehicleDetails(userID!);

      List<CustomerVehicleResponse> tempList = [];
      for (var vehicle in response.customerVehicleList) {
        if (vehicle.parkingLocation != null) {
          tempList.add(vehicle);
        }
      }

      if (tempList.isEmpty) {
        setState(() {
          errorMessage = Constants.EMPTY_VEHICLE_LIST;
          isLoading = false;
        });
        return;
      }

      setState(() {
        customerVehicleResponseList = tempList;
        isLoading = false;
      });
    } on DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? Constants.GENERIC_ERROR_MESSAGE;
      print("errorMessage---$errorMessage");
      CommonUtil().showToast(errorMessage);
      setState(() {
        this.errorMessage = errorMessage;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
        isLoading = false;
      });
    }
  }
}
