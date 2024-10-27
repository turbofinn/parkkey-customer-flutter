import 'package:flutter/cupertino.dart';

class DedicatedHistoryClipper1 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    final double radius = 20.0;
    // TODO: implement getClip
    final path = Path()
      ..moveTo(0, size.height) // Start from bottom-left corner
      ..lineTo(0, 0) // Go to top-left corner
      ..lineTo(size.width, 0) // Go to top-right corner
      ..lineTo(size.width, size.height) // Go to bottom-right corner
      ..lineTo(radius, size.height) // Move to bottom-left corner of the arc
      ..arcToPoint(
        Offset(size.width - radius, size.height), // Bottom-right corner of the arc
        radius: Radius.circular(radius), // Radius for the bottom-right corner
        clockwise: false,
      )
      ..lineTo(0, size.height);
    return path;

    // var firstStart = Offset(size.width + size.width*0.3, size.height * 0.8);

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {

    return false;
    // TODO: implement shouldReclip
  }

}