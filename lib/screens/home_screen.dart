// ignore_for_file: deprecated_member_use

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

class HomeScreen extends StatefulWidget {
  int index;
  String path;
  HomeScreen({required this.index, required this.path, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  late PageController _pageController;
  double parentHeight = 0.0;
  bool _isDisposed = false;
  List<Widget> tabs = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index == -1 ? 4 : widget.index;
    _pageController = PageController(initialPage: _currentIndex);
    _isDisposed = false;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    parentHeight = MediaQuery.of(context).size.height;
    tabs = [
      HomeFragment(context: context),
      ParkedVehicleFragmentBase(),
      WalletFragment(),
      HistoryFragment(),
      ProfileFragment(context: context),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _navigateToHome();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: _onPageChanged,
            children: tabs,
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Container(
          height: 80,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(
                1,
                Icons.local_parking_outlined,
                Icons.local_parking,
                'Parked',
              ),
              _buildNavItem(
                2,
                Icons.account_balance_wallet_outlined,
                Icons.account_balance_wallet,
                'Wallet',
              ),
              _buildNavItem(
                3,
                Icons.history_outlined,
                Icons.history,
                'History',
              ),
              _buildNavItem(4, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData inactiveIcon,
    IconData activeIcon,
    String label,
  ) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        child: Container(
          height: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(CustomColors.GREEN_BUTTON).withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  size: isSelected ? 26 : 24,
                  color: isSelected
                      ? Color(CustomColors.GREEN_BUTTON)
                      : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Color(CustomColors.GREEN_BUTTON)
                      : Colors.grey.shade600,
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index || _isDisposed || !mounted) return;
    HapticFeedback.lightImpact();
    _safeSetState(() {
      _currentIndex = index;
      widget.path = '/';
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index && !_isDisposed && mounted) {
      _safeSetState(() {
        _currentIndex = index;
      });
    }
  }

  void _navigateToHome() {
    if (_currentIndex != 0 && !_isDisposed && mounted) {
      _safeSetState(() {
        _currentIndex = 0;
      });
      _pageController.jumpToPage(0);
    }
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
  }
}
