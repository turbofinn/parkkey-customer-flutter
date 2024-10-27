import 'package:flutter/cupertino.dart';

class LoginScreenClipper1 extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(size.width-50, 0);
    path.quadraticBezierTo(size.width-50, size.height * 0.6, size.width - 160, size.height-40);
    path.quadraticBezierTo(30, size.height-20, 0, size.height-70);
    path.lineTo(0, size.height-50);

    // path.lineTo(0, size.height - 200);
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