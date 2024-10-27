import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkey_customer/colors/CustomColors.dart';

class CustomAlertDialog extends StatefulWidget {
  late String title;

  CustomAlertDialog(this.title, {super.key});

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  double heightParent = double.infinity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: 200,
              height: 200,
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
                      widget.title,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(CustomColors.GREEN_BUTTON)),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 16, right: 16),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            child: Text(
                              'Continue',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(CustomColors.GREEN_BUTTON),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set border radius
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
