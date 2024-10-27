import 'package:flutter/cupertino.dart';

class LoginScreenClipper2 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
   // path.quadraticBezierTo(size.width, size.height/2, size.width - 120, size.height);
    path.lineTo(20, size.height); // Start from bottom-left corner
    path.lineTo(size.width, size.height); // Go to bottom-right corner
    path.lineTo(size.width, 0); // Go to top-right corner
    path.quadraticBezierTo(20, 20, 20, size.height); // Create a quadratic Bézier curve to the top-left corner
    path.close(); // Close the path
    return path;

    // var firstStart = Offset(size.width + size.width*0.3, size.height * 0.8);

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {

    return false;
    // TODO: implement shouldReclip
  }

}