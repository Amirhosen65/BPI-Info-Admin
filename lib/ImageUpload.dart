import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _uploading = false;

  Future<void> _selectImage() async {
    final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _selectedImage = pickedImage != null ? File(pickedImage.path) : null;
    });
  }



  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Empty Image. First select an image.')),
      );
      return;
    }

    setState(() {
      _uploading = true;
    });

    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref().child('images/$imageName.jpg');
    final uploadTask = storageRef.putFile(_selectedImage!);

    try {
      final snapshot = await uploadTask;
      if (snapshot.state == TaskState.success) {
        // Image uploaded successfully
        final downloadUrl = await snapshot.ref.getDownloadURL();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully.')),
        );
        // Clear the selected image
        setState(() {
          _selectedImage = null;
        });
      } else {
        // Handle error during image upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed with state: ${snapshot.state}')),
        );
      }
    } catch (e) {
      // Handle any exceptions that occurred during image upload
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed with error: $e')),
      );
    }

    setState(() {
      _uploading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
              ),
            IconButton(
              icon: Icon(Icons.camera, size: 50),
              onPressed: _selectImage,
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: _uploading ? null : _uploadImage,
              child: _uploading
                  ? CircularProgressIndicator()
                  : Text('Upload Image'),
            ),

            SizedBox(height: 50,),
            ElevatedButton(onPressed: (){
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => ImageGallery () ));
            }, child: Text("Image Gallery")),

            // ElevatedButton(onPressed: (){
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => Firebase_ImagePicker () ));
            // }, child: Text("Image Picker")),

          ],
        ),
      ),
    );
  }
}
