import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesScreen extends StatefulWidget {
  @override
  _SharedPreferencesScreenState createState() =>
      _SharedPreferencesScreenState();
}

class _SharedPreferencesScreenState extends State<SharedPreferencesScreen> {

  String? note;
  getNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      note = prefs.getString('note');
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
              value: note,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  saveNote({required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('note', value);
    getNote();
  }

  onDelete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('note');
    getNote();
  }
}

class NoteList extends StatelessWidget {
  final Function onDelete;
  final String? value;
  NoteList({required this.value, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: value == null ? Text('Note not available') : Text(value!),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            onDelete();
          },
        ),
      ),
    );
  }
}
