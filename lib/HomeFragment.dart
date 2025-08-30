import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkey_customer/Fragment/add_vehicle_fragment.dart';
import 'package:parkey_customer/Fragment/profile_fragment_base.dart';
import 'package:parkey_customer/models/parking_location_response.dart';
import 'package:parkey_customer/screens/home_screen.dart';
import 'package:parkey_customer/screens/my_qr_screen.dart';
import 'package:parkey_customer/screens/post_login_screen.dart';
import 'package:parkey_customer/services/api_service.dart';
import 'package:parkey_customer/utils/Constants.dart';
import 'package:parkey_customer/utils/auth_interceptor.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:parkey_customer/utils/distance_calculator.dart';
import 'package:parkey_customer/utils/points_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:geolocator/geolocator.dart' as GeoLocator;
import 'package:geocoding/geocoding.dart';
import 'package:iconsax/iconsax.dart';

import 'colors/CustomColors.dart';

class HomeFragment extends StatefulWidget {
  BuildContext context;
  HomeFragment({required this.context, super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment>
    with WidgetsBindingObserver {
  static GoogleMapController? _googleMapController;
  List<String> photoUrls = [];
  static Set<Marker> _markers = {};
  final Map<String, String> _markerValues = {};
  bool isVisibleFirstCard = true,
      isVisibleSecondCard = false,
      isVisibleStartButton = false,
      isFetchingParkingInfo = true;
  int key = 0;

  Marker? _originMarker;

  String parkingName = "";
  String review = "";
  String location = "";
  List<String> parkingImagesList = [];
  String parkingSpaceStatus = "";
  String distance = "";
  String rating = "";
  String parkingFor = "";
  String parkingSpaceID = "";
  late double lat;
  late double long;
  late String city;

  late LatLng origin = LatLng(12.956609135279141, 77.72078411170865);
  late LatLng destination;
  String errorMessageFetchParkingSpaceInfo = "";
  bool _disposed = false;
  bool isReachedDialogVisible = false;
  String defaultVehicleNo = "";
  String defaultVehicleTypeUri = 'assets/images/';
  List<ParkingLocationResponse> parkingLocationList = [];
  ItemScrollController _scrollController = ItemScrollController();
  final TextEditingController parkingDestinationController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    isReachedDialogVisible = false;
    WidgetsBinding.instance.addObserver(this);
    getLocationList();
    getDefaultVehicleDetails();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }

  void onResume() async {
    print('App resumed');
    checkIfReached();
    await fetchLocation();
  }

  @override
  void dispose() {
    _googleMapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _disposed = true;
    super.dispose();
  }

  CameraPosition _initailCameraPosition = CameraPosition(
    zoom: 18,
    target: LatLng(12.954372, 77.719172),
  );

  final String googleMapsApiKey = Constants.GOOGLE_MAP_API_KEY;

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late List<PointsModel> _points = [];

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.amber, size: 16),
        if (hasHalfStar) Icon(Icons.star_half, color: Colors.amber, size: 16),
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: Colors.amber, size: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthParent = MediaQuery.of(context).size.width;
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
                    Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                    Colors.grey[50]!,
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  child: GoogleMap(
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                      Factory<OneSequenceGestureRecognizer>(
                        () => EagerGestureRecognizer(),
                      ),
                    ].toSet(),
                    key: ValueKey(key),
                    myLocationButtonEnabled: false,
                    initialCameraPosition: _initailCameraPosition,
                    onMapCreated: (controller) {
                      setState(() {
                        _googleMapController = controller;
                        _setCameraBounds();
                      });
                    },
                    markers: _markers,
                    polylines: polylines.values.toSet(),
                  ),
                ),
                Positioned(
                  top: 16,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Parking',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(CustomColors.PURPLE_DARK),
                            fontFamily: "Poppins-Bold",
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    spreadRadius: 0,
                                    blurRadius: 30,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: parkingDestinationController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'Select Your Parking Destination...',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                    fontFamily: "Poppins",
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  prefixIcon: Icon(
                                    Iconsax.search_normal_1,
                                    color: Color(CustomColors.GREEN_BUTTON),
                                    size: 20,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  color: Colors.black87,
                                ),
                                onSubmitted: (value) {
                                  _searchParkingDestination(value);
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyQr(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      spreadRadius: 0,
                                      blurRadius: 30,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/images/qr_code.png',
                                    ),
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: isVisibleFirstCard,
                  child: Positioned(
                    bottom: 16,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  spreadRadius: 0,
                                  blurRadius: 30,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        child: Image(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                            defaultVehicleTypeUri,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        defaultVehicleNo,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddVehicleFragment(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Change',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Color(
                                              CustomColors.GREEN_BUTTON,
                                            ),
                                            fontFamily: "Poppins-Bold",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.grey[200],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Nearest Parking Area',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600],
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // setState(() {
                                          //   parkingLocationList = [];
                                          //   errorMessageFetchParkingSpaceInfo =
                                          //       '';
                                          // });
                                          getLocationList();
                                        },
                                        child: Icon(
                                          Icons.refresh,
                                          color: Color(
                                            CustomColors.GREEN_BUTTON,
                                          ),
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    height: 220,
                                    child: parkingLocationList.isEmpty
                                        ? errorMessageFetchParkingSpaceInfo !=
                                                  ""
                                              ? Center(
                                                  child: Text(
                                                    errorMessageFetchParkingSpaceInfo,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: Container(
                                                    width: 60,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(
                                                            CustomColors
                                                                .PURPLE_DARK,
                                                          ).withOpacity(0.1),
                                                          blurRadius: 30,
                                                          offset: Offset(0, 15),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              Color(
                                                                CustomColors
                                                                    .GREEN_BUTTON,
                                                              ),
                                                            ),
                                                        strokeWidth: 3.5,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                        : ScrollablePositionedList.builder(
                                            itemScrollController:
                                                _scrollController,
                                            itemCount:
                                                parkingLocationList.length,
                                            itemBuilder: (context, index) {
                                              final item =
                                                  parkingLocationList[index];
                                              return Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Color(
                                                    CustomColors.PURPLE_LIGHT,
                                                  ).withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: Color(
                                                      CustomColors.PURPLE_LIGHT,
                                                    ).withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  item.parkingSpaceName ??
                                                                      "",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black87,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  item.address ??
                                                                      "",
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey[600],
                                                                    fontFamily:
                                                                        "Poppins",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                width: 16,
                                                                height: 16,
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                    CustomColors
                                                                        .GREEN_500,
                                                                  ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1.5,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                item.parkingSpaceStatus ??
                                                                    "",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontFamily:
                                                                      "Poppins",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 12),
                                                      Row(
                                                        children: [
                                                          Image(
                                                            image: AssetImage(
                                                              'assets/images/navigator.png',
                                                            ),
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text(
                                                            _points.length > 0
                                                                ? _points
                                                                          .elementAt(
                                                                            index,
                                                                          )
                                                                          .distance
                                                                          .toString() +
                                                                      ' km'
                                                                : "",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .grey[600],
                                                              fontFamily:
                                                                  "Poppins",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 12),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              getRoute(
                                                                origin,
                                                                _points
                                                                    .elementAt(
                                                                      index,
                                                                    )
                                                                    .point,
                                                                parkingSpaceID,
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical: 8,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: Color(
                                                                  CustomColors
                                                                      .GREEN_BUTTON,
                                                                ).withOpacity(0.1),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                border: Border.all(
                                                                  color: Color(
                                                                    CustomColors
                                                                        .GREEN_BUTTON,
                                                                  ).withOpacity(0.3),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Image(
                                                                    image: AssetImage(
                                                                      'assets/images/direction.png',
                                                                    ),
                                                                    width: 20,
                                                                    height: 20,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  Text(
                                                                    'Get Direction',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                        CustomColors
                                                                            .GREEN_BUTTON,
                                                                      ),
                                                                      fontFamily:
                                                                          "Poppins-Bold",
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                isVisibleFirstCard =
                                                                    false;
                                                                isVisibleSecondCard =
                                                                    true;
                                                                parkingName =
                                                                    item.parkingSpaceName ??
                                                                    "";
                                                                location =
                                                                    item.address ??
                                                                    "";
                                                                parkingSpaceStatus =
                                                                    item.parkingSpaceStatus ??
                                                                    "";
                                                                distance = _points
                                                                    .elementAt(
                                                                      index,
                                                                    )
                                                                    .distance
                                                                    .toString();
                                                                destination =
                                                                    _points
                                                                        .elementAt(
                                                                          index,
                                                                        )
                                                                        .point;
                                                                parkingImagesList =
                                                                    _points
                                                                        .elementAt(
                                                                          index,
                                                                        )
                                                                        .parkingImages;
                                                              });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical: 8,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: Color(
                                                                  CustomColors
                                                                      .GREEN_BUTTON,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                              ),
                                                              child: Text(
                                                                'Park Now',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      "Poppins-Bold",
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isVisibleSecondCard,
                  child: Positioned(
                    bottom: 16,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 0,
                              blurRadius: 30,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: isFetchingParkingInfo
                            ? errorMessageFetchParkingSpaceInfo != ""
                                  ? Center(
                                      child: Text(
                                        errorMessageFetchParkingSpaceInfo,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(
                                                CustomColors.PURPLE_DARK,
                                              ).withOpacity(0.1),
                                              blurRadius: 30,
                                              offset: Offset(0, 15),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(
                                                    CustomColors.GREEN_BUTTON,
                                                  ),
                                                ),
                                            strokeWidth: 3.5,
                                          ),
                                        ),
                                      ),
                                    )
                            : Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 5,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                parkingName,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Address: $location',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  CustomColors.GREEN_500,
                                                ),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              parkingSpaceStatus,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[600],
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          'Parking For: ',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[600],
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        Text(
                                          parkingFor,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Ratings',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[600],
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            _buildStarRating(
                                              double.parse(rating),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(
                                              CustomColors.PURPLE_LIGHT,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Color(
                                                CustomColors.PURPLE_LIGHT,
                                              ).withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                  'assets/images/location.png',
                                                ),
                                                width: 20,
                                                height: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '$distance km',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[600],
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    _points.isNotEmpty &&
                                            _points
                                                .first
                                                .parkingImages
                                                .isNotEmpty
                                        ? Container(
                                            height: 150,
                                            child: Swiper(
                                              itemCount:
                                                  parkingImagesList.length,
                                              itemBuilder:
                                                  (
                                                    BuildContext context,
                                                    int index,
                                                  ) {
                                                    return Image.network(
                                                      parkingImagesList[index],
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Center(
                                                              child: Text(
                                                                'Failed to load image',
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontFamily:
                                                                      "Poppins",
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                    );
                                                  },
                                              autoplay: true,
                                              pagination: SwiperPagination(
                                                builder:
                                                    DotSwiperPaginationBuilder(
                                                      color: Colors.grey[400],
                                                      activeColor: Color(
                                                        CustomColors
                                                            .GREEN_BUTTON,
                                                      ),
                                                      size: 8,
                                                      activeSize: 10,
                                                    ),
                                              ),
                                              control: SwiperControl(
                                                color: Color(
                                                  CustomColors.GREEN_BUTTON,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            getRoute(
                                              origin,
                                              destination,
                                              parkingSpaceID,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                CustomColors.GREEN_BUTTON,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Color(
                                                  CustomColors.GREEN_BUTTON,
                                                ).withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                    'assets/images/direction.png',
                                                  ),
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Get Direction',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(
                                                      CustomColors.GREEN_BUTTON,
                                                    ),
                                                    fontFamily: "Poppins-Bold",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isVisibleSecondCard = false;
                                              isVisibleStartButton = true;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(
                                                CustomColors.GREEN_BUTTON,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              'Park Now',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                                fontFamily: "Poppins-Bold",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isVisibleFirstCard = true;
                                            isVisibleSecondCard = false;
                                            isVisibleStartButton = false;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: Color(
                                                CustomColors.PURPLE_LIGHT,
                                              ).withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(
                                                CustomColors.PURPLE_DARK,
                                              ),
                                              fontFamily: "Poppins-Bold",
                                            ),
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
                Visibility(
                  visible: isVisibleStartButton,
                  child: Positioned(
                    bottom: 16,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Center(
                        child: Container(
                          width: 250,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  CustomColors.GREEN_BUTTON,
                                ).withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              openGoogleMapsNavigation();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isReachedDialogVisible,
                  child: showPaymentSuccessDialogFunction(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addNearestMarkers(LatLng center, int count) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _initailCameraPosition = CameraPosition(
      zoom: 18,
      target: _points.elementAt(_points.length - 1).point,
    );

    destination = _points.elementAt(0).point;

    fetchParkingSpaceInfo(
      _points.elementAt(0).parkingSpaceID,
      _points.elementAt(0).distance.toString(),
    );

    Set<Marker> tempMarkers = {};
    var originIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/person.png',
    );

    setState(() {
      _markers.clear();
      _markerValues.clear();
      this.destination = LatLng(
        _points.elementAt(0).point.latitude,
        _points.elementAt(0).point.longitude,
      );
      sharedPreferences.setDouble(
        Constants.TARGET_LAT,
        _points.elementAt(0).point.latitude,
      );
      sharedPreferences.setDouble(
        Constants.TARGET_LONG,
        _points.elementAt(0).point.longitude,
      );
      int size = _points.length;
      for (int i = 0; i < size; i++) {
        var point = _points.elementAt(i);
        String parkingSpaceID = point.parkingSpaceID;
        final value =
            'Value for (${point.point.latitude}, ${point.point.longitude})';

        _markerValues[parkingSpaceID] = value;

        tempMarkers.add(
          Marker(
            markerId: MarkerId('origin'),
            position: origin,
            icon: originIcon,
          ),
        );

        tempMarkers.add(
          Marker(
            markerId: MarkerId(parkingSpaceID),
            position: point.point,
            icon: BitmapDescriptor.defaultMarker,
            onTap: () => _scrollController.scrollTo(
              index: i,
              duration: Duration(milliseconds: 100),
            ),
          ),
        );
      }
    });
    setState(() {
      _markers = tempMarkers;
      _centerMarkers();
      key++;
    });
  }

  void _setCameraBounds() {
    if (_markers.isEmpty) return;

    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;

    for (Marker marker in _markers) {
      if (marker.position.latitude < minLat) minLat = marker.position.latitude;
      if (marker.position.latitude > maxLat) maxLat = marker.position.latitude;
      if (marker.position.longitude < minLng)
        minLng = marker.position.longitude;
      if (marker.position.longitude > maxLng)
        maxLng = marker.position.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    _googleMapController?.animateCamera(cameraUpdate);
  }

  void fetchParkingSpaceInfo(String parkingSpaceID, String distance) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

    try {
      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      var response = await apiService.getParkingSpaceInfo(parkingSpaceID);

      List<String> tempListForParkingFor = response.vehicleType;

      int len = tempListForParkingFor.length;

      parkingFor = "";

      for (int i = 0; i < len - 1; i++) {
        parkingFor += tempListForParkingFor.elementAt(i) + ", ";
      }
      parkingFor += tempListForParkingFor.elementAt(len - 1);

      setState(() {
        parkingName = response.parkingName;
        location = response.location;
        parkingSpaceStatus = response.parkingSpaceStatus;
        this.distance = distance;
        rating = response.rating.toString();
        isFetchingParkingInfo = false;
        parkingSpaceID = response.parkingSpaceID;
      });
    } on DioException catch (e) {
      setState(() {
        errorMessageFetchParkingSpaceInfo =
            Constants.ERROR_FETCHING_PARKING_SPACE_INFO;
      });

      CommonUtil().showToast(errorMessageFetchParkingSpaceInfo);
    }
  }

  void _centerMarkers() async {
    final visibleRegion = await _googleMapController?.getVisibleRegion();
    final visibleMarkers = _markers.where((marker) {
      if (visibleRegion != null) {
        return visibleRegion.contains(marker.position);
      } else {
        return false;
      }
    }).toList();
  }

  Future<void> getRoute(
    LatLng origin,
    LatLng destination,
    String parkingSpaceID,
  ) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleMapsApiKey";

    _markers.clear();
    var originIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/person.png',
    );

    Set<Marker> tempMarkers = {};

    tempMarkers.add(
      Marker(markerId: MarkerId('origin'), position: origin, icon: originIcon),
    );

    tempMarkers.add(
      Marker(
        markerId: MarkerId('destination'),
        position: destination,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      var result = response.data;
      if (result["routes"] != null) {
        PolylineId id = PolylineId('polyline');
        List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(
          result["routes"][0]["overview_polyline"]["points"],
        );
        List<LatLng> coordinates = decodedPoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        Polyline polyline = Polyline(
          polylineId: id,
          color: Color(CustomColors.GREEN_BUTTON),
          width: 5,
          points: coordinates,
        );
        setState(() {
          polylines[id] = polyline;
          _markers = tempMarkers;
          isVisibleSecondCard = false;
          isVisibleFirstCard = false;
          isVisibleStartButton = true;
        });
      }
    } else {
      CommonUtil().showToast(response.statusMessage!);
    }
  }

  Future<void> getLocationList() async {
    await fetchLocation();

    checkIfReached();

    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

      setState(() {
        lat = sharedPreferences.getDouble(Constants.LATITUDE)!;
        long = sharedPreferences.getDouble(Constants.LONGITUDE)!;
        city = sharedPreferences.getString(Constants.CITY)!;
        origin = LatLng(lat, long);
      });

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.getParkingSpaceList(
          sharedPreferences.getString(Constants.CITY)!,
        );

        int size = response.length;

        setState(() {
          parkingLocationList = response;
        });

        List<PointsModel> points = [];

        for (int i = 0; i < size; i++) {
          var item = parkingLocationList.elementAt(i);

          final distanceDouble = await DistanceCalculator().getDistance(
            origin: origin,
            destination: LatLng(
              double.parse(item.latitude!),
              double.parse(item.longitude!),
            ),
          );

          if (distanceDouble == null) {
            continue;
          }

          String jsonString = jsonEncode(item.parkingImages);

          points.add(
            PointsModel(
              LatLng(
                double.parse(item.latitude!),
                double.parse(item.longitude!),
              ),
              item.parkingSpaceID!,
              distanceDouble,
              parkingImages: item.parkingImages,
            ),
          );
        }

        points.sort((a, b) => a.distance.compareTo(b.distance));

        int limit = points.length < 5 ? points.length : 5;
        List<PointsModel> closestPoints = points.sublist(0, limit);

        _points = closestPoints;
        _addNearestMarkers(origin, 5);
      } on DioException catch (e) {
        setState(() {
          errorMessageFetchParkingSpaceInfo = e.response?.data;
        });

        CommonUtil().showToast(errorMessageFetchParkingSpaceInfo);
      }
    } catch (e) {
      setState(() {
        errorMessageFetchParkingSpaceInfo = Constants.GENERIC_ERROR_MESSAGE;
      });
    }
  }

  void openGoogleMapsNavigation() async {
    final String googleMapsUrl =
        'https://www.google.com/maps?dir=${origin.latitude},${origin.longitude}&daddr=${destination.latitude},${destination.longitude}';
    final canLaunch = await canLaunchUrl(Uri.parse(googleMapsUrl));

    if (canLaunch) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  Future<void> fetchLocation() async {
    GeoLocator.Position position =
        await GeoLocator.Geolocator.getCurrentPosition(
          desiredAccuracy: GeoLocator.LocationAccuracy.high,
        );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(Constants.LATITUDE, position.latitude);
    sharedPreferences.setDouble(Constants.LONGITUDE, position.longitude);
    sharedPreferences.setString(Constants.CITY, place.locality!);
    CommonUtil().showToast(place.locality!);
    var originIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(40, 40)),
      'assets/images/person.png',
    );
    origin = LatLng(position.latitude, position.longitude);
    Set<Marker> tempMarkers = {};
    tempMarkers.add(
      Marker(markerId: MarkerId('origin'), position: origin, icon: originIcon),
    );
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      origin = LatLng(position.latitude, position.longitude);
      _markers = tempMarkers;
    });
  }

  void checkIfReached() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final distanceDouble = await DistanceCalculator().getDistance(
      origin: origin,
      destination: LatLng(
        sharedPreferences.getDouble(Constants.TARGET_LAT)!,
        sharedPreferences.getDouble(Constants.TARGET_LONG)!,
      ),
    );
    if ((distanceDouble! * 1000) < 100) {
      if (isReachedDialogVisible == false) {
        setState(() {
          isReachedDialogVisible = true;
        });
      }
    }
  }

  void _searchParkingDestination(String query) async {
    if (query.isEmpty) {
      CommonUtil().showToast("Please enter a valid destination.");
      return;
    }

    LatLng? locationCoordinates = await _getCoordinatesFromAddress(query);
    if (locationCoordinates == null) {
      CommonUtil().showToast("Unable to find the entered location.");
      return;
    }

    _googleMapController?.animateCamera(
      CameraUpdate.newLatLngZoom(locationCoordinates, 14),
    );

    fetchNearbyParking(locationCoordinates);
  }

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    String apiKey = Constants.GOOGLE_MAP_API_KEY;
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey";

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final results = response.data['results'];
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
    } catch (e) {
      print("Geocoding Error: $e");
    }
    return null;
  }

  void fetchNearbyParking(LatLng center) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

    if (accessToken == null) {
      CommonUtil().showToast("Access token is missing.");
      return;
    }

    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(AuthInterceptor(accessToken));

    final ApiService apiService = ApiService(dio);

    try {
      final List<ParkingLocationResponse> response = await apiService
          .getParkingSpaceList(sharedPreferences.getString(Constants.CITY)!);

      List<PointsModel> points = response.map((item) {
        final distance = DistanceCalculator().getDistance(
          origin: center,
          destination: LatLng(
            double.parse(item.latitude!),
            double.parse(item.longitude!),
          ),
        );

        return PointsModel(
          LatLng(double.parse(item.latitude!), double.parse(item.longitude!)),
          item.parkingSpaceID!,
          distance as double,
          parkingImages: item.parkingImages,
        );
      }).toList();

      points.sort((a, b) => a.distance.compareTo(b.distance));

      setState(() {
        _points = points;
        _addNearestMarkers(center, points.length);
      });
    } catch (e) {
      print("Error fetching nearby parking locations: $e");
      CommonUtil().showToast("Error fetching nearby parking locations.");
    }
  }

  Widget showPaymentSuccessDialogFunction() {
    double parentheight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.transparent),
              ),
            ),
            Container(
              height: parentheight * 0.49,
              margin: EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/Success.gif'),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Reached the Parking Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(CustomColors.GREEN_BUTTON),
                        fontFamily: "Poppins-Bold",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(
                                CustomColors.PURPLE_LIGHT,
                              ).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isReachedDialogVisible = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(CustomColors.PURPLE_DARK),
                                fontFamily: "Poppins-Bold",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(CustomColors.GREEN_BUTTON),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Color(
                                  CustomColors.GREEN_BUTTON,
                                ).withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyQr()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Show QR',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                              ),
                            ),
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
    );
  }

  void getDefaultVehicleDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    defaultVehicleNo = sharedPreferences.getString(Constants.VEHICLE_NO) ?? "";

    String defualtVehicleType =
        sharedPreferences.getString(Constants.VEHICLE_TYPE) ?? "";
    if (defaultVehicleNo == "" || defualtVehicleType == "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostLoginScreen()),
      );
      return;
    }

    if (defualtVehicleType == 'Car') {
      defaultVehicleTypeUri += 'car.png';
    } else if (defualtVehicleType == 'Bike') {
      defaultVehicleTypeUri += 'bike.png';
    } else if (defualtVehicleType == 'Heavy Vehicle') {
      defaultVehicleTypeUri += 'truck.png';
    } else {
      defaultVehicleTypeUri += 'cycle.png';
    }
    setState(() {});
  }
}
