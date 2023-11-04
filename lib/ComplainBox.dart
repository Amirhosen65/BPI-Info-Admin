import 'package:flutter/material.dart';

class Notice {
  String title;
  String details;

  Notice(this.title, this.details);
}

class NoticeSendPage extends StatefulWidget {
  @override
  _NoticeSendPageState createState() => _NoticeSendPageState();
}

class _NoticeSendPageState extends State<NoticeSendPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  void sendNotice() {
    String title = titleController.text;
    String details = detailsController.text;
    Notice notice = Notice(title, details);
    // TODO: Send the notice to another app or store it as needed
    titleController.clear();
    detailsController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notice sent'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notice'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Notice Title',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: detailsController,
              decoration: InputDecoration(
                labelText: 'Notice Details',
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Send Notice'),
            onPressed: () {
              sendNotice();
            },
          ),
        ],
      ),
    );
  }
}
