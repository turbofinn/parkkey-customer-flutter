import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:parkey_customer/UIComponents/back_top_title.dart';

import '../Clippers/login_screen_clipper1.dart';
import '../Clippers/login_screen_clipper2.dart';
import '../colors/CustomColors.dart';
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isCheckedGpay = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Material(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipPath(
                clipper: LoginScreenClipper1(),
                child: Container(
                  height: 150,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 150,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackTopTitle('assets/images/arrow_back.png', Colors.black, 'Payment', ''),
              Padding(
                padding: const EdgeInsets.only(top: 12,bottom: 50,left: 15),
                child: Container(
                  child: Text('Choose Payment Method',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black),),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(CustomColors.GREEN_BUTTON),
                              width: 1.5
                            )
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image(image: AssetImage('assets/images/gpay.png'),),
                                ),
                              ),
                              Expanded(child: Text('Google Pay',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black),),),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(CustomColors.GREEN_BUTTON),
                                      width: 1.5
                                    )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(CustomColors.GREEN_BUTTON),
                                width: 1.5
                            )
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image(image: AssetImage('assets/images/gpay.png'),),
                              ),
                            ),
                            Expanded(child: Text('Google Pay',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black),),),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        width: 1.5
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(CustomColors.GREEN_BUTTON),
                                width: 1.5
                            )
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image(image: AssetImage('assets/images/gpay.png'),),
                              ),
                            ),
                            Expanded(child: Text('Google Pay',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black),),),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        width: 1.5
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(CustomColors.GREEN_BUTTON),
                                width: 1.5
                            )
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image(image: AssetImage('assets/images/gpay.png'),),
                              ),
                            ),
                            Expanded(child: Text('Google Pay',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black),),),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        width: 1.5
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(CustomColors.GREEN_BUTTON),
                                width: 1.5
                            )
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image(image: AssetImage('assets/images/gpay.png'),),
                              ),
                            ),
                            Expanded(child: Text('Google Pay',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black),),),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        width: 1.5
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Color(CustomColors.GREEN_BUTTON),
                                width: 1.5
                            )
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image(image: AssetImage('assets/images/gpay.png'),),
                              ),
                            ),
                            Expanded(child: Text('Google Pay',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 14,color: Colors.black),),),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        width: 1.5
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        color: Color(CustomColors.GREEN_BUTTON),
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10),
                          child: Container(
                            child: Text(
                              'Other',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12),
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
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}
