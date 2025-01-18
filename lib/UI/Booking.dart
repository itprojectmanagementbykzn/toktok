import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class BookingsPage extends StatefulWidget {
  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Booking> bookings = [
    Booking(
        number: 1,
        status: 'Active',
        service: 'Baby Care',
        price: 999,
        address: 'Ekkamai, Bangkok, 10260',
        dateTime: 'December 10, 2024 at 10:00 AM',
        caregiver: 'Naw Baby',
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/kzn-service.appspot.com/o/caregiver_photo%2F2024-09-09%2017%3A19%3A20.782567?alt=media&token=19b90625-f2c8-4a1f-a3aa-d4574e12450d',
        dutyType: 'Day Shift'
    ),
    Booking(
        number: 2,
        status: 'Pending',
        service: 'Elderly Care',
        price: 799,
        address: 'Onnut, Bangkok, 10250',
        dateTime: 'December 10, 2024 at 06:00 PM',
        caregiver: 'Chaw Ei',
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/kzn-service.appspot.com/o/caregiver_photo%2F2024-09-28%2016%3A27%3A28.592387?alt=media&token=de660d51-54d3-42c7-ad59-353ba770fbc2',
        dutyType: 'Night Shift'
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookingList(bookings: bookings, status: 'Pending'),
          BookingList(bookings: bookings, status: 'Active'),
          BookingList(bookings: bookings, status: 'Completed'),
          BookingList(bookings: bookings, status: 'Cancelled'),
        ],
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final String status;

  BookingList({required this.bookings, required this.status});

  @override
  Widget build(BuildContext context) {
    List<Booking> filteredBookings = bookings.where((b) => b.status == status).toList();

    return ListView.builder(
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: filteredBookings[index], status: status);
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final String status;

  BookingCard({required this.booking, required this.status});

  @override
  Widget build(BuildContext context) {
    bool showCommunicationButtons = booking.status == 'Pending' || booking.status == 'Active';

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.network(booking.imageUrl, width: 50),
                    const SizedBox(width: 10),
                    Text('#${booking.number}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: booking.status == 'Accepted' ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(booking.status, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                Text('฿${booking.price.round()}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            Text('Caregiver: ${booking.caregiver}'),
            Text('${booking.service} (${booking.dutyType})'),
            const SizedBox(height: 5),
            Text('Service Location: ${booking.address}'),
            Text('Starting Date: ${booking.dateTime}'),
            const SizedBox(height: 10),
            if (showCommunicationButtons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.phone, size: 30, color: Colors.green),
                        onPressed: () => _dialPhoneNumber("09 46300 830"), // Implement phone call functionality
                      ),
                      IconButton(
                        onPressed: () => launchMessenger(),
                        icon: Image.asset("assets/messenger.png", width: 25),
                      ),




                    ],
                  ),

                  if (status != 'Pending')
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Track Booking'),
                    ),

                ],
              ),

          ],
        ),
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

class Booking {
  final int number;
  final String status;
  final String service;
  final double price;
  final String address;
  final String dateTime;
  final String caregiver;
  final String imageUrl;
  final String dutyType;

  Booking({
    required this.number,
    required this.status,
    required this.service,
    required this.price,
    required this.address,
    required this.dateTime,
    required this.caregiver,
    required this.imageUrl,
    required this.dutyType,
  });
}
