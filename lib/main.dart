import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_care_service/screens/Place/Locations.dart';



import 'package:firebase_core/firebase_core.dart';

import 'UI/Booking.dart';
import 'UI/Order_Track.dart';
import 'UI/select_people.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: const FirebaseOptions(
    //   apiKey: "AIzaSyA-d1rAVHyAfIF7Y1B4RkIQV1v8YBbhMhc",
    //   authDomain: "kzn-service.firebaseapp.com",
    //   projectId: "kzn-service",
    //   storageBucket: "kzn-service.appspot.com",
    //   messagingSenderId: "264664382023",
    //   appId: "1:264664382023:web:9e05fdfe58871a30890f62",
    // ),
  );


  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  // Method to initialize Firebase Messaging
  void _initializeFirebaseMessaging() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission for notifications');

        // Listen to foreground messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Received a message: ${message.notification?.title}, ${message.notification?.body}');
        });

        // Get the device token
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          print('Push Messaging token: $token');
        } else {
          print('Failed to retrieve the push messaging token.');
        }
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Care Service',
        theme: ThemeData(
          fontFamily: 'Tahoma',
          primarySwatch: Colors.blue,
        ),
      home: PlacesMapPage());
  }
}

// Colors
const primary = Color(0xFFEBE9FC);
const kWhiteColor = Color(0xFFEBE9FC);
const BGColor = Color(0xFFfff4fc);
const grey = Colors.grey;
const white = Color(0xFFFFFFFF);
const black = Color(0xFF000000);
const online = Color(0xFF66BB6A);
const pupple = Colors.purpleAccent;
const blue_story = Colors.blueAccent;
Color kPrimaryColor = Colors.blue.shade900;
Color kSecondaryColor = const Color(0xFFF2F2F2);
Color kGreyColor = const Color(0xFF888888);


