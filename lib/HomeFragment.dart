import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:geolocator/geolocator.dart' as GeoLocator;
import 'package:geocoding/geocoding.dart';

import 'colors/CustomColors.dart';

class HomeFragment extends StatefulWidget {
  BuildContext context;
  HomeFragment({required this.context,super.key});
  // const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> with WidgetsBindingObserver{
  static GoogleMapController? _googleMapController;
  static Set<Marker> _markers = {};
  final Map<String, String> _markerValues = {};
  bool isVisibleFirstCard = true,
      isVisibleSecondCard = false,
      isVisibleStartButton = false,
      isFetchingParkingInfo = true;
  int key = 0;

  // Location _location = Location();
  Marker? _originMarker;

  String parkingName = "";
  String review = "";
  String location = "";
  String parkingSpaceStatus = "";
  String distance = "";
  String rating = "";
  String parkingFor = "";
  String parkingSpaceID = "";
  late double lat;
  late double long;
  late String city;

  late LatLng origin = LatLng(12.956609135279141,
      77.72078411170865); // Replace with your origin coordinates
  late LatLng destination;
  String errorMessageFetchParkingSpaceInfo = "";
  bool _disposed = false;
  bool isReachedDialogVisible = false;
  String defaultVehicleNo = "";
  String defaultVehicleTypeUri = 'assets/images/';
  List<ParkingLocationResponse> parkingLocationList = [];
  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    // TODO: implement initState
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

  void onResume() async{
    // Your custom logic here
    print('App resumed');
    checkIfReached();
    await fetchLocation();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _disposed = true;
    super.dispose();
  }


  CameraPosition _initailCameraPosition =
      CameraPosition(zoom: 18, target: LatLng(12.954372, 77.719172));

  final String googleMapsApiKey = Constants.GOOGLE_MAP_API_KEY;

  // Replace with your destination coordinates

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late List<PointsModel> _points = [];

