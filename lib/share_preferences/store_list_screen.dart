import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class SharedPreferencesListScreen extends StatefulWidget {
  @override
  _SharedPreferencesScreenState createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesListScreen> {

  List? note;
  getNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
    var data = prefs.getString('noteList');

      if(data != null){
        var jsonData = jsonDecode(data);
        note = jsonData;
      }
      else{
        note = [];
      }


    });
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
        title: Text('Shared Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Note',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: "Type..."),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      saveNote(value: textEditingController.text);
                    },
                    child: Text('Save'),
                  ),
                )
              ],
            ),
            Text(
              'View Notes',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            NoteList(
              value: note == null ? [] : note!,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  saveNote({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List? lstNote = [];
    lstNote.add(value);
    if(note != null){
      lstNote.addAll(note!);
    }
    var jsonNote = jsonEncode(lstNote);

    await prefs.setString('noteList', jsonNote);
    getNote();
  }

  onDelete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('noteList');
    getNote();
  }
}

class NoteList extends StatelessWidget {
  final Function onDelete;
  final List value;
  NoteList({required this.value, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if(value.length <=0 ){
      return Text("Empty");
    }
    return  Expanded(
      child: ListView.builder(
        itemCount: value.length,
        itemBuilder: (context,index){
          return Card(
            child: ListTile(
              title: Text(value[index]),
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
