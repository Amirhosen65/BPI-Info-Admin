import 'package:flutter/material.dart';
import 'package:send_notice/ImageUpload.dart';
import 'package:send_notice/firbase_crud.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Firebase()));
              }, child: Text("Send Notice")),

            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageUploadScreen()));
            }, child: Text("Image Upload")),

          ],
        ),
      ),
    );
  }
}
