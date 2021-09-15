import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:intl/intl.dart';


class TodoAppScreen extends StatefulWidget {
  @override
  _TodoAppScreenState createState() => _TodoAppScreenState();
}

class _TodoAppScreenState extends State<TodoAppScreen> {

  List? todo;
  String? createdAt;
  DateTime now = DateTime.now();




// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  getNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var data = prefs.getString('todo');
      if (data == null) {
        return;
      }
      List jsonData = jsonDecode(data);
      if (jsonData.length > 0) {
        print('get todo $jsonData');
        todo = jsonData;
      } else {
        todo = [];
      }
    });
  }
  void Notify()  async{


    String timezom = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: 'This is Notification title',
          body: 'This is Body of Noti',
          bigPicture: 'https://protocoderspoint.com/wp-content/uploads/2021/05/Monitize-flutter-app-with-google-admob-min-741x486.png',
          notificationLayout: NotificationLayout.BigPicture
      ),
      schedule: NotificationCalendar.fromDate(date: DateTime.parse("2021-07-20 20:18:04Z"))
    );
  }
  @override
  void initState() {
    getNote();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextButton(onPressed: (){
              Notify();
            }, child: Text("Push Notification")),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(hintText: "Type..."),
                  ),
                ),
              ],
            ),
            DateTimePicker(
              type: DateTimePickerType.date,
              initialValue: DateTime.now().toString(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Dateline',
              dateMask: 'd MMM, yyyy,',
              onChanged: (val){
                createdAt = val;
                print("on Changed $val");

              },
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val) => print(val),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      saveNote(
                          value: textEditingController.text,
                          dateTime: createdAt ?? DateFormat('dd-MM-yyyy').format(now));
                    },
                    child: Text('Save'),
                  ),
                )
              ],
            ),
            Text(
              'TODO List',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            NoteList(
              value: todo == null ? [] : todo!,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  saveNote({required String value, required String dateTime}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List lstNote = [];
    Map map = {'title': value, 'created_at': dateTime};
    lstNote.add(map);
    if (todo != null) {
      lstNote.addAll(todo!);
    }
    var jsonNote = jsonEncode(lstNote);

    await prefs.setString('todo', jsonNote);
    getNote();
  }

  onDelete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('todo');
    setState(() {
      var data = prefs.getString('todo');
      if (data == null) {
        todo = [];
        return;
      }
      List jsonData = jsonDecode(data);
      if (jsonData.length > 0) {
        print('get todo $jsonData');
        todo = jsonData;
      }
    });
  }


}

class NoteList extends StatelessWidget {
  final Function onDelete;
  final List value;
  NoteList({required this.value, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (value.length <= 0) {
      return Text("Empty");
    }
    return Expanded(
      child: ListView.builder(
        itemCount: value.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(value[index]['title']),
              subtitle: Text(value[index]['created_at']),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  onDelete();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
