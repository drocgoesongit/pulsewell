import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/helper_class.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/model/doctor_model.dart';
import 'package:pgc/viewmodels/admin_service_upload_veiwmodel.dart';

import 'package:pgc/views/home_screen.dart';

class AddNewDoctorScreen extends StatefulWidget {
  const AddNewDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AddNewDoctorScreen> createState() => _AddNewDoctorScreenState();
}

class _AddNewDoctorScreenState extends State<AddNewDoctorScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _doctorNameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _doctorSpecialityController = TextEditingController();
  TextEditingController _doctorExperienceController = TextEditingController();
  TextEditingController _doctorFeesController = TextEditingController();
  TextEditingController _currentHourController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _appointmentInHoursCountController =
      TextEditingController();
  List<String> _visitingHours = [];
  final List<String> imagePaths = [];
  List<String> _imageUrls = [];
  final List<Uint8List> _imageFilesWeb = [];
  int _appointmentInHoursCount = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _doctorNameController.dispose();
    _aboutController.dispose();
    _doctorSpecialityController.dispose();
    _doctorExperienceController.dispose();
    _doctorFeesController.dispose();
    _currentHourController.dispose();
    _addressController.dispose();
    _appointmentInHoursCountController.dispose();

    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      // Retrieve values from controllers
      String _doctorName = _doctorNameController.text;
      String about = _aboutController.text;
      String _doctorSpeciality = _doctorSpecialityController.text;
      int _doctorExperience = int.parse(_doctorExperienceController.text);
      int _doctorFees = int.parse(_doctorFeesController.text);
      int _currentHour = int.parse(_currentHourController.text);
      String _address = _addressController.text;

      // Upload images to Firebase Storage
      if (kIsWeb) {
        _imageUrls = await AdminServiceViewModel()
            .uploadFilesWeb(_imageFilesWeb, _doctorName);
      } else {
        _imageUrls = await AdminServiceViewModel()
            .uploadImagesMobile(imagePaths, _doctorName);
      }

      DoctorModel doctorModel = DoctorModel(
        doctorName: _doctorName,
        about: about,
        doctorFees: _doctorFees,
        doctorPhotos: _imageUrls,
        doctorId: HelperClass.generateRandomString(),
        doctorExperience: _doctorExperience.toString(),
        doctorSpeciality: _doctorSpeciality,
        hours: _visitingHours,
        appointmentsInHourCount:
            int.parse(_appointmentInHoursCountController.value.text),
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
        title: Text("Add Doctor's detail", style: kSubHeadingTextStyle),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _doctorNameController,
                  decoration: InputDecoration(labelText: 'Doctor Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Doctors name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _aboutController,
                  decoration:
                      InputDecoration(labelText: 'Doctor\s complete detail:'),
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter doctor\'s complete description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _doctorFeesController,
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
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _doctorSpecialityController,
                  decoration: InputDecoration(labelText: 'Doctor speciality'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Doctor speciality';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Doctor address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _appointmentInHoursCountController,
                  decoration: InputDecoration(labelText: 'Appointment Count'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Number of appointment available in one hour';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _doctorExperienceController,
                  decoration: InputDecoration(labelText: 'Year of experience'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Doctor year of experience';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text("Added hours"),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _visitingHours.length,
                    itemBuilder: (context, index) {
                      return Text(_visitingHours[index]);
                    },
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _currentHourController,
                  decoration: InputDecoration(labelText: 'Visiting hours'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Doctor fees';
                    }
                    if (int.tryParse(value)! > 24 || int.tryParse(value)! < 0) {
                      return 'Please enter a valid hour number between 0 - 23';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _visitingHours.add(_currentHourController.text);
                    });
                  },
                  child: Text('Add Hour'),
                ),
                SizedBox(height: 16),
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
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
