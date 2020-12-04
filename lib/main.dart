import 'package:contacts_reminders/src/components/bottom_navigation_bar.dart';
import 'package:contacts_reminders/src/pages/appointments.dart';
import 'package:contacts_reminders/src/pages/create_new_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings('logo');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {}
  );

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings, 
    onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('Notification payload' + payload);
      }
    }
  );

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: BottomNavigationBarComponent(),
      routes: {
        'new-contact': (BuildContext context) => NewContact(),
        'appointments': (BuildContext context) => AppointmentsPage()
      },
    );
  }
}