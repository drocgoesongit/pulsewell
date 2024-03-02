import 'package:flutter/material.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/text_const.dart';

class AppointmentCard extends StatelessWidget {
  final String title;
  final String day;
  final String time;
  final String petname;

  const AppointmentCard({
    Key? key,
    required this.title,
    required this.day,
    required this.time,
    required this.petname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      elevation: 0,
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
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image on the extreme left
              Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: TealDarkCustomColor.withOpacity(0.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.calendar_today_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
              // Column of multiple texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: kSmallParaTextStyle.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 14,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              day,
                              style: kSmallParaTextStyle.copyWith(
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "View detail",
                              style: kSmallParaTextStyle.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 12,
                            )
                          ],
                        ),
                      ],
                    ),
                    Text(
                      time,
                      style: kSmallParaTextStyle.copyWith(
                          fontWeight: FontWeight.w500),
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