  @override
  Widget build(BuildContext context) {
    print('setState--' + key.toString());
    return SafeArea(
      child: Material(
        child: Stack(
          children: [
            Container(
              child: GoogleMap(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
                ].toSet(),
                key: ValueKey(key),
                myLocationButtonEnabled: false,
                // zoomControlsEnabled: false,
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
              top: 20,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // Shadow color
                            spreadRadius: 5, // Spread radius
                            blurRadius: 7, // Blur radius
                            offset: Offset(0, 3), // Offset from the container
                          ),
                        ],
                        borderRadius: BorderRadius.circular(30),
                        // Border radius
                        border: Border.all(
                          width: 1.5, // Border width
                          color:
                              Color(CustomColors.GREEN_BUTTON), // Border color
                        ),
                      ),
                      margin: EdgeInsets.only(left: 20),
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Select Your Parking Destination...',
                          isCollapsed: true,
                          contentPadding: EdgeInsets.all(10),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyQr()));
                            },
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    // Shadow color
                                    spreadRadius: 5,
                                    // Spread radius
                                    blurRadius: 7,
                                    // Blur radius
                                    offset: Offset(
                                        0, 3), // Offset from the container
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image(
                                  image:
                                      AssetImage('assets/images/qr_code.png')),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      // Shadow color
                                      spreadRadius: 5,
                                      // Spread radius
                                      blurRadius: 7,
                                      // Blur radius
                                      offset: Offset(
                                          0, 3), // Offset from the container
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Image(
                                      fit: BoxFit.fitHeight,
                                      image:
                                          AssetImage('assets/images/bell.png')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isVisibleFirstCard,
              child: Positioned(
                height: 400,
                width: MediaQuery.of(context).size.width,
                bottom: 10,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 10,
                      child: Container(
                        height: 300,
                        margin: EdgeInsets.only(left: 5, right: 5),
                        width: MediaQuery.of(context).size.width - 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              // Shadow color
                              spreadRadius: 5,
                              // Spread radius
                              blurRadius: 7,
                              // Blur radius
                              offset: Offset(0, 3), // Offset from the container
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                          // Border radius
                          border: Border.all(
                            width: 1.5, // Border width
                            color: Color(
                                CustomColors.GREEN_BUTTON), // Border color
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            decoration: BoxDecoration(
                              color: Color(CustomColors.GREY_BG),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Shadow color
                                  spreadRadius: 5, // Spread radius
                                  blurRadius: 7, // Blur radius
                                  offset:
                                      Offset(0, 3), // Offset from the container
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                              // Border radius
                              border: Border.all(
                                width: 1.5, // Border width
                                color: Color(
                                    CustomColors.GREEN_BUTTON), // Border color
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text(
                                          'Default Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 35,
                                      child: Image(
                                          fit: BoxFit.fitHeight,
                                          image: AssetImage(
                                              defaultVehicleTypeUri)),
                                    ),
                                    Container(child: Text("       $defaultVehicleNo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)   ),),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(index: -1,path: '/AddVehicle',)));

                                        // Navigator.of(widget.context).pushNamed('/AddVehicle');
                                      },
                                      child: Text('Change', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(
                                          CustomColors.GREEN_BUTTON)),),
                                    ),)
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, bottom: 10, top: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: Text(
                              'Nearest Parking Area',
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Container(
                            height: 200,
                            margin: EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: parkingLocationList.isEmpty
                                ? errorMessageFetchParkingSpaceInfo != ""
                                    ? Center(
                                        child: Container(
                                          child: Text(
                                              errorMessageFetchParkingSpaceInfo),
                                        ),
                                      )
                                    : Center(
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          child: SizedBox(
                                            child: Transform.scale(
                                              scale: 0.9,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(CustomColors
                                                            .GREEN_BUTTON)),
                                                strokeWidth: 5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                : ScrollablePositionedList.builder(
                                itemScrollController: _scrollController,
                                itemCount: parkingLocationList.length,
                                itemBuilder: (context, index) {
                                  final item = parkingLocationList[index];
                                  return Container(
                                    margin: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withOpacity(0.5), // Shadow color
                                          spreadRadius: 5, // Spread radius
                                          blurRadius: 7, // Blur radius
                                          offset:
                                          Offset(0, 3), // Offset from the container
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      // Border radius
                                      border: Border.all(
                                        width: 1.5, // Border width
                                        color: Color(
                                            CustomColors.GREEN_BUTTON), // Border color
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(left: 20, top: 8),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      child: Text(
                                                        item.parkingSpaceName ?? "",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                            FontWeight.w600),
                                                      )),
                                                  Container(
                                                      child: Text(
                                                        // 'Address: $item \n .....................',
                                                        item.address ?? "",
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w600),
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                EdgeInsets.only(right: 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: Color(CustomColors
                                                            .GREEN_500),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                        // Border radius
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color: Colors
                                                                .white // Border width
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        item.parkingSpaceStatus ?? "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.w600),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ), // parking name
                                          Row(
                                            children: [
                                              Image(
                                                  fit: BoxFit.fitHeight,
                                                  image: AssetImage(
                                                      'assets/images/navigator.png')),
                                              Text(
                                                _points.length > 0 ? _points.elementAt(index).distance.toString() + ' km.\n Away' : "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600),
                                              )
                                            ],
                                          ), // distance
                                          GestureDetector(
                                            onTap: () {
                                              getRoute(origin, _points.elementAt(index).point,
                                                  parkingSpaceID);
                                            },
                                            child: Row(
                                              children: [
                                                Image(
                                                    fit: BoxFit.fitHeight,
                                                    image: AssetImage(
                                                        'assets/images/direction.png')),
                                                Center(
                                                    child: Text(
                                                      'Get \n Direction',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w600),
                                                    )),
                                                Expanded(child: SizedBox()),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isVisibleFirstCard = false;
                                                      isVisibleSecondCard = true;
                                                      parkingName = item.parkingSpaceName ?? "";
                                                      location = item.address ?? "";
                                                      parkingSpaceStatus = item.parkingSpaceStatus ?? "";
                                                      distance = _points.elementAt(index).distance.toString();
                                                      destination = _points.elementAt(index).point;

                                                    });
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      // Border radius
                                                      border: Border.all(
                                                        width:
                                                        1.5, // Border width
                                                        color: Color(CustomColors
                                                            .GREEN_BUTTON), // Border color
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 30,
                                                          right: 30,
                                                          top: 6,
                                                          bottom: 6),
                                                      child: Center(
                                                          child:
                                                          Text('Park Now')),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ) // get direction
                                        ],
                                      ),
                                    ),
                                  );
                            })
                          ) ,
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isVisibleSecondCard,
              child: Positioned(
                bottom: 10,
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  width: MediaQuery.of(context).size.width - 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 7, // Blur radius
                        offset: Offset(0, 3), // Offset from the container
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30), // Border radius
                    border: Border.all(
                      width: 1.5, // Border width
                      color: Color(CustomColors.GREEN_BUTTON), // Border color
                    ),
                  ),
                  child: isFetchingParkingInfo
                      ? errorMessageFetchParkingSpaceInfo != ""
                          ? Center(
                              child: Container(
                                child: Text(errorMessageFetchParkingSpaceInfo),
                              ),
                            )
                          : Center(
                              child: Container(
                                height: 40,
                                width: 40,
                                child: SizedBox(
                                  child: Transform.scale(
                                    scale: 0.9,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(CustomColors.GREEN_BUTTON)),
                                      strokeWidth: 5,
                                    ),
                                  ),
                                ),
                              ),
                            )
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Center(
                                  child: Container(
                                    height: 5,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          child: Text(
                                        parkingName,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      )),
                                      Container(
                                          child: Text(
                                        'Address: $location \n .....................',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color:
                                                Color(CustomColors.GREEN_500),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            // Border radius
                                            border: Border.all(
                                                width: 1.5,
                                                color:
                                                    Colors.white // Border width
                                                ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            parkingSpaceStatus,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Parking For : ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(parkingFor,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Ratings',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                      Container(
                                          height: 30,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 1.5,
                                                color: Color(
                                                    CustomColors.GREEN_BUTTON)),
                                          ),
                                          child: Text('Rated as 5 Star'))
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            width: 1.5,
                                            color: Color(
                                                CustomColors.GREEN_BUTTON))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Image(
                                              image: AssetImage(
                                                  'assets/images/location.png')),
                                          Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Text(
                                                '$distance km',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Text(
                                    'Safety Features : \n 1. Security Cameras \n 2. Access Control \n 3. Guard Petrol \n 4. Alarm System \n 5. Parking Sensors',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      getRoute(
                                          origin, destination, parkingSpaceID);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1.5,
                                              color: Color(
                                                  CustomColors.GREEN_BUTTON))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25, right: 25),
                                        child: Row(
                                          children: [
                                            Image(
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                    'assets/images/direction.png')),
                                            Text(
                                              'Get \n Direction',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isVisibleSecondCard = false;
                                        isVisibleStartButton = true;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 9,
                                            bottom: 9,
                                            left: 35,
                                            right: 35),
                                        child: Text(
                                          'Park Now',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Color(
                                                CustomColors.GREEN_BUTTON),
                                            width: 1.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 35,
                                          right: 35),
                                      child: Text('Cancel'),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
            Visibility(
              visible: isVisibleStartButton,
              child: Positioned(
                bottom: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 50, right: 50),
                      child: ElevatedButton(
                        onPressed: () {
                          openGoogleMapsNavigation();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 50, right: 50),
                          child: Container(
                            child: Text(
                              'Start',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(CustomColors.GREEN_BUTTON),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set border radius
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
                child: showPaymentSuccessDialogFunction())
          ],
        ),
      ),
    );
  }

  void _addNearestMarkers(LatLng center, int count) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    print('listsize---' + _points.length.toString());

    _initailCameraPosition = CameraPosition(
        zoom: 18, target: _points.elementAt(_points.length - 1).point);

    destination = _points.elementAt(0).point;

    fetchParkingSpaceInfo(_points.elementAt(0).parkingSpaceID,
        _points.elementAt(0).distance.toString());

    Set<Marker> tempMarkers = {};
    var originIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(40, 40)),
        'assets/images/person.png');

    // Add markers for these points
    setState(() {
      _markers.clear();
      _markerValues.clear();
      this.destination = LatLng(_points.elementAt(0).point.latitude, _points.elementAt(0).point.longitude);
      sharedPreferences.setDouble(Constants.TARGET_LAT, _points.elementAt(0).point.latitude);
      sharedPreferences.setDouble(Constants.TARGET_LONG, _points.elementAt(0).point.longitude);
      // for (var point in _points) {
      int size = _points.length;
      for(int i = 0 ; i < size ; i++){
        var point = _points.elementAt(i);
        String parkingSpaceID = point.parkingSpaceID;
        print('markerID---' + parkingSpaceID);
        final value =
            'Value for (${point.point.latitude}, ${point.point.longitude})'; // Example value

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
            onTap: () => _scrollController.scrollTo(index: i, duration: Duration(milliseconds: 100))
            ,
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

  void _onMarkerTapped(
      String parkingSpaceID, String distance, LatLng destination) async{
    print('location---' + parkingSpaceID);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isFetchingParkingInfo = true;
      isVisibleFirstCard = false;
      isVisibleSecondCard = true;
      this.destination = destination;
      sharedPreferences.setDouble(Constants.TARGET_LAT, destination.latitude);
      sharedPreferences.setDouble(Constants.TARGET_LONG, destination.longitude);
    });
    fetchParkingSpaceInfo(parkingSpaceID, distance);
  }

  void fetchParkingSpaceInfo(String parkingSpaceID, String distance) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

    try {
      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));
      print('token--' + accessToken);

      final ApiService apiService = ApiService(dio);

      var response = await apiService.getParkingSpaceInfo(parkingSpaceID);

      print('response--' + response.totalSpace.toString());

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

      print("errorMessage---" + errorMessageFetchParkingSpaceInfo.toString());
      CommonUtil().showToast(errorMessageFetchParkingSpaceInfo);
      print("Api Call Error-->" + e.toString());
    }
  }

  void _centerMarkers() async {
    final visibleRegion = await _googleMapController?.getVisibleRegion();
    final visibleMarkers = _markers.where((marker) {
      if (visibleRegion != null) {
        return visibleRegion.contains(marker.position);
      } else {
        // Handle the case where visibleRegion is null (optional)
        return false; // Or some other default behavior
      }
    }).toList();
  }

  Future<void> getRoute(
      LatLng origin, LatLng destination, String parkingSpaceID) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleMapsApiKey";

    _markers.clear();
    var originIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(40, 40)),
        'assets/images/person.png');

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
        List<PointLatLng> decodedPoints = polylinePoints
            .decodePolyline(result["routes"][0]["overview_polyline"]["points"]);
        List<LatLng> coordinates = decodedPoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        Polyline polyline = Polyline(
            polylineId: id,
            color: Color(CustomColors.GREEN_BUTTON),
            width: 5,
            points: coordinates);
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

    try{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
    print('userid--' + accessToken!);

    try {
      print('responseerly');
      final response = await apiService.getParkingSpaceList(sharedPreferences.getString(Constants.CITY)!);
      print('response-->');
      print(response);

      int size = response.length;

      setState(() {
        parkingLocationList = response;
      });

      List<PointsModel> points = [];

      for (int i = 0; i < size; i++) {
        var item = parkingLocationList.elementAt(i);

        final distanceDouble = await DistanceCalculator().getDistance(
          origin: origin,
          destination:
              LatLng(double.parse(item.latitude!), double.parse(item.longitude!)),
        );

        if (distanceDouble == null) {
          continue;
        }

        points.add(PointsModel(
            LatLng(double.parse(item.latitude!), double.parse(item.longitude!)),
            item.parkingSpaceID!,
            distanceDouble));
      }

      List<PointsModel> closestPoints = points;

      _points = closestPoints;
      _addNearestMarkers(origin, 5);
    } on DioException catch (e) {
      setState(() {
        errorMessageFetchParkingSpaceInfo = e.response?.data;
      });

      print("errorMessage---" + errorMessageFetchParkingSpaceInfo.toString());
      CommonUtil().showToast(errorMessageFetchParkingSpaceInfo);
    }
    }catch(e){
      print('exception-->' + e.toString());
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

  Future<void> fetchLocation() async{
    GeoLocator.Position position = await GeoLocator.Geolocator.getCurrentPosition(
        desiredAccuracy: GeoLocator.LocationAccuracy.high);

    // Get the address from coordinates
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(Constants.LATITUDE,position.latitude);
    sharedPreferences.setDouble(Constants.LONGITUDE,position.longitude);
    sharedPreferences.setString(Constants.CITY,place.locality!);
    print('city---'+place.locality!);
    CommonUtil().showToast(place.locality!);
    var originIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(40, 40)),
        'assets/images/person.png');
    origin = LatLng(position.latitude, position.longitude);
    Set<Marker> tempMarkers = {};
    tempMarkers.add(Marker(
      markerId: MarkerId('origin'),
      position: origin,
      icon: originIcon,
    ));
    // Update UI
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      origin = LatLng(position.latitude, position.longitude);
      _markers=tempMarkers;
    });
  }

  void checkIfReached() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final distanceDouble = await DistanceCalculator().getDistance(
      origin: origin,
      destination:
      LatLng(sharedPreferences.getDouble(Constants.TARGET_LAT)!, sharedPreferences.getDouble(Constants.TARGET_LONG)!),
    );
    print('currentdistance--' + distanceDouble.toString());
    if((distanceDouble! * 1000) < 100){
      if(isReachedDialogVisible == false){
          setState(() {
            isReachedDialogVisible = true;
          });
      }
    }

  }

  Widget showPaymentSuccessDialogFunction(){
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
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: 400,
              margin: EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    //blurRadius: 7, // Adjust the blur radius of the shadow
                    offset: Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Padding(
                            padding: EdgeInsets.all(50),
                            child: Image(
                              image: AssetImage('assets/images/tick.png'),
                            )),
                      ),
                      Positioned(
                          top: 40,
                          left: 50,
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 130,
                          left: 40,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 170,
                          left: 100,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 170,
                          right: 70,
                          child: Container(
                            height: 5,
                            width: 5,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 130,
                          right: 50,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                      Positioned(
                          top: 33,
                          right: 50,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.GREEN_BUTTON),
                                borderRadius: BorderRadius.circular(20)
                            ),
                          )),
                    ],
                  ),
                  Container(
                    child: Text(
                      'Reached the Parking Location',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(CustomColors.GREEN_BUTTON)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: ElevatedButton(onPressed: (){
                            setState(() {
                              isReachedDialogVisible = false;
                            });
                          }, child: Text('Close', style: TextStyle(color: Colors.black)),style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius
                            ),
                          ),),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyQr()));
                          }, child: Text('Show QR', style: TextStyle(color: Colors.white),),style: ElevatedButton.styleFrom(
                            backgroundColor: Color(CustomColors.GREEN_BUTTON),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius
                            ),
                          ),),
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

  void getDefaultVehicleDetails() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    defaultVehicleNo = sharedPreferences.getString(Constants.VEHICLE_NO) ?? "";

    String defualtVehicleType = sharedPreferences.getString(Constants.VEHICLE_TYPE) ?? "";
    if(defaultVehicleNo == "" || defualtVehicleType == ""){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PostLoginScreen()));
      return;
    }
    print('defaultVehicleHome-->' + defualtVehicleType);


    if(defualtVehicleType == 'Car'){
      defaultVehicleTypeUri += 'car.png';
    }
    else if(defualtVehicleType == 'Bike'){
      defaultVehicleTypeUri += 'bike.png';
    }
    else if(defualtVehicleType == 'Heavy Vehicle'){
      defaultVehicleTypeUri += 'truck.png';
    }
    else{
      defaultVehicleTypeUri += 'cycle.png';
    }
    setState(() {

    });

  }
}
