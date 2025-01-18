import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  int currentBalance = 438;  // Example starting balance
  String paymentMethod = 'card';  // Default to card

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top-up Amount"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Current Balance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("฿$currentBalance", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Please enter amount (baht)", style: TextStyle(fontSize: 16)),
            Wrap(
              spacing: 8,
              children: [100, 250, 500, 1000].map((amount) => ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentBalance += amount;
                  });
                },
                child: Text("฿$amount"),
                style: ElevatedButton.styleFrom(minimumSize: Size(90, 40)),
              )).toList(),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text("Visa/MasterCard"),
              leading: Radio(
                value: 'card',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            ListTile(
              title: Text("QR Payment"),
              leading: Radio(
                value: 'qr',
                groupValue: paymentMethod,
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value.toString();
                  });
                },
              ),
            ),
            if (paymentMethod == 'card') buildCardInformation(),
            if (paymentMethod == 'qr') buildQRCode(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Proceed to next step or confirmation
                Navigator.pop(context);
              },
              child: Text("Next"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardInformation() {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Card number',
            // hintText: 'XXXX XXXX XXXX XXXX',
            border: OutlineInputBorder(),  // Adds the outline border
          ),
        ),
        SizedBox(height: 10),  // Adds spacing between input fields
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Name on card',
            border: OutlineInputBorder(),  // Adds the outline border
          ),
        ),
        SizedBox(height: 10),  // Adds spacing between input fields
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Expiry date',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(),  // Adds the outline border
                ),
              ),
            ),
            SizedBox(width: 20),  // Adds spacing between input fields horizontally
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: 'XXX',
                  border: OutlineInputBorder(),  // Adds the outline border
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildQRCode() {
    return Column(
      children: <Widget>[
        const Text('1. Press QR Code to Save or take a screenshot'),
        const SizedBox(height: 10),
        Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/QR_code_for_mobile_English_Wikipedia.svg/1200px-QR_code_for_mobile_English_Wikipedia.svg.png'), // Update this URL to your QR code image
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Text('This QR Code will expire in 05:00 mins'),
      ],
    );
  }
}
