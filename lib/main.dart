import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shared_preferences/share_preferences/share_preferences_screen.dart';
import 'package:flutter_shared_preferences/share_preferences/store_list_screen.dart';
import 'package:flutter_shared_preferences/share_preferences/todo_app/todo_app_screen.dart';
import 'package:flutter_shared_preferences/sqllite/pages/Sqllite_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white
        )
      ]
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      // home: HomeScreen(),
      // home: TodoAppScreen(),
      home: SQLLiteScreen(),
    );
  }
}


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SharedPreferencesScreen()));
            }, child: Text('Shared Preferences')),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SharedPreferencesListScreen()));

            }, child: Text('Shared Preferences Store List')),
          ],
        ),
      ),
    );
  }
}
