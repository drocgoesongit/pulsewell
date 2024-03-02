import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pgc/constants/color_const.dart';

import 'package:pgc/constants/const.dart';
import 'package:pgc/constants/helper_class.dart';
import 'package:pgc/constants/text_const.dart';
import 'package:pgc/model/donation_campaign_model.dart';
import 'package:pgc/viewmodels/admin_service_upload_veiwmodel.dart';

class NewDonationCampaignScreen extends StatefulWidget {
  const NewDonationCampaignScreen({Key? key}) : super(key: key);

  @override
  State<NewDonationCampaignScreen> createState() =>
      _NewDonationCampaignScreenState();
}

class _NewDonationCampaignScreenState extends State<NewDonationCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  TextEditingController _deadlineController = TextEditingController();
  TextEditingController _amountRequiredController = TextEditingController();
  TextEditingController _consultingDoctorController = TextEditingController();
  TextEditingController _hospitalNameController = TextEditingController();
  List<String> _prescriptionImages = [];
  List<String> _patientImages = [];
  final List<Uint8List> _prescriptionImageFilesWeb = [];
  final List<String> _prescriptionImagePath = [];
  final List<Uint8List> _patientImageFilesWeb = [];
  final List<String> _patientImagePath = [];
  bool _isLoading = false;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _patientNameController.dispose();
    _descriptionController.dispose();
    _diseaseController.dispose();
    _deadlineController.dispose();
    _amountRequiredController.dispose();
    _consultingDoctorController.dispose();
    _hospitalNameController.dispose();

    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      // Upload patient images and prescription images to Firebase Storage
      if (kIsWeb) {
        _prescriptionImages =
            await _uploadImagesWeb(_prescriptionImageFilesWeb);
        String imageUrl = await AdminServiceViewModel().uploadSingleFileWeb(
            _patientImageFilesWeb[0],
            "${Constants.fcDonationCampaigns}/${_patientNameController.text}");

        _patientImages.add(imageUrl);
      } else {
        // For mobile, implement the method to pick and upload images
      }

      DonationCampaignModel campaignModel = DonationCampaignModel(
          donationId: HelperClass.generateRandomString(),
          patientName: _patientNameController.value.text,
          patientImage: _patientImages[0],
          description: _descriptionController.value.text,
          disease: _descriptionController.value.text,
          deadline: _deadlineController.value.text,
          amountRequired: int.parse(_amountRequiredController.value.text),
          prescriptionImages: _prescriptionImages,
          consultingDoctor: _consultingDoctorController.value.text,
          hospitalName: _hospitalNameController.value.text,
          status: "active",
          totalFundRaised: 0,
          donations: []);

      // Upload campaign data to Firestore
      await FirebaseFirestore.instance
          .collection(Constants.fcDonationCampaigns)
          .doc(campaignModel.donationId)
          .set(campaignModel.toJson());

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
            content: Text('Donation campaign created successfully'),
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _uploadImagesWeb(List<Uint8List> imageFiles) async {
    List<String> downloadUrls = [];
    AdminServiceViewModel()
        .uploadFilesWebWithRef(imageFiles,
            "${Constants.fcDonationCampaigns}/${_patientNameController.text}")
        .then((value) {
      downloadUrls.addAll(value);
    }).catchError((e) {
      print('Failed to upload files: $e');
    });
    return []; // Placeholder, replace with actual implementation
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _deadlineController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: primaryBlueSoftenCustomColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "New Donation Campaign",
          style: kMainTitleBoldTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: softGrayStrokeCustomColor,
                          width: 2,
                        )),
                  ),
                  child: TextFormField(
                    controller: _patientNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: TealLightCustomColor,
                      labelStyle: kSmallParaTextStyle,
                      labelText: 'Patient Name',
                      border: InputBorder.none, // Remove the border
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter patient name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: softGrayStrokeCustomColor,
                          width: 2,
                        )),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description of Condition',
                      labelStyle: kSmallParaTextStyle,
                      filled: true,
                      fillColor: TealLightCustomColor,
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: softGrayStrokeCustomColor,
                          width: 2,
                        )),
                  ),
                  child: TextFormField(
                    controller: _diseaseController,
                    decoration: InputDecoration(
                      labelText: 'Disease',
                      labelStyle: kSmallParaTextStyle,
                      filled: true,
                      fillColor: TealLightCustomColor,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter disease';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: softGrayStrokeCustomColor,
                          width: 2,
                        )),
                  ),
                  child: TextFormField(
                    controller: _deadlineController,
                    decoration: InputDecoration(
                      labelText: 'Deadline',
                      labelStyle: kSmallParaTextStyle,
                      filled: true,
                      fillColor: TealLightCustomColor,
                      border: InputBorder.none,
                    ),
                    onTap: () => _selectDate(context),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select deadline';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: softGrayStrokeCustomColor,
                          width: 2,
                        )),
                  ),
                  child: TextFormField(
                    controller: _amountRequiredController,
                    decoration: InputDecoration(
                      labelText: 'Amount Required',
                      labelStyle: kSmallParaTextStyle,
                      filled: true,
                      fillColor: TealLightCustomColor,
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount required';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: softGrayStrokeCustomColor,
                          width: 2,
                        )),
                  ),
                  child: TextFormField(
                    controller: _consultingDoctorController,
                    decoration: InputDecoration(
                      labelText: 'Consulting Doctor Name',
                      labelStyle: kSmallParaTextStyle,
                      filled: true,
                      fillColor: TealLightCustomColor,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter consulting doctor name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: ContinuousRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        side: BorderSide(
                          color: softGrayStrokeCustomColor,
                          width: 2,
                        )),
                  ),
                  child: TextFormField(
                    controller: _hospitalNameController,
                    decoration: InputDecoration(
                      labelText: 'Hospital Name',
                      labelStyle: kSmallParaTextStyle,
                      filled: true,
                      fillColor: TealLightCustomColor,
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter hospital name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 40,
                  // width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kIsWeb) {
                        AdminServiceViewModel()
                            .pickMultipleImagesWeb(context)
                            .then((value) {
                          setState(() {
                            _prescriptionImageFilesWeb.addAll(value);
                          });
                        });
                      } else {
                        AdminServiceViewModel()
                            .pickMultipleImagesMobile(context)
                            .then((value) {
                          setState(() {
                            _prescriptionImagePath
                                .addAll(value.map((e) => e.path).toList());
                          });
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: TealCustomButtonlightColor, // Your desired color
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      // fixedSize: Size.fromHeight(58), // Your desired height
                    ),
                    child: Text(
                      'Add Prescription Images',
                      style: kSmallParaTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      if (kIsWeb) {
                        AdminServiceViewModel()
                            .pickMultipleImagesWeb(context)
                            .then((value) {
                          setState(() {
                            _patientImageFilesWeb.addAll(value);
                          });
                        });
                      } else {
                        AdminServiceViewModel()
                            .pickMultipleImagesMobile(context)
                            .then((value) {
                          setState(() {
                            _patientImagePath
                                .addAll(value.map((e) => e.path).toList());
                          });
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: TealCustomButtonlightColor, // Your desired color
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      // fixedSize: Size.fromHeight(58), // Your desired height
                    ),
                    child: Text(
                      'Add Patient Image',
                      style: kSmallParaTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Submit',
                            style: kSmallParaTextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                    style: ElevatedButton.styleFrom(
                      primary: TealCustomButtonlightColor, // Your desired color
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      // fixedSize: Size.fromHeight(58), // Your desired height
                    ),
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
