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

import '../colors/CustomColors.dart';
import 'home_screen.dart';
import 'package:location/location.dart' as location;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _disposed = false;

  late AnimationController _logoController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    handlePermissions();
    WidgetsBinding.instance.addObserver(this);

    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 500), () {
      if (!_disposed) _logoController.forward();
    });
    Future.delayed(Duration(milliseconds: 800), () {
      if (!_disposed) _slideController.forward();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }

  void onResume() {
    handlePermissions();
    print('App resumed');
  }

  @override
  void dispose() {
    _disposed = true;
    _logoController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightParent = MediaQuery.of(context).size.height;
    double widthParent = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Container(
          width: widthParent,
          height: heightParent,
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedLogo(),
                SizedBox(height: 50),
                _buildCompanyName(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(CustomColors.PURPLE_DARK).withOpacity(0.2),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/app_logo.png',
                fit: BoxFit.cover,
                height: 100,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompanyName() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          'Parking Junction Private Limited',
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Poppins-Bold",
            color: Colors.black87,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void handlePermissions() async {
    location.Location lcn = location.Location();

    PermissionStatus locationStatus = PermissionStatus.denied;

    locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      bool isServiceEnabled = await lcn.serviceEnabled();
      if (!isServiceEnabled) {
        isServiceEnabled = await lcn.requestService();

        if (!isServiceEnabled) {
          handlePermissions();
        } else {
          bool isLocationPermissionGranted = await _handlePermission();
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          print("Splash_screen");

          if (sharedPreferences.getString(Constants.ACCESS_TOKEN) != null) {
            print(sharedPreferences.getString("accessToken"));
            String? accessToken = sharedPreferences.getString(
              Constants.ACCESS_TOKEN,
            );

            Future.delayed(Duration(seconds: 4), () {
              if (!_disposed) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(index: 0, path: '/'),
                  ),
                );
              }
            });
          } else {
            print("splashPre");
            Future.delayed(Duration(seconds: 4), () {
              if (!_disposed) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              }
            });
          }
        }
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        print("Splash_screen");

        if (sharedPreferences.getString(Constants.ACCESS_TOKEN) != null) {
          print(sharedPreferences.getString("accessToken"));
          String? accessToken = sharedPreferences.getString(
            Constants.ACCESS_TOKEN,
          );

          Future.delayed(Duration(seconds: 4), () {
            if (!_disposed) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => HomeScreen(index: 0, path: '/'),
                ),
              );
            }
          });
        } else {
          print("splashPre");
          Future.delayed(Duration(seconds: 4), () {
            if (!_disposed) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            }
          });
        }
      }
    } else {
      bool isLocationPermissionGranted = await _handlePermission();

      if (await isLocationPermissionGranted == false) {
        bool isLocationPermissionGranted = await _handlePermission();

        if (isLocationPermissionGranted == false) {
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
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setDouble(Constants.LATITUDE, position.latitude);
      sharedPreferences.setDouble(Constants.LONGITUDE, position.longitude);
      print('Current position: ${position.latitude}, ${position.longitude}');
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
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
  }
}
