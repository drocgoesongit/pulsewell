import 'package:flutter/material.dart';
import 'package:pgc/components/donation_rectangle_card.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/text_const.dart';

class DonationDetail extends StatelessWidget {
  const DonationDetail({super.key});

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
                Text("Total fund raised: \$40k",
                    style: kSubHeadingTextStyle.copyWith(fontSize: 12)),
                Text("Time remaining: 30:00",
                    style: kSubHeadingTextStyle.copyWith(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Documents",
                style: kSubHeadingTextStyle,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Text(
                "Payment history",
                style: kSubHeadingTextStyle,
              ),
              PaymentCard(
                  image:
                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fuser-profile&psig=AOvVaw1GkgtcQwYKvq6rh_dibYrv&ust=1709391580503000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKiAj4Gq04QDFQAAAAAdAAAAABAE",
                  fund: "50",
                  time: "03:30",
                  donator: "Anonymous"),
              PaymentCard(
                  image:
                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fuser-profile&psig=AOvVaw1GkgtcQwYKvq6rh_dibYrv&ust=1709391580503000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKiAj4Gq04QDFQAAAAAdAAAAABAE",
                  fund: "50",
                  time: "03:30",
                  donator: "Anonymous"),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
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
    );
  }
}
