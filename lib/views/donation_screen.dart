import 'package:flutter/material.dart';
import 'package:pgc/components/donation_rectangle_card.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/views/donation_detail_screen.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

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
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DonationDetail()));
              },
              child: DonationCard(
                  image:
                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fuser-profile&psig=AOvVaw1GkgtcQwYKvq6rh_dibYrv&ust=1709391580503000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKiAj4Gq04QDFQAAAAAdAAAAABAE",
                  name: "Jane D",
                  disease: "HeartAttack",
                  fund: "\$30",
                  time: "12:30:00"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80,
            ),
            DonationCard(
                image:
                    "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fuser-profile&psig=AOvVaw1GkgtcQwYKvq6rh_dibYrv&ust=1709391580503000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKiAj4Gq04QDFQAAAAAdAAAAABAE",
                name: "Jane D",
                disease: "HeartAttack",
                fund: "\$30",
                time: "12:30:00"),
          ],
        ),
      ),
    );
  }
}
