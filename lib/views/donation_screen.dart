import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pgc/components/donation_rectangle_card.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/model/donation_campaign_model.dart';
import 'package:pgc/views/donation_detail_screen.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  List<DonationCampaignModel> campaignList = [];

  Future<List<DonationCampaignModel>> getDonationCampaigns() async {
    List<DonationCampaignModel> campaignModels = [];
    try {
      final donationsCampaings = await FirebaseFirestore.instance
          .collection(Constants.fcDonationCampaigns)
          .where("status", isEqualTo: "active")
          .get();

      donationsCampaings.docs.forEach((service) {
        campaignModels.add(DonationCampaignModel.fromJson(service.data()));
        campaignList.add(DonationCampaignModel.fromJson(service.data()));
      });

      return campaignModels;
    } catch (e) {
      log("donation campaign list getting error: ${e.toString()}");
      return campaignModels;
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
        title: Center(
          child: Text("Donations", style: kSubHeadingTextStyle),
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
          child: FutureBuilder(
            future: getDonationCampaigns(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: campaignList.length,
                    itemBuilder: (context, index) {
                      return DonationCard(
                        image: campaignList[index].patientImage,
                        name: campaignList[index].patientName,
                        disease: campaignList[index].disease,
                        fund: campaignList[index].amountRequired.toString(),
                        time: campaignList[index].deadline,
                        donationCampaignModel: campaignList[index],
                      );
                    },
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Text("error while getting donation campaigns");
              }
            },
          )),
    );
  }
}
