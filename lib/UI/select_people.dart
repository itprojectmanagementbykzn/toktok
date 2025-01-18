import 'package:flutter/material.dart';
import 'package:home_care_service/UI/topup_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  final String fromLocation;
  final String toLocation;

  const BookingPage({Key? key, required this.fromLocation, required this.toLocation}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int selectedNumber = 1;
  bool wholeCar = false;
  double distance = 0.0; // Distance in kilometers
  double fee = 0.0; // Base fee calculated
  final TextEditingController promoCodeController = TextEditingController();
  bool isPromoApplied = false;

  @override
  void initState() {
    super.initState();
    calculateDistance();
  }

  Future<void> calculateDistance() async {
    const apiKey = 'AIzaSyB3ECKRUA07Zk5T_2RQsOD-brN2wM2p59U'; // Be sure to secure your API key
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${Uri.encodeComponent(widget.fromLocation)}&destination=${Uri.encodeComponent(widget.toLocation)}&key=$apiKey'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        var route = data['routes'][0];
        var leg = route['legs'][0];
        setState(() {
          distance = leg['distance']['value'] / 1000.0; // Convert meters to kilometers
          calculateFee();
        });
      } else {
        print('No routes found. Check your input addresses or API key restrictions.');
      }
    } else {
      print('Failed to load directions with status code: ${response.statusCode}. Check your API key and network.');
    }
  }

  void calculateFee() {
    double baseRate = 10; // Cost per kilometer
    // Apply the base fee calculation first
    fee = distance * baseRate * selectedNumber;

    // Apply discounts based on the number of passengers
    switch (selectedNumber) {
      case 2:
        fee *= 0.95; // Subtract 5%
        break;
      case 3:
        fee *= 0.90; // Subtract 10%
        break;
      case 4:
        fee *= 0.85; // Subtract 15%
        break;
      case 5:
        fee *= 0.80; // Subtract 20%
        break;
      case 6:
        fee *= 0.75; // Subtract 25%
        break;
      default:
        break;
    }

    // Apply the multiplier for a private car if selected
    if (wholeCar) {
      fee = distance * baseRate * 3.4; // Overwrite fee calculation for private car
    }

    // Reapply promo code discount if already applied
    if (isPromoApplied) {
      fee *= 0.80; // Subtract 20% for promo code
    }

    setState(() {});
  }

  void applyPromoCode() {
    if (promoCodeController.text.trim().toUpperCase() == 'TOKTOK') {
      setState(() {
        isPromoApplied = true;
        calculateFee();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Promo code applied! 20% discount added.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid promo code.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Info"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("From: ${widget.fromLocation}"),
            SizedBox(height: 8),
            Text("To: ${widget.toLocation}"),
            SizedBox(height: 20),
            Text("How many are going?"),
            Wrap(
              spacing: 8,
              children: List.generate(6, (index) {
                return ChoiceChip(
                  label: Text("${index + 1}"),
                  selected: selectedNumber == index + 1,
                  onSelected: (bool selected) {
                    setState(() {
                      selectedNumber = index + 1;
                      calculateFee(); // Recalculate the fee when the number of passengers changes
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text("I want a whole car - Private Car"),
              value: wholeCar,
              onChanged: (bool? value) {
                setState(() {
                  wholeCar = value ?? false;
                  calculateFee(); // Recalculate the fee when the whole car option changes
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: promoCodeController,
              decoration: InputDecoration(
                labelText: "Enter Promo Code",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: applyPromoCode,
              child: Text("Apply Promo Code"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            Text("Estimated Fee: ${fee.toStringAsFixed(2)} THB"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopUpPage()),
                );
              },
              child: Text("My Wallet"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for requesting a ride
              },
              child: Text("Request Ride"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
