import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/helper_class.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/model/doctor_model.dart';
import 'package:pgc/viewmodels/admin_service_upload_veiwmodel.dart';
import 'dart:io';

import 'package:pgc/views/home_screen.dart';

class AddNewServiceScreen extends StatefulWidget {
  const AddNewServiceScreen({Key? key}) : super(key: key);

  @override
  State<AddNewServiceScreen> createState() => _AddNewServiceScreenState();
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _doctorName = '';
  String about = '';
  String _doctorSpeciality = '';
  int _doctorExperience = 0;
  List<String> _visitingHours = [];
  int _currentHour = 0;
  int _doctorFees = 0;
  final List<String> imagePaths = [];
  List<String> _imageUrls = [];
  final List<Uint8List> _imageFilesWeb = [];
  int _appointmentInHoursCount = 0;
  bool _isLoading = false;
  String _address = "";

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      String serviceIdentifier = HelperClass.generateRandomString();

      // Upload images to Firebase Storage
      if (kIsWeb) {
        _imageUrls = await AdminServiceViewModel()
            .uploadFilesWeb(_imageFilesWeb, _doctorName);
      } else {
        _imageUrls = await AdminServiceViewModel()
            .uploadImagesMobile(imagePaths, _doctorName);
      }

      // Create service model
      DoctorModel doctorModel = DoctorModel(
        doctorName: _doctorName,
        about: about,
        doctorFees: _doctorFees,
        doctorPhotos: _imageUrls,
        doctorId: serviceIdentifier,
        doctorExperience: _doctorExperience.toString(),
        doctorSpeciality: _doctorSpeciality,
        hours: _visitingHours,
        appointmentsInHourCount: _appointmentInHoursCount,
        address: _address,
      );

      // Check if imageUrls list is empty
      if (_imageUrls.isEmpty) {
        await Future.delayed(Duration(seconds: 5));
        if (_imageUrls.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('No Images'),
                content: Text('Failed to upload images. No images selected.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }

      // Upload service to Firestore
      await FirebaseFirestore.instance
          .collection(Constants.fcDoctorNode)
          .doc(doctorModel.doctorId)
          .set(doctorModel.toJson());

      // Show success message or navigate to next screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48,
            ),
            content: Text('Doctors detail upload successful'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add New Service", style: kSubHeadingTextStyle),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Service Name
              TextFormField(
                decoration: InputDecoration(labelText: 'Doctor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Doctors name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _doctorName = value!;
                },
              ),
              SizedBox(height: 16),
              // Service Description
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Doctor\s complete detail:'),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter doctor\'s complete description';
                  }
                  return null;
                },
                onSaved: (value) {
                  about = value!;
                },
              ),
              SizedBox(height: 16),
              // Service Fees
              TextFormField(
                decoration: InputDecoration(labelText: 'Doctor Fees'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Doctor fees';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _doctorFees = int.parse(value!);
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Doctor speciality'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Doctor speciality';
                  }

                  return null;
                },
                onSaved: (value) {
                  _doctorSpeciality = value!;
                },
              ),

              Text("Added hours"),
              ListView.builder(itemBuilder: (context, index) {
                return Text(_visitingHours[index]);
              }),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Visiting hours'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Doctor fees';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (int.tryParse(value)! > 24 || int.tryParse(value)! < 0) {
                    return 'Please enter a valid hour number between 0 - 23';
                  }
                  return null;
                },
                onSaved: (value) {
                  _currentHour = int.parse(value!);
                },
              ),
              SizedBox(height: 16),

              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _visitingHours.add(_currentHour.toString());
                    });
                  },
                  child: Text('Add Hour')),

              // Image Upload
              ElevatedButton(
                onPressed: () {
                  if (kIsWeb) {
                    AdminServiceViewModel()
                        .pickMultipleImagesWeb(context)
                        .then((value) {
                      setState(() {
                        _imageFilesWeb.addAll(value);
                      });
                    });
                  } else {
                    AdminServiceViewModel()
                        .pickMultipleImagesMobile(context)
                        .then((value) {
                      setState(() {
                        imagePaths.addAll(value.map((e) => e.path).toList());
                      });
                    });
                  }
                },
                child: Text('Add Photos'),
              ),
              SizedBox(height: 16),
              // Submit Button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child:
                    _isLoading ? CircularProgressIndicator() : Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
