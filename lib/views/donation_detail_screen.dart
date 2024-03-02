import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pgc/components/donation_rectangle_card.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/model/donation_campaign_model.dart';
import 'package:pgc/model/donation_model.dart';
import 'package:pgc/views/donation_money_enter_and_payment_screen.dart';
import 'package:pgc/views/signin_screen.dart';

class DonationDetail extends StatefulWidget {
  const DonationDetail({super.key, required this.donationModel});
  final DonationCampaignModel donationModel;

  @override
  State<DonationDetail> createState() => _DonationDetailState();
}

class _DonationDetailState extends State<DonationDetail> {
  List<DonationModel> donations = [];

  Future<List<DonationModel>> getDonations() async {
    try {
      final donationsSnapshot = await FirebaseFirestore.instance
          .collection(Constants.fcDonations)
          .where("donationId", isEqualTo: widget.donationModel.donationId)
          .get();

      donationsSnapshot.docs.forEach((element) {
        donations.add(DonationModel.fromMap(element.data()));
      });

      return donations;
    } catch (e) {
      log("error in getting donations: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: primaryBlueSoftenCustomColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Donations", style: kMainTitleBoldTextStyle),
            Column(
              children: [
                Text(
                    "Total fund raised: \$ ${widget.donationModel.totalFundRaised}",
                    style: kSubHeadingTextStyle.copyWith(fontSize: 12)),
                Text("Goal: \$ ${widget.donationModel.amountRequired}",
                    style: kSubHeadingTextStyle.copyWith(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Information",
                  style: kSubHeadingTextStyle,
                ),
                Container(
                  height: 80,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Text(
                  "Payment history",
                  style: kSubHeadingTextStyle,
                ),
                Expanded(
                  child: FutureBuilder<List<DonationModel>>(
                    future: getDonations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (donations.isEmpty) {
                          return Center(
                            child: Text("No donations yet"),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: donations.length,
                            itemBuilder: (context, index) {
                              return PaymentCard(
                                fund: donations[index].amount.toString(),
                                donator: donations[index].userid,
                                time: donations[index].time,
                              );
                            },
                          );
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Text("error while getting donation campaigns");
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EnterAndPayDonationScreen(
                                  donationCampaignModel: widget.donationModel)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please login to donate"),
                          ),
                        );

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF877FFA), // Your desired color
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      // fixedSize: Size.fromHeight(58), // Your desired height
                    ),
                    child: Text(
                      "Donate",
                      style: kButtonBigTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
