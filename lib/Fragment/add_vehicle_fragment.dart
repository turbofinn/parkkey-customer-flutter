import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:parkey_customer/Fragment/history.dart';
import 'package:parkey_customer/utils/common_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors/CustomColors.dart';
import '../models/add_vehicle_request.dart';
import '../models/customer_vehicle_details_response.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/upper_text_formatter.dart';

class AddVehicleFragment extends StatefulWidget {
  const AddVehicleFragment({super.key});

  @override
  State<AddVehicleFragment> createState() => _AddVehicleFragmentState();
}

class _AddVehicleFragmentState extends State<AddVehicleFragment> {
  final _vnumber = GlobalKey<FormState>();
  final TextEditingController vehicleNumberInputController =
      TextEditingController();
  String? vehicleType;
  final List<String> _items = ['Car', 'Bike', 'Heavy Vehicle', 'Bicycle'];
  bool isLoadingList = true;
  List<CustomerVehicleResponse> customerVehicleResponseList = [];
  bool isSaving = false;
  String errorMessage = "Some Error Occurred";
  String? defaultVehicleNo;

  @override
  void initState() {
    super.initState();
    getVehicleHistory();
    _loadDefaultVehicleNo();
  }

  void _loadDefaultVehicleNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      defaultVehicleNo = prefs.getString(Constants.VEHICLE_NO);
    });
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode vehicleNumberFocusNode = FocusNode();
    final ScrollController scrollController = ScrollController();

    vehicleNumberFocusNode.addListener(() {
      if (vehicleNumberFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            final RenderBox? renderBox =
                _vnumber.currentContext?.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              final offset = renderBox.localToGlobal(Offset.zero).dy;
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              final screenHeight = MediaQuery.of(context).size.height;
              final desiredPosition =
                  offset - (screenHeight - keyboardHeight) / 2;

              scrollController.animateTo(
                scrollController.offset + desiredPosition,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        });
      }
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
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
              ),
              Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          _buildMyVehiclesSection(),
                          SizedBox(height: 24),
                          _buildAddVehicleSection(vehicleNumberFocusNode),
                          SizedBox(
                            height:
                                MediaQuery.of(context).viewInsets.bottom + 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddVehicleSection(FocusNode vehicleNumberFocusNode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Iconsax.add_circle,
                    color: Color(CustomColors.PURPLE_DARK),
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Add New Vehicle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(CustomColors.PURPLE_DARK),
                    fontFamily: "Poppins-Bold",
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildVehicleNumberInput(vehicleNumberFocusNode),
            SizedBox(height: 16),
            _buildVehicleTypeDropdown(),
            SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleNumberInput(FocusNode focusNode) {
    return Container(
      decoration: BoxDecoration(
        color: Color(CustomColors.PURPLE_LIGHT).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: _vnumber,
        child: TextFormField(
          focusNode: focusNode,
          inputFormatters: [UpperCaseTextFormatter()],
          controller: vehicleNumberInputController,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
          decoration: InputDecoration(
            prefixIcon: Container(
              padding: EdgeInsets.all(12),
              child: Icon(
                Iconsax.car,
                color: Color(CustomColors.GREEN_BUTTON),
                size: 22,
              ),
            ),
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
            ),
            labelText: 'Enter Vehicle Number',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter vehicle number';
            }
            if (value.length < 8) {
              return 'Vehicle number must be at least 8 characters';
            }
            final RegExp reg = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$');
            if (!reg.hasMatch(value)) {
              return 'Invalid format';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(CustomColors.PURPLE_DARK),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(CustomColors.PURPLE_DARK).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Add Vehicle',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(CustomColors.PURPLE_DARK),
                fontFamily: "Poppins-Bold",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyVehiclesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Iconsax.car,
                    color: Color(CustomColors.GREEN_BUTTON),
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'My Vehicles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(CustomColors.PURPLE_DARK),
                    fontFamily: "Poppins-Bold",
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            isLoadingList
                ? _buildLoadingState()
                : customerVehicleResponseList.isEmpty
                ? _buildEmptyState()
                : _buildVehicleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(CustomColors.GREEN_BUTTON),
                  ),
                  strokeWidth: 3,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              errorMessage != "" ? errorMessage : 'Loading vehicles...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Iconsax.car, size: 32, color: Colors.grey[400]),
            ),
            SizedBox(height: 12),
            Text(
              'No vehicles added yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontFamily: "Poppins",
              ),
            ),
            Text(
              'Add your first vehicle below',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList() {
    List<CustomerVehicleResponse> sortedList = List.from(
      customerVehicleResponseList,
    );
    if (defaultVehicleNo != null) {
      sortedList.sort((a, b) {
        if (a.vehicleNo == defaultVehicleNo) return -1;
        if (b.vehicleNo == defaultVehicleNo) return 1;
        return 0;
      });
    }
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sortedList.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = sortedList[index];
        return History(
          item.customerName ?? "",
          item.vehicleNo,
          item.vehicleType,
          null,
          null,
          null,
          null,
          true,
          getVehicleHistory,
          null,
          isDefault: item.vehicleNo == defaultVehicleNo,
        );
      },
    );
  }

  // Widget _buildAddVehicleSection() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(24),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.08),
  //           spreadRadius: 0,
  //           blurRadius: 30,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(24),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Icon(
  //                   Iconsax.add_circle,
  //                   color: Color(CustomColors.PURPLE_DARK),
  //                   size: 22,
  //                 ),
  //               ),
  //               SizedBox(width: 12),
  //               Text(
  //                 'Add New Vehicle',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w700,
  //                   color: Color(CustomColors.PURPLE_DARK),
  //                   fontFamily: "Poppins-Bold",
  //                 ),
  //               ),
  //             ],
  //           ),
  //           SizedBox(height: 20),
  //           _buildVehicleNumberInput(),
  //           SizedBox(height: 16),
  //           _buildVehicleTypeDropdown(),
  //           SizedBox(height: 24),
  //           _buildSaveButton(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildVehicleNumberInput() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Color(CustomColors.PURPLE_LIGHT).withOpacity(0.05),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.3),
  //         width: 1,
  //       ),
  //     ),
  //     child: Form(
  //       key: _vnumber,
  //       child: TextFormField(
  //         inputFormatters: [UpperCaseTextFormatter()],
  //         controller: vehicleNumberInputController,
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //           fontFamily: "Poppins",
  //         ),
  //         decoration: InputDecoration(
  //           prefixIcon: Container(
  //             padding: EdgeInsets.all(12),
  //             child: Icon(
  //               Iconsax.car,
  //               color: Color(CustomColors.GREEN_BUTTON),
  //               size: 22,
  //             ),
  //           ),
  //           labelStyle: TextStyle(
  //             color: Colors.grey[600],
  //             fontWeight: FontWeight.w500,
  //             fontFamily: "Poppins",
  //           ),
  //           labelText: 'Enter Vehicle Number',
  //           border: InputBorder.none,
  //           enabledBorder: InputBorder.none,
  //           focusedBorder: InputBorder.none,
  //           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //         ),
  //         validator: (value) {
  //           if (value == null || value.isEmpty) {
  //             return 'Please enter vehicle number';
  //           }
  //           if (value.length < 8) {
  //             return 'Vehicle number must be at least 8 characters';
  //           }
  //           final RegExp reg = RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}$');
  //           if (!reg.hasMatch(value)) {
  //             return 'Invalid format';
  //           }
  //           return null;
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildVehicleTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Color(CustomColors.PURPLE_LIGHT).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Iconsax.category,
                color: Color(CustomColors.GREEN_BUTTON),
                size: 22,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: DropdownButton<String>(
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.grey[600],
                ),
                isExpanded: true,
                value: vehicleType,
                hint: Text(
                  'Select Vehicle Type',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                ),
                underline: Container(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontFamily: "Poppins",
                ),
                items: _items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    vehicleType = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: isSaving
          ? Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(CustomColors.GREEN_BUTTON),
                  ),
                  strokeWidth: 3,
                ),
              ),
            )
          : Container(
              width: 240,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(CustomColors.GREEN_BUTTON),
                    Color(CustomColors.GREEN_BUTTON).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_vnumber.currentState!.validate()) {
                    addVehicle(
                      vehicleNumberInputController.text,
                      vehicleType ?? '',
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Save Vehicle',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins-Bold",
                  ),
                ),
              ),
            ),
    );
  }

  void addVehicle(String vehicleNo, String vehicleType) async {
    try {
      if (vehicleType == "") {
        Fluttertoast.showToast(
          msg: 'Select Vehicle Type',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      setState(() {
        isSaving = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.addVehicle(
          AddVehicleRequest(userID!, vehicleNo, vehicleType),
        );

        setState(() {
          customerVehicleResponseList.add(
            CustomerVehicleResponse(
              response.vehicleID,
              vehicleNo,
              vehicleType,
              customerName: '',
            ),
          );
          vehicleNumberInputController.clear();
          vehicleType = '';
          isSaving = false;
        });
        CommonUtil().showToast("Vehicle Added Successfully");
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          String errorMessage = e.response?.data['message'];
          log("errorMessage3---$errorMessage");
          CommonUtil().showToast(errorMessage);
          setState(() {
            isSaving = false;
          });
        } else {
          log("errorMessage4---$errorMessage");
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
          setState(() {
            isSaving = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      log("errorMessage5---$e");
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }

  // Future<String?> _getDefaultVehicleNo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(Constants.VEHICLE_NO);
  // }

  void getVehicleHistory() async {
    log('avf');
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));

      final ApiService apiService = ApiService(dio);

      try {
        final response = await apiService.getCustomerVehicleDetails(userID!);

        Set<String> uniqueVehicle = {};
        List<CustomerVehicleResponse> tempList = [];

        int len = response.customerVehicleList.length;
        for (int i = 0; i < len; i++) {
          String vno = response.customerVehicleList.elementAt(i).vehicleNo;
          if (!uniqueVehicle.contains(vno)) {
            tempList.add(response.customerVehicleList.elementAt(i));
          }
          uniqueVehicle.add(vno);
        }

        if (tempList.isEmpty) {
          setState(() {
            errorMessage = Constants.EMPTY_VEHICLE_LIST;
            isLoadingList = false;
          });
          return;
        }

        String? currentDefaultVehicle = sharedPreferences.getString(
          Constants.VEHICLE_NO,
        );

        setState(() {
          customerVehicleResponseList = tempList;
          isLoadingList = false;
          defaultVehicleNo = currentDefaultVehicle;
        });

        log("getVehicleH$response");
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          log("errorMessage1---${e.response!.data['message']}");
          CommonUtil().showToast(e.response?.data['message']);
          setState(() {
            this.errorMessage = e.response?.data['message'];
            isLoadingList = false;
          });
        } else {
          log("errorMessage2---${Constants.GENERIC_ERROR_MESSAGE}");
          CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
          setState(() {
            isLoadingList = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
        isLoadingList = false;
      });
      log("errorMessage6---$e");
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }
}
