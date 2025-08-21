import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/CustomColors.dart';
import '../services/api_service.dart';
import '../utils/Constants.dart';
import '../utils/auth_interceptor.dart';
import '../utils/common_util.dart';

class WalletFragment extends StatefulWidget {
  const WalletFragment({super.key});

  @override
  State<WalletFragment> createState() => _WalletFragmentState();
}

class _WalletFragmentState extends State<WalletFragment> {
  Razorpay razorpay = Razorpay();
  double amount = 0;
  final TextEditingController amountInputController = TextEditingController();
  double walletBalance = 0;
  bool showPaymentSuccessDialog = false;
  bool isLoading = true;
  bool isHistoryLoading = true;
  bool isError = false;
  String errorMessage = "";
  List<PaymentHistoryResponse> paymentHistory = [];
  String? customerName;

  @override
  void initState() {
    super.initState();
    fetchWalletBalance();
    fetchPaymentHistory();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
    amountInputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    'My Wallet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(CustomColors.PURPLE_DARK),
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    customerName ?? 'Hello, Guest',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                      fontFamily: "Poppins",
                    ),
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? _buildLoadingState()
                      : isError
                      ? _buildErrorState()
                      : RefreshIndicator(
                          onRefresh: () async {
                            fetchWalletBalance();
                            fetchPaymentHistory();
                          },
                          color: Color(CustomColors.GREEN_BUTTON),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildWalletBalanceCard(),
                                SizedBox(height: 16),
                                _buildRechargeSection(),
                                SizedBox(height: 16),
                                _buildPaymentHistorySection(),
                                SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                ),
                if (showPaymentSuccessDialog) _buildPaymentSuccessDialog(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Color(CustomColors.PURPLE_DARK).withOpacity(0.1),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(CustomColors.GREEN_BUTTON),
                ),
                strokeWidth: 3.5,
              ),
            ),
          ),
          SizedBox(height: 28),
          Text(
            'Loading wallet details...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
              fontFamily: "Poppins",
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Please wait a moment',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24),
        padding: EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red[400],
                size: 45,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontFamily: "Poppins-Bold",
              ),
            ),
            SizedBox(height: 12),
            Text(
              errorMessage.isNotEmpty
                  ? errorMessage
                  : 'We couldn\'t load your wallet details.\nPlease check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.4,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 28),
            ElevatedButton(
              onPressed: () async {
                fetchWalletBalance();
                fetchPaymentHistory();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(CustomColors.GREEN_BUTTON),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                elevation: 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletBalanceCard() {
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Color(CustomColors.GREEN_BUTTON),
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Balance',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹${walletBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Color(CustomColors.GREEN_BUTTON),
                      fontSize: 24,
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRechargeSection() {
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recharge Wallet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: "Poppins-Bold",
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAmountButton('100'),
                _buildAmountButton('200'),
                _buildAmountButton('500'),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: amountInputController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: "Poppins",
              ),
              decoration: InputDecoration(
                hintText: 'Enter Amount',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontFamily: "Poppins",
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(CustomColors.GREEN_BUTTON),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(CustomColors.GREEN_BUTTON),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(CustomColors.GREEN_BUTTON),
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTapDown: (_) => setState(() {}),
              onTapUp: (_) => setState(() {}),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(1.0),
                child: ElevatedButton(
                  onPressed: startPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(CustomColors.GREEN_BUTTON),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add Money',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    return GestureDetector(
      onTap: () {
        amountInputController.text = amount;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(CustomColors.GREEN_BUTTON),
            width: 1.5,
          ),
          color: amountInputController.text == amount
              ? Color(CustomColors.GREEN_BUTTON).withOpacity(0.1)
              : Colors.white,
        ),
        child: Text(
          amount,
          style: TextStyle(
            color: Color(CustomColors.GREEN_BUTTON),
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHistorySection() {
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment History',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: "Poppins-Bold",
              ),
            ),
            SizedBox(height: 12),
            isHistoryLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(CustomColors.GREEN_BUTTON),
                      ),
                      strokeWidth: 3.5,
                    ),
                  )
                : paymentHistory.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        Icon(Icons.history, color: Colors.grey[400], size: 48),
                        SizedBox(height: 12),
                        Text(
                          'No Payment History',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontFamily: "Poppins-Bold",
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your payment history will appear here',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: paymentHistory.length,
                    itemBuilder: (context, index) {
                      final transaction = paymentHistory[index];
                      final DateTime parsedDate = DateTime.parse(
                        transaction.createdDate,
                      );
                      final String formattedDate = DateFormat(
                        'dd-MM-yyyy',
                      ).format(parsedDate);
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          leading: Icon(
                            Icons.payment,
                            color: Color(CustomColors.GREEN_BUTTON),
                            size: 28,
                          ),
                          title: Text(
                            '₹${transaction.amount}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: "Poppins",
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'Date: $formattedDate',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                ),
                              ),
                              Text(
                                'Location: ${transaction.parkingName}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                transaction.step,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily: "Poppins",
                                ),
                              ),
                              Text(
                                transaction.modeOfPayment,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Color(CustomColors.GREEN_BUTTON),
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSuccessDialog() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(24),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(CustomColors.GREEN_BUTTON).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.check_circle,
                color: Color(CustomColors.GREEN_BUTTON),
                size: 40,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Payment Successful',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                fontFamily: "Poppins-Bold",
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Your wallet has been successfully recharged.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTapDown: (_) => setState(() {}),
              onTapUp: (_) => setState(() {}),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(1.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPaymentSuccessDialog = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(CustomColors.GREEN_BUTTON),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins-Bold",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchWalletBalance() async {
    setState(() {
      isLoading = true;
      isError = false;
      errorMessage = "";
    });
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      customerName = sharedPreferences.getString(Constants.CUSTOMER_NAME) ?? "";
      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken!));
      final ApiService apiService = ApiService(dio);

      final response = await apiService.getWalletDetails(
        sharedPreferences.getString(Constants.USER_ID)!,
      );
      setState(() {
        walletBalance = response.walletAmount;
        isLoading = false;
      });
    } on DioException catch (e) {
      String error =
          e.response?.data['message'] ?? Constants.GENERIC_ERROR_MESSAGE;
      print("errorMessage---$error");
      CommonUtil().showToast(error);
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = error;
      });
    } catch (e) {
      print("Error fetching wallet balance: $e");
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      setState(() {
        isLoading = false;
        isError = true;
        errorMessage = Constants.GENERIC_ERROR_MESSAGE;
      });
    }
  }

  void fetchPaymentHistory() async {
    setState(() {
      isHistoryLoading = true;
    });
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? accessToken = sharedPreferences.getString(Constants.ACCESS_TOKEN);
      String? userID = sharedPreferences.getString(Constants.USER_ID);

      if (accessToken == null || userID == null) {
        print("Access token or user ID is null.");
        setState(() {
          isHistoryLoading = false;
        });
        return;
      }

      final dio = Dio(BaseOptions(contentType: "application/json"));
      dio.interceptors.add(AuthInterceptor(accessToken));
      final apiService = ApiService(dio);

      final response = await apiService.fetchPaymentHistory({"userID": userID});
      if (response['paymentHistoryList'] != null &&
          response['paymentHistoryList'] is List) {
        final paymentHistoryList = (response['paymentHistoryList'] as List)
            .map(
              (item) =>
                  PaymentHistoryResponse.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        setState(() {
          paymentHistory = paymentHistoryList;
          isHistoryLoading = false;
        });
      } else {
        print("Invalid or empty payment history list.");
        setState(() {
          paymentHistory = [];
          isHistoryLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching payment history: $e");
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
      setState(() {
        isHistoryLoading = false;
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    walletBalance += amount;
    amountInputController.clear();
    amount = 0;
    setState(() {
      showPaymentSuccessDialog = true;
    });
    fetchWalletBalance(); // Refresh balance after successful payment
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Error-->${response.error}");
    CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
  }

  // Add this state variable if not present, but since it's not, add to _WalletFragmentState
  bool isPaymentProcessing = false;

  // Update the startPayment function to this:
  void startPayment() async {
    if (amountInputController.text.trim().isEmpty) {
      CommonUtil().showToast('Please Enter Amount');
      return;
    }

    try {
      amount = double.parse(amountInputController.text.trim());
    } catch (e) {
      CommonUtil().showToast('Please enter a valid number');
      return;
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String mobileNo =
        sharedPreferences.getString(Constants.MOBILE_NUMBER) ?? "";

    try {
      // Show loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(CustomColors.GREEN_BUTTON),
                ),
                strokeWidth: 3.5,
              ),
            ),
          ),
        ),
      );

      final dio = Dio();
      final response = await dio.post(
        "https://xkzd75f5kd.execute-api.ap-south-1.amazonaws.com/prod/razorpay-create-order",
        data: {
          "amount": 20,
          "payment_capture": 1,
          "mobileNo": mobileNo,
          "userId": sharedPreferences.getString(Constants.USER_ID),
        },
      );
      final orderId = response.data["id"];

      // Dismiss loader
      Navigator.pop(context);

      // Pass order_id to Razorpay SDK
      var options = {
        'key': 'rzp_live_MhFMxh3USLjA7x',
        'amount': amount * 100,
        'name': 'Parkey India',
        'description': 'Add Money To Wallet',
        'order_id': orderId, // required for auto-capture
        'prefill': {'contact': mobileNo},
        'notes': {'userID': sharedPreferences.getString(Constants.USER_ID)},
        'theme': {'color': '#458274'},
      };

      razorpay.open(options);
    } on DioException catch (e) {
      // Dismiss loader on error
      if (context.mounted) {
        Navigator.pop(context);
      }
      log("Error creating order: ${e.response?.data}");
      CommonUtil().showToast("Failed to create order");
    } catch (e) {
      // Dismiss loader on other errors
      if (context.mounted) {
        Navigator.pop(context);
      }
      log("Unexpected error: $e");
      CommonUtil().showToast(Constants.GENERIC_ERROR_MESSAGE);
    }
  }
}

class PaymentHistoryResponse {
  final String amount;
  final String createdDate;
  final String parkingName;
  final String step;
  final String modeOfPayment;

  PaymentHistoryResponse({
    required this.amount,
    required this.createdDate,
    required this.parkingName,
    required this.step,
    required this.modeOfPayment,
  });

  factory PaymentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponse(
      amount: json['amount']?.toString() ?? '0',
      createdDate: json['createdDate'] ?? '',
      parkingName: json['parkingName'] ?? 'Unknown',
      step: json['step'] ?? '',
      modeOfPayment: json['modeOfPayment'] ?? '',
    );
  }
}
