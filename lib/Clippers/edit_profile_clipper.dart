import 'package:flutter/cupertino.dart';

class EditProfileClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height - 30); // Move to the bottom-left corner
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30); // Draw the curve
    path.lineTo(size.width, 0);
    path.close();
    return path;

    // var firstStart = Offset(size.width + size.width*0.3, size.height * 0.8);

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {

    return false;
    // TODO: implement shouldReclip
  }

}