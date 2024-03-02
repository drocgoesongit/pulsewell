// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/model/doctor_model.dart';
import 'package:pgc/model/donation_campaign_model.dart';
import 'package:pgc/views/donation_detail_screen.dart';
import 'package:pgc/views/service_detail_screen.dart';

class DonationCard extends StatelessWidget {
  // final DoctorModel model;
  final String image;
  final String name;
  final String disease;
  final String fund;
  final String time;
  final DonationCampaignModel donationCampaignModel;

  const DonationCard({
    Key? key,
    // required this.model,
    required this.image,
    required this.name,
    required this.disease,
    required this.fund,
    required this.time,
    required this.donationCampaignModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DonationDetail(
                      donationModel: donationCampaignModel,
                    )));
      },
      child: Card(
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: softGrayStrokeCustomColor,
            width: 2,
          ),
        ),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image on the extreme left
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Column of multiple texts
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            name,
                            style: kSmallParaTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            disease,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: kSmallParaTextStyle.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                height: 1.1),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                "Fund raised: ",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: kSmallParaTextStyle.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.1),
                              ),
                              Text(
                                fund,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: kSmallParaTextStyle.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    height: 1.1),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time left",
                            style: kSmallParaTextStyle.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            time,
                            style: kSmallParaTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final String donator;
  // final String disease;
  final String fund;
  final String time;

  const PaymentCard({
    Key? key,
    // required this.disease,
    required this.fund,
    required this.time,
    required this.donator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: softGrayStrokeCustomColor,
          width: 2,
        ),
      ),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image on the extreme left
              Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: primaryBlueCustomColor,
                  )),
              SizedBox(
                width: 10,
              ),
              // Column of multiple texts
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          donator,
                          style: kSmallParaTextStyle.copyWith(
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Fund raised: ",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: kSmallParaTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  height: 1.1),
                            ),
                            Text(
                              fund,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: kSmallParaTextStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  height: 1.1),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            time,
                            style: kSmallParaTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
