import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shreeveg/provider/wallet_provider.dart';
import '../../../helper/toast_service.dart';

class RazorPayPaymentScreen extends StatefulWidget {
  final String secretKey;
  final String type;
  final String userId;
  final String amount;
  String contactInfo;
  String email;
  RazorPayPaymentScreen(this.secretKey, this.type, this.userId, this.amount,
      this.contactInfo, this.email,
      {Key? key})
      : super(key: key);

  @override
  RazorPayPaymentScreenState createState() => RazorPayPaymentScreenState();
}

class RazorPayPaymentScreenState extends State<RazorPayPaymentScreen> {
  late Razorpay _razorpay;

  // String razorPayKey = "rzp_live_qXBnJEUNCyvjd3"; //Test Key
  // String razorPayKey = "rzp_test_1DP5mmOlF5G5ag"; //Test Key
  // String razorPayKey = ""; //Live Key

  @override
  void initState() {
    super.initState();
    print(
        "print all data ${widget.amount},${widget.secretKey},${widget.userId},${widget.contactInfo},${widget.email}");
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openCheckout(widget.secretKey, int.parse(widget.amount) * 100, widget.type,
        "INR", widget.email, widget.contactInfo);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Payment",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body: Center(child:
            Consumer<WalletProvider>(builder: (context, walletProvider, child) {
          return Container(
            color: Colors.white,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 5),
                Text(
                  'Processing for payment, please wait...',
                  style: TextStyle(fontWeight: FontWeight.w700),
                )
              ],
            ),
          );
        })));
  }

  void openCheckout(String key, int amount, String type, String currency,
      String email, String contactInfo) async {
    var options = {
      'key': key,
      'amount': amount,
      'name': type,
      "currency": currency,
      'description':
          type == 'Wallet Topup' ? 'WALLET AMOUNT DEPOSIT' : 'PREPAID ORDER',
      'prefill': {'contact': contactInfo, 'email': email},
      "notes": {'id': widget.userId},
      'external': {
        'wallets': ['paytm']
      },
      // "method": {
      //   "netbanking": "0",
      //   "paylater": "0",
      // },
      "notify": {"sms": true, "email": true},
      // "notifyUrl":
      //     "https://api.dzire11.in/wallet/verify-razorpay?coupon=${widget.couponCode}&user_id=${widget.userId}"
    };

    try {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        print("this is try method: $options");
        _razorpay.open(options);
      });
    } catch (e) {
      // debug
      debugPrint("Error razorpay options :${e.toString()}");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('success------------------------');
    if (widget.type == 'Wallet Topup') {
      Provider.of<WalletProvider>(context, listen: false)
          .addToWallet(widget.amount)
          .then((value) =>
              Navigator.of(context).pop({'paymentId': response.paymentId}));
    }
    if (widget.type == 'Prepaid Order') {
      return Navigator.of(context).pop({'paymentId': response.paymentId});
    }
    // BlocProvider.of<UserDataBloc>(context).add(UserDataRefreshEvent());
    // BlocProvider.of<AddCashBloc>(context).add(AddCashRefreshEvent(
    //     widget.amount, response.paymentId ?? "", widget.couponCode));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('failed---------------------------');
    ToastService().show('Payment Failed: Please try again later');
    Navigator.of(context).pop({'paymentId': null});
    // print("ERROR Razorpay: ${response.code} - ${response.message}");
    //
    // // Check if the message is in JSON format
    // if (response.message != null) {
    //   try {
    //     var errorMessage = json.decode(response.message!);
    //     var description = errorMessage['error']['description'];
    //     ToastService().show(description ?? "Payment cancelled");
    //   } catch (e) {
    //     // If decoding fails or fields are not present, show a generic error message
    //     ToastService().show("Payment failed: ${response.message}");
    //   }
    // } else {
    //   // If message is null, show a generic error message
    //   ToastService().show("Payment failed: ${response.message}");
    // }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: ${response.walletName}");
    ToastService().show("EXTERNAL_WALLET: ${response.walletName}");
  }
}
