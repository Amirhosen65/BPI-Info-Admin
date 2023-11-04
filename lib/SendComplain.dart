import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ComplainFormPage extends StatefulWidget {
  @override
  _ComplainFormPageState createState() => _ComplainFormPageState();
}

class _ComplainFormPageState extends State<ComplainFormPage> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _sendComplain() {
    String subject = _subjectController.text;
    String details = _detailsController.text;
    Message message = Message(subject: subject, details: details);

    // Send message to another app
    _showNotification(message);

    setState(() {
      _subjectController.clear();
      _detailsController.clear();
    });
  }

  void _showNotification(Message message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'message_channel',
      'Messages',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.subject,
      message.details,
      platformChannelSpecifics,
      payload: 'message_payload',
    );

    setState(() {
      _messages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complain Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Complain Details',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendComplain,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('My App'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Complain Form'),
                Tab(text: 'Messages'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ComplainFormPage(),
              MessageListPage(),
            ],
          ),
        ),
      ),
    ),
  );
}