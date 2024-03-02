import 'package:flutter/material.dart';
import 'package:pgc/components/service_rectangle_card.dart';
import 'package:pgc/constants/color_const.dart';
import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pgc/model/doctor_model.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({Key? key}) : super(key: key);

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  Future<List<DoctorModel>> _fetchServices() async {
    // Change Service to ServiceModel
    final servicesSnapshot = await FirebaseFirestore.instance
        .collection(Constants.fcDoctorNode)
        .get();

    List<DoctorModel> services = [];

    servicesSnapshot.docs.forEach((service) {
      services.add(DoctorModel.fromJson(service.data()));
    });

    return services;
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
          child: Text("All Doctors", style: kMainTitleBoldTextStyle),
        ),
      ),
      body: FutureBuilder<List<DoctorModel>>(
        // Change Service to ServiceModel
        future: _fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final services = snapshot.data;

            return SingleChildScrollView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
              child: Column(
                children: services!.map((service) {
                  return ServiceCard(
                    model: service,
                    image: service.doctorPhotos[0],
                    title: service.doctorName,
                    description: service.about,
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
