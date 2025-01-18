import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrackPage extends StatefulWidget {
  @override
  _OrderTrackPageState createState() => _OrderTrackPageState();
}

class _OrderTrackPageState extends State<OrderTrackPage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = LatLng(37.77483, -122.41942); // San Francisco coordinates

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Adjust as needed
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/kzn-service.appspot.com/o/caregiver_photo%2F2024-09-09%2017%3A19%3A11.514994?alt=media&token=d5f4fcaa-c2e4-4fef-a7de-d6ed09edfbc4',
                      fit: BoxFit.cover,
                    ),
                    title: const Text('Naw Baby'),
                    subtitle: const Row(
                      children: [
                        Icon(Icons.star, size: 20, color: Colors.orange),
                        Text(' 4.6')
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 12,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.phone,
                              size: 30,
                              color: Colors.green),
                          onPressed: () => _dialPhoneNumber("09 46300 830"),// Implement phone call functionality
                        ),
                        IconButton(
                          onPressed: () {
                            launchMessenger();
                          },
                          icon: Image.asset(
                            "assets/messenger.png",
                            width: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimate Time'),
                      Text('05 min / 15 min'),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Details',
                    style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launchMessenger() async {
    String facebookId = '104970494553207';
    String url;

    if (Platform.isAndroid) {
      url = 'fb-messenger://user/$facebookId';
    } else if (Platform.isIOS) {
      url = 'https://m.me/$facebookId';
    } else {
      throw 'Unsupported platform';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

void _dialPhoneNumber(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunch(phoneUri.toString())) {
    await launch(phoneUri.toString());
  } else {
    print('Could not launch $phoneNumber');
  }
}

