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
<<<<<<< HEAD
  HomeScreen({required this.index, required this.path, super.key});
=======
  HomeScreen({required this.index, required this.path,super.key});
>>>>>>> 580d48a27b417df3b5772c6acb864a6fc88f00df

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
<<<<<<< HEAD
    if (widget.index == -1) {
=======
    if(widget.index == -1){
>>>>>>> 580d48a27b417df3b5772c6acb864a6fc88f00df
      _currentIndex = 4;
      widget.index = 0;
    }
    tabs = [
<<<<<<< HEAD
      HomeFragment(
        context: context,
      ),
      ParkedVehicleFragmentBase(),
      WalletFragment(),
      HistoryFragment(),
      ProfileFragmentBase(context: context, path: widget.path),
=======
      HomeFragment(context: context,),
      ParkedVehicleFragmentBase(),
      WalletFragment(),
      HistoryFragment(),
      ProfileFragmentBase(context: context,path: widget.path),
>>>>>>> 580d48a27b417df3b5772c6acb864a6fc88f00df
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
              extendBodyBehindAppBar: true,
              // appBar: AppBar(
              //   toolbarHeight: 70, // Increase height of AppBar
              //   leadingWidth: 60, // Adjust space for image
              //   leading: Padding(
              //     padding: const EdgeInsets.only(left: 10),
              //     child: CircleAvatar(
              //       backgroundColor: Colors.transparent,
              //       // radius: 50, // Keep within 100 AppBar height
              //       backgroundImage: AssetImage('assets/images/user.png'),
              //     ),
              //   ),

              //   title: Padding(
              //     padding: const EdgeInsets.only(left: 5.0),
              //     child: Text(
              //       "Hi there!👋",
              //       style: TextStyle(
              //         fontWeight: FontWeight.w500,
              //         fontSize: 22,
              //       ),
              //     ),
              //   ),
              //   actions: [
              //     Padding(
              //       padding: const EdgeInsets.only(right: 8.0),
              //       child: IconButton(
              //           onPressed: () {},
              //           icon: Icon(
              //             Icons.logout,
              //             size: 30,
              //           )),
              //     )
              //   ],
              //   backgroundColor: Colors.transparent,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadiusGeometry.vertical(
              //           bottom: Radius.circular(15))),

              //   //  backgroundColor: Colors.green,
              // ),
              body: tabs[_currentIndex],
              bottomNavigationBar: SizedBox(
<<<<<<< HEAD
                height: 0.09 * parentHeight,
=======
                height: 0.1*parentHeight,
>>>>>>> 580d48a27b417df3b5772c6acb864a6fc88f00df
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
                      icon: Icons.home,
                      // iconPath: 'assets/Icons/icon_home.png',
                      label: 'Home',
                      index: 0,
                    ),
                    _buildBottomNavigationBarItem(
<<<<<<< HEAD
                      icon: Icons.local_parking,
                      //iconPath: 'assets/Icons/icon_exit.png',
                      label: 'Parked Vehicles',
=======
                      iconPath: 'assets/Icons/icon_exit.png',
                      label: 'Parked',
>>>>>>> 580d48a27b417df3b5772c6acb864a6fc88f00df
                      index: 1,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.account_balance_wallet,
                      // iconPath: 'assets/Icons/icon_wallet.png',
                      label: 'Wallet',
                      index: 2,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.history,
                      // iconPath: 'assets/Icons/icon_history.png',
                      label: 'History',
                      index: 3,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.person,
                      //   iconPath: 'assets/Icons/icon_profile.png',
                      label: 'Profile',
                      index: 4,
                    ),
                  ],
                  //     selectedItemColor: Color(CustomColors.),
                  unselectedItemColor: Colors.grey,
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
    required IconData icon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? Color(CustomColors.GREEN_BUTTON).withOpacity(0.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(8),
<<<<<<< HEAD
        child: Icon(
          icon, // <-- This will be passed as an IconData
          size: 25,
          color: _currentIndex == index
              ? Color(CustomColors.GREEN_BUTTON)
              : Colors.black54,
=======
        child: Image(
          width: 50,
          height: 0.035 * parentHeight,
          image: AssetImage(iconPath),
>>>>>>> 580d48a27b417df3b5772c6acb864a6fc88f00df
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
