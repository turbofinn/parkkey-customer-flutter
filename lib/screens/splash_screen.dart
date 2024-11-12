import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:parkey_customer/screens/login_screen.dart';
import 'package:parkey_customer/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Clippers/login_screen_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import 'package:location/location.dart' as location;
import '../colors/CustomColors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {

  bool _disposed = false;
  var _logoWidth = 170.0;
  var _logoHeight = 150.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    handlePermissions();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      if(!_disposed) {
        setState(() {
          _logoHeight = 250.0;
          _logoWidth = 270.0;
        });
      }
    });

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // The app is resumed
      onResume();
    }
  }

  void onResume() {
    handlePermissions();
    // Your custom logic here
    print('App resumed');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    _disposed = true;
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    double heightParent = MediaQuery.of(context).size.height;
    double widthParent = MediaQuery.of(context).size.width;


    return SafeArea(
        child: Material(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipPath(
                clipper: LoginScreenClipper1(),
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
                  height: heightParent - 200,
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 2),
                      width: _logoWidth,
                      height: _logoHeight,
                      curve: Curves.easeInOut,
                      child: Image(
                        height: 150,
                        width: 150,
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/app_logo.png'),
                      ),
                    )
                ),
                Center(
                  child: Container(
                    child: Text('Parking Junction Private Limited'),
                  ),
                )
              ],
            ),
          )

        ],
      )
    ));
  }


  void handlePermissions() async{

    location.Location lcn = location.Location();

    PermissionStatus locationStatus = PermissionStatus.denied;

    locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {

      bool isServiceEnabled = await lcn.serviceEnabled();
      if(!isServiceEnabled){
        isServiceEnabled = await lcn.requestService();

        if(!isServiceEnabled){
          handlePermissions();
        }
        else{
          bool isLocationPermissionGranted = await _handlePermission();
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          print("Splash_screen");

          if(sharedPreferences.getString(Constants.ACCESS_TOKEN)!=null){
            print(sharedPreferences.getString("accessToken"));
            String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

            Future.delayed(Duration(seconds: 4), () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen(index: 0,path: '/',)));
            });

          }
          else{
            print("splashPre");
            Future.delayed(Duration(seconds: 4),(){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> LoginScreen()));
            });

          }
        }
      }
      else{
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        print("Splash_screen");

        if(sharedPreferences.getString(Constants.ACCESS_TOKEN)!=null){
          print(sharedPreferences.getString("accessToken"));
          String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);

          Future.delayed(Duration(seconds: 4), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>HomeScreen(index: 0,path: '/',)));
          });

        }
        else{
          print("splashPre");
          Future.delayed(Duration(seconds: 4),(){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> LoginScreen()));
          });

        }
      }
    } else {
      bool isLocationPermissionGranted = await _handlePermission();

      if (await isLocationPermissionGranted == false) {
        bool isLocationPermissionGranted = await _handlePermission();

        if(isLocationPermissionGranted == false){
          showToast('Please allow location permission');
        }
      }

    }

  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    print('permission');

    permission = await _geolocatorPlatform.checkPermission();
    print('lch');
    print(permission);
    var status = await Permission.location.status;
    print('status1');
    print(status);
    if (status == PermissionStatus.denied) {
      print('status');
      print(status);
      status = await Permission.location.request();
      if (status == PermissionStatus.denied) {
        return false;
      }
    }

    if (status == PermissionStatus.permanentlyDenied) {
      Fluttertoast.showToast(
        msg: "Please allow precise location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      AppSettings.openAppSettings();
      return false;
    }
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    print(serviceEnabled);
    if (!serviceEnabled) {

      showToast('Please Enable Location');

      return false;
    }

    try {
      Position position = await _geolocatorPlatform.getCurrentPosition();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setDouble(Constants.LATITUDE, position.latitude);
      sharedPreferences.setDouble(Constants.LONGITUDE, position.longitude);
      print('Current position: ${position.latitude}, ${position.longitude}');
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String city = placemark.locality ?? '';
        print('City: $city');
        sharedPreferences.setString(Constants.CITY, city);
      } else {
        print('No placemarks found');
      }
      return true;
    } catch (e) {
      print('Failed to get current location: $e');
      Fluttertoast.showToast(
        msg: "Failed to get current location",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }

    return true;
  }


}

