import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pgc/components/review_card.dart';
import 'package:pgc/constants/text_const.dart';

class StaticSectionHomeScreen extends StatelessWidget {
  const StaticSectionHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brand values",
          style: kSubHeadingTextStyle.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 60,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageTextContainer(
              imagePath: 'assets/images/brandval1.png',
              text: 'Quality Care',
              smalltext: "We genuinly love and care for our customers.",
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 10,
            ),
            const ImageTextContainer(
              imagePath: 'assets/images/brandval2.png',
              text: 'Proffesionalism',
              smalltext:
                  "Our skilled doctors prioritize safety, quality, and excellence",
            ),
          ],
        ),
      ],
    );
  }

  imageContainer(imgPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.46),
      child: Image.asset(
        imgPath,
        fit: BoxFit.cover,
      ),
    );
  }
}
