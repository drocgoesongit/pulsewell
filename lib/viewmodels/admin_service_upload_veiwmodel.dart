import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pgc/constants/const.dart';

class AdminServiceViewModel {
  Future<List<Uint8List>> pickMultipleImagesWeb(BuildContext context) async {
    List<Uint8List> selectedImages = [];

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        selectedImages.addAll(result.files.map((file) => file.bytes!));
      }
      log("image added as files in add product screen length is ${selectedImages.length}");
    } catch (e) {
      print('Error picking multiple images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking multiple images'),
        ),
      );
    }

    return selectedImages;
  }

  Future<List<String>> uploadFilesWeb(
      List<Uint8List> _imageFilesWeb, String serviceName) async {
    List<String> downloadUrls = [];

    try {
      for (int i = 0; i < _imageFilesWeb.length; i++) {
        Uint8List file = _imageFilesWeb[i];
        String fileName = '${i + 1}.png';
        String storageRef =
            '${Constants.fcDoctorPhotos}/$serviceName/$fileName';
        Reference ref = FirebaseStorage.instance.ref(storageRef);
        UploadTask uploadTask = ref.putData(file);

        // Wait until the file is uploaded
        await uploadTask;

        // Get the download URL
        final String downloadURL = await ref.getDownloadURL();

        // Store the download URL in the imageUrls list
        downloadUrls.add(downloadURL);
      }
    } catch (e) {
      // Handle any errors
      print('Failed to upload files: $e');
    }

    return downloadUrls;
  }

  Future<List<File>> pickMultipleImagesMobile(BuildContext context) async {
    List<File> selectedImages = [];

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        selectedImages.addAll(files);
      }
      log("image added as files in add product screen length is ${selectedImages.length}");
    } catch (e) {
      print('Error picking multiple images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking multiple images'),
        ),
      );
    }

    return selectedImages;
  }

  Future<List<String>> uploadImagesMobile(
      List<String> imagePaths, String serviceName) async {
    List<String> imageUrls = [];

    // Upload images to Firebase Storage
    for (int i = 0; i < imagePaths.length; i++) {
      File imageFile = File(imagePaths[i]);
      String fileName = '${i + 1}.png';
      String storageRef = '${Constants.fcDoctorPhotos}/$serviceName/$fileName';

      // Upload image to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(storageRef)
          .putFile(imageFile);

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Add the download URL to the imageUrls list
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<List<String>> uploadFilesWebWithRef(
      List<Uint8List> _imageFilesWeb, String storageRef) async {
    List<String> downloadUrls = [];

    try {
      for (int i = 0; i < _imageFilesWeb.length; i++) {
        Uint8List file = _imageFilesWeb[i];
        String fileName = '${i + 1}.png';

        Reference ref = FirebaseStorage.instance.ref('$storageRef/$fileName');
        UploadTask uploadTask = ref.putData(file);

        // Wait until the file is uploaded
        await uploadTask;

        // Get the download URL
        final String downloadURL = await ref.getDownloadURL();

        // Store the download URL in the imageUrls list
        downloadUrls.add(downloadURL);
      }
    } catch (e) {
      // Handle any errors
      print('Failed to upload files: $e');
    }

    return downloadUrls;
  }

  Future<String> uploadSingleFileWeb(Uint8List file, String storageRef) async {
    String downloadUrl = '';

    try {
      Reference ref = FirebaseStorage.instance.ref(storageRef);
      UploadTask uploadTask = ref.putData(file);

      // Wait until the file is uploaded
      await uploadTask;

      // Get the download URL
      downloadUrl = await ref.getDownloadURL();
    } catch (e) {
      // Handle any errors
      print('Failed to upload file: $e');
    }

    return downloadUrl;
  }

  Future<List<String>> uploadImagesMobileWithRef(
      List<String> imagePaths, String storageRef) async {
    List<String> imageUrls = [];

    // Upload images to Firebase Storage
    for (int i = 0; i < imagePaths.length; i++) {
      File imageFile = File(imagePaths[i]);
      String fileName = '${i + 1}.png';

      // Upload image to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child(storageRef)
          .child(fileName)
          .putFile(imageFile);

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Add the download URL to the imageUrls list
      imageUrls.add(downloadUrl);
    }

    return imageUrls;
  }

  Future<Uint8List> pickSingleImageWeb(BuildContext context) async {
    Uint8List selectedImage = Uint8List(0);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        selectedImage = result.files.first.bytes!;
      }
      log("image added insingle web pick is ${selectedImage.length}");
    } catch (e) {
      print('Error picking multiple images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking single web images'),
        ),
      );
    }

    return selectedImage;
  }
}
