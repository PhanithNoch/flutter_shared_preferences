import 'package:flutter/material.dart';
import 'package:flutter_shared_preferences/sqllite/sql_helper.dart';
class SQLLiteScreen extends StatefulWidget {

  @override
  _SQLLiteScreenState createState() => _SQLLiteScreenState();
}

class _SQLLiteScreenState extends State<SQLLiteScreen> {
  List<Map<String,dynamic>> _journals = [];
  bool _isLoading = true;
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState((){
      _isLoading = false;
      _journals =  data;
    });

  }
  void showForm(int? id) async {
    // if id == null -> create new 
    // if id != null -> update
    if(id != null){
      final existingJournal = _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(context: context,
      builder: (_){
      return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title"
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  hintText: "Description"
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: () async{
              if(id == null){
                await _addItem();
              }
              if(id != null){
                await _updateItem(id);
              }
              // clear the text fields
              _titleController.text = '';
              _descriptionController.text = '';
              Navigator.of(context).pop();
            }, child: Text(id == null ? 'Create New' : 'Update'))
          ],
        ),
      );
      }

    );


  }
  // insert a new journal to the database
  Future<void> _addItem() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    await SQLHelper.createItem(title, description);
    _refreshJournals();

  }

  // update an existing journal
  Future<void> _updateItem(int id) async{
    final title = _titleController.text;
    final description = _descriptionController.text;
    await SQLHelper.updateItem(id, title, description);
    _refreshJournals();
  }
  // void delete item
  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully to Delete a journal")));
    _refreshJournals();
  }
  @override
  void initState() {
    _refreshJournals();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showForm(null),
        ),
      appBar: AppBar(
        title: Text("CRUD SQLLite"),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),)
          : ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context,index) => Card(
          color: Colors.orange,
          margin: EdgeInsets.all(15),
          child: ListTile(
            title: Text(_journals[index]['title']),
            subtitle: Text(_journals[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    showForm(_journals[index]['id']);
                  }, icon: Icon(Icons.edit)),
                  IconButton(onPressed: (){
                   deleteItem(_journals[index]['id']);
                  }, icon: Icon(Icons.delete)),

                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
