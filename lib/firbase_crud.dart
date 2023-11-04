import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


class Firebase extends StatefulWidget {
  const Firebase({Key? key}) : super(key: key);

  @override
  _FirebaseState createState() => _FirebaseState();

  static initializeApp() {}
}

class _FirebaseState extends State<Firebase> {

  TextEditingController notice=TextEditingController();
  TextEditingController notice_details=TextEditingController();
  final firebase = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  void initializeFirebase() async {
    await Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }


  create() async {
    try {
      await firebase
          .collection("notice_list")
          .doc(notice.text)
          .set({"notice": notice.text, "notice_details": notice_details.text});
    } catch (e) {
      print(e);
    }
  }

  update() async {
    try {
      firebase.collection("notice_list").doc(notice.text).update({'notice_details': notice_details.text});
    } catch (e) {
      print(e);
    }
  }

  dispose(){
    notice.clear();
    notice_details.clear();
  }

  delete() async {
    try {
      firebase.collection("notice_list").doc(notice.text).delete();
    }catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Notice"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: notice,
                decoration: InputDecoration(
                    labelText: "Enter your notice",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: notice_details,
                decoration: InputDecoration(
                    labelText: "Enter your notice_details",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(),
                      onPressed: (){
                        create();
                        dispose();
                      },
                      child: Text("Create")
                  ),
                  ElevatedButton(
                      style: TextButton.styleFrom(),
                      onPressed: (){
                        update();
                        dispose();
                      },
                      child: Text("Update")
                  ),
                  ElevatedButton(
                      style: TextButton.styleFrom(),
                      onPressed: (){
                        delete();
                        dispose();
                      },
                      child: Text("Delete")
                  ),
                ],
              ),
              Container(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firebase.collection("notice_list").snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i){
                            QueryDocumentSnapshot x = snapshot.data!.docs[i];
                            return ListTile(
                              title: Text(x['notice']),
                              subtitle: Text(x['notice_details']),
                            );
                          }
                      );
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
