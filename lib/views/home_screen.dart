import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pgc/admin_views/add_new_doctor_screen_admin.dart';
import 'package:pgc/admin_views/all_appointments_screen.dart';
import 'package:pgc/admin_views/customer_detail_screen.dart';
import 'package:pgc/admin_views/new_donation_campaign_screen.dart';
import 'package:pgc/components/appointment_rectangle_card.dart';
import 'package:pgc/components/home_screen_static_section.dart';
import 'package:pgc/components/review_card.dart';
import 'package:pgc/components/service_square_card.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pgc/model/appointment_model.dart';
import 'package:pgc/model/doctor_model.dart';
import 'package:pgc/viewmodels/chat_viewmodel.dart';
import 'package:pgc/views/all_services_screen.dart';
import 'package:pgc/views/dashboard_screen.dart';
import 'package:pgc/views/chat_screen.dart';
import 'package:pgc/views/donation_screen.dart';
import 'package:pgc/views/profile_screen.dart';
import 'package:pgc/views/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DoctorModel> doctorsList = [];
  List<AppointmentModel> appointments = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<DoctorModel>> getServices() async {
    final servicesSnapshot = await FirebaseFirestore.instance
        .collection(Constants.fcDoctorNode)
        .get();
    int count = servicesSnapshot.docs.length;
    servicesSnapshot.docs.forEach((service) {
      if (doctorsList.length < count) {
        doctorsList.add(DoctorModel.fromJson(service.data()));
      }
    });

    return doctorsList;
  }

  Future<List<AppointmentModel>> getUpcomingAppointmentForUser() async {
    try {
      await FirebaseFirestore.instance
          .collection(Constants.fcAppointments)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('apptStatus', isEqualTo: Constants.appointmentActive)
          .get()
          .then((querySnapshot) {
        int count = querySnapshot.docs.length;
        querySnapshot.docs.forEach((doc) {
          if (appointments.length < count) {
            appointments.add(AppointmentModel.fromJson(doc.data()));
          }
        });
      });
      return appointments;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        key: _scaffoldKey, // Set the key for the Scaffold

        drawer: NavigationDrawer(
          tilePadding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
          children: [
            ListTile(
              leading: Container(
                  height: 25,
                  width: 25,
                  child: SvgPicture.asset('assets/images/logo.svg')),
              title: Text(
                'Pulse Well',
                style: kMainTitleBoldTextStyle.copyWith(fontSize: 18),
              ),
              onTap: () {
                // Handle drawer item tap
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bar_chart_rounded,
                color: TealThemeCustomColor,
              ),
              title: Text(
                'Appointments',
                style: kSubHeadingTextStyle,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.monitor_heart_outlined,
                color: TealThemeCustomColor,
              ),
              title: Text(
                'Donations',
                style: kSubHeadingTextStyle,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DonationScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person_add_alt_1_outlined,
                color: TealThemeCustomColor,
              ),
              title: Text(
                'Add Doctors',
                style: kSubHeadingTextStyle,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewDoctorScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle_outline_rounded,
                color: TealThemeCustomColor,
              ),
              title: Text(
                'Add Donations',
                style: kSubHeadingTextStyle,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewDonationCampaignScreen()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chat_outlined,
                color: TealThemeCustomColor,
              ),
              title: Text(
                'Chats',
                style: kSubHeadingTextStyle,
              ),
              onTap: () {
                // Handle drawer item tap
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                color: TealThemeCustomColor,
              ),
              title: Text(
                'Log out',
                style: kSubHeadingTextStyle,
              ),
              onTap: () {
                // Handle drawer item tap
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Column(
              children: [
                ClipPath(
                  clipper: const ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60))),
                  ),
                  child: Container(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: TealThemeCustomColor,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      // bring nav drawer
                                      _scaffoldKey.currentState?.openDrawer();
                                    },
                                    child: Image.asset(
                                        "assets/images/filter.png")),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 18,
                                ),
                                Text(
                                  "Pulse Well",
                                  style: kSmallParaTextStyle.copyWith(
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20.0), // Add some bottom padding
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (FirebaseAuth.instance.currentUser !=
                                            null) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: TealThemeCustomColor,
                                                    strokeWidth: 2.0,
                                                  )),
                                                );
                                              });
                                          String userId = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          String isChatAvailable =
                                              await ChatViewModel().getChat();

                                          if (isChatAvailable == 'success') {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatDetailScreen(
                                                          chatPlusUserId:
                                                              userId,
                                                        )));
                                          } else {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Error: Chat not available'),
                                              ),
                                            );
                                          }
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text("Error"),
                                                    content: const Text(
                                                        "You need to be logged in to access this feature."),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const LoginScreen()));
                                                        },
                                                        child: Text("OK"),
                                                      )
                                                    ],
                                                  ));
                                        }
                                      },
                                      child: Text(
                                        "Your heart's\nBestfriend!",
                                        style: kMainTitleBoldTextStyle.copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        child: SvgPicture.asset(
                                            "assets/images/docbro2.svg"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ServicesListScreen()));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      TealCustomButtonlightColor, // Your desired color
                                  shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  // fixedSize: Size.fromHeight(58), // Your desired height
                                ),
                                child: Text(
                                  "Book Appointment",
                                  style: kButtonBigTextStyle.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Doctors",
                          style: kSubHeadingTextStyle,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ServicesListScreen()));
                          },
                          child: Row(
                            children: [
                              Text(
                                "View all",
                                style: kSmallParaTextStyle.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(
                                Icons.arrow_forward_outlined,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 80,
                    ),
                    FutureBuilder(
                        future: getServices(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height / 6.5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: doctorsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ServiceSquareCard(
                                    model: doctorsList[index],
                                  );
                                },
                              ),
                            );
                          }
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    Text(
                      "Upcoming appointments",
                      style: kSubHeadingTextStyle.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                    FutureBuilder(
                        future: getUpcomingAppointmentForUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: appointments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return AppointmentCard(
                                    title: appointments[index].username,
                                    day: appointments[index].apptDate,
                                    time: appointments[index].apptTime,
                                    petname: appointments[index].username);
                              },
                            );
                          }
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 60,
                    ),
                    StaticSectionHomeScreen(),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
