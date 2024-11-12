import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkey_customer/Fragment/ProfileFragment.dart';
import 'package:parkey_customer/Fragment/WalletFragment.dart';
import 'package:parkey_customer/Fragment/history_fragment.dart';
import 'package:parkey_customer/Fragment/profile_fragment_base.dart';
import 'package:parkey_customer/HomeFragment.dart';
import 'package:parkey_customer/colors/CustomColors.dart';

import '../Fragment/parked_vehicle_fragment_base.dart';
import '../Fragment/parked_vehicles_fragment.dart';

class HomeScreen extends StatefulWidget {
  int index;
  String path;
  HomeScreen({required this.index, required this.path,super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> tabs = [];
  double parentHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    parentHeight = MediaQuery.of(context).size.height;
    if(widget.index == -1){
      _currentIndex = 4;
      widget.index = 0;
    }
    tabs = [
      HomeFragment(context: context,),
      ParkedVehicleFragmentBase(),
      WalletFragment(),
      HistoryFragment(),
      ProfileFragmentBase(context: context,path: widget.path),
    ];
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _currentIndex = 0;
        });
        return false;
      },
      child: SafeArea(
        child: Material(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              // Do nothing on horizontal swipe
            },
            child: Scaffold(
              body: tabs[_currentIndex],
              bottomNavigationBar: SizedBox(
                height: 0.09*parentHeight,
                child: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                      widget.path = '/';
                    });
                  },
                  items: [
                    _buildBottomNavigationBarItem(
                      iconPath: 'assets/Icons/icon_home.png',
                      label: 'Home',
                      index: 0,
                    ),
                    _buildBottomNavigationBarItem(
                      iconPath: 'assets/Icons/icon_exit.png',
                      label: 'Parked Vehicles',
                      index: 1,
                    ),
                    _buildBottomNavigationBarItem(
                      iconPath: 'assets/Icons/icon_wallet.png',
                      label: 'Wallet',
                      index: 2,
                    ),
                    _buildBottomNavigationBarItem(
                      iconPath: 'assets/Icons/icon_history.png',
                      label: 'History',
                      index: 3,
                    ),
                    _buildBottomNavigationBarItem(
                      iconPath: 'assets/Icons/icon_profile.png',
                      label: 'Profile',
                      index: 4,
                    ),
                  ],
                  selectedItemColor: Color(CustomColors.GREEN_BUTTON),
                  unselectedItemColor: Colors.black,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  showUnselectedLabels: true,
                  showSelectedLabels: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? Color(CustomColors.GREEN_BUTTON)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(8),
        child: Image(
          width: 50,
          height: 0.03 * parentHeight,
          image: AssetImage(iconPath),
        ),
      ),
      label: label,
    );
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void initialiseUI() {}
}
