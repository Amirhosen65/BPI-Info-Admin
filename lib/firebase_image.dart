import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Firebase_ImagePicker extends StatefulWidget {
  const Firebase_ImagePicker({Key? key}) : super(key: key);

  @override
  _Firebase_ImagePickerState createState() => _Firebase_ImagePickerState();
}

class _Firebase_ImagePickerState extends State<Firebase_ImagePicker> {
  ImagePicker image = ImagePicker();
  File? file;
  String uri = "";

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  uploadFile() async {
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    var imagefile = FirebaseStorage.instance.ref().child(imageName).child("/.jpg");
    UploadTask task = imagefile.putFile(file!);
    TaskSnapshot snapshot = await task;

    // for download the image
    uri = await snapshot.ref.getDownloadURL();

    /// store the image url into the firestore database
    await FirebaseFirestore.instance
        .collection("images")
        .doc()
        .set({"imageUrl": uri});
    // print(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),

              InkWell(
                onTap: () {
                  getImage();
                },
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: file == null
                        ? AssetImage("")
                        : FileImage(File(file!.path)) as ImageProvider,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  onPressed: () {
                    uploadFile();
                  },
                  child: Text("Upload Image")),
              //// show the image into the app

              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("images")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(snapshot.hasData) {
                      return GridView.builder(
                        // shrinkWrap: true,
                        // physics: ScrollPhysics(),
                        // primary: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 5,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[i];
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            View(url: x['imageUrl'],
                                            )));
                              },
                              child: Hero(
                                tag: x['imageUrl'],
                                child: Card(
                                  child: Image.network(
                                    x['imageUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class View extends StatelessWidget {
  final url;

  View({this.url});

  @override
  Widget build(BuildContext context) {
    return Hero(tag: url, child: Image.network(url));
  }
}
