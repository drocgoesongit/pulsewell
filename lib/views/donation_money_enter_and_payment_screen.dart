import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/helper_class.dart';
import 'package:pgc/model/donation_campaign_model.dart';
import 'package:pgc/model/donation_model.dart';
import 'package:pgc/model/user_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class EnterAndPayDonationScreen extends StatefulWidget {
  const EnterAndPayDonationScreen(
      {Key? key, required this.donationCampaignModel})
      : super(key: key);
  final DonationCampaignModel donationCampaignModel;

  @override
  State<EnterAndPayDonationScreen> createState() =>
      _EnterAndPayDonationScreenState();
}

class _EnterAndPayDonationScreenState extends State<EnterAndPayDonationScreen> {
  late TextEditingController _amountController;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Handle payment success
    print("Payment Success: ${response.paymentId}");
    UserModel user;

    FirebaseFirestore.instance
        .collection(Constants.fcUsers)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data() as Map<String, dynamic>);
    });

    // // Create donation model and save to Firestore
    // UserModel user = UserModel(); // Initialize user with a default value
    // FirebaseFirestore.instance.collection(Constants.fcUsers).doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
    //   user = UserModel.fromJson(value.data() as Map<String, dynamic>);
    // });
    String paymentId = HelperClass.generateRandomString();
    DonationModel donationModel = DonationModel(
      amount: int.tryParse(_amountController.text) ?? 0,
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      userid: FirebaseAuth.instance.currentUser!.uid,
      paymentid: paymentId,
      donationId: widget.donationCampaignModel.donationId,
      donorName: "Jane D",
    );

    FirebaseFirestore.instance
        .collection('donations')
        .doc(paymentId)
        .set(donationModel.toMap());

    FirebaseFirestore.instance
        .collection(Constants.fcDonationCampaigns)
        .doc(widget.donationCampaignModel.donationId)
        .update({
      'totalFundRaised': widget.donationCampaignModel.totalFundRaised +
              int.parse(_amountController.text) ??
          0
    });

    FirebaseFirestore.instance
        .collection(Constants.fcDonationCampaigns)
        .doc(donationModel.donationId)
        .update({
      'donations': FieldValue.arrayUnion([paymentId])
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print("Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection
    print("External Wallet: ${response.walletName}");
  }

  void _startPayment() {
    int amount = int.tryParse(_amountController.text) ?? 0;
    if (amount > 0) {
      var options = {
        'key': 'rzp_test_uj5csPT8ukw8hI',
        'amount':
            amount * 100, // Convert amount to smallest currency unit (in paisa)
        'name': 'Donation',
        'description': 'Donate for a cause',
        'prefill': {
          'contact': '',
          'email': '',
        },
        'external': {
          'wallets': ['paytm']
        }
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        print("Error during payment: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Donation Amount'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Enter Amount'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startPayment,
              child: Text('Donate'),
            ),
          ],
        ),
      ),
    );
  }
}
