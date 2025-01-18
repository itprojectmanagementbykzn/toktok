import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../UI/select_people.dart';
import 'choose_location.dart';


class PlacesMapPage extends StatefulWidget {
  @override
  _PlacesMapPageState createState() => _PlacesMapPageState();
}

class _PlacesMapPageState extends State<PlacesMapPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> _places = [];
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  List<Map<String, dynamic>> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('places').get();

      List<Map<String, dynamic>> places = [];
      Set<Marker> markers = {};

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Convert textual location to LatLng using Google Geocoding API
        LatLng? latLng = await _getLatLngFromAddress(data['location']);
        if (latLng != null) {
          // Add place data to the list
          places.add({
            'place_name': data['place_name'],
            'description': data['description'],
            'latLng': latLng,
            'photo_link': data['photo_link'],
          });

          // Add a marker for the location
          Marker marker = Marker(
            markerId: MarkerId(doc.id),
            position: latLng,
            infoWindow: InfoWindow(
              title: data['place_name'],
            ),
            onTap: () {
              // Show the PlaceDetailsBottomSheet when the marker is tapped
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => PlaceDetailsBottomSheet(
                  placeName: data['place_name'],
                  description: data['description'],
                  imageUrl: data['photo_link'],
                  onPickUpPressed: () {
                    setState(() {
                      _fromController.text = data['place_name'];
                    });
                    Navigator.pop(context);
                  },
                  onDropOffPressed: () {
                    setState(() {
                      _toController.text = data['place_name'];
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );

          markers.add(marker);
        }
      }

      setState(() {
        _places = places;
        _markers = markers;
      });
    } catch (e) {
      print('Error fetching places: $e');
    }
  }

  Future<LatLng?> _getLatLngFromAddress(String address) async {
    const String apiKey = 'AIzaSyB3ECKRUA07Zk5T_2RQsOD-brN2wM2p59U';
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'OK' && jsonData['results'].isNotEmpty) {
          var location = jsonData['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        }
      }
    } catch (e) {
      print('Error fetching coordinates for address: $e');
    }
    return null;
  }

  void _filterPlaces(String query, TextEditingController controller) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = [];
      } else {
        _filteredPlaces = _places
            .where((place) =>
            place['place_name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });

    if (_filteredPlaces.isNotEmpty) {
      controller.text = _filteredPlaces.first['place_name'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.707567, 100.601708), // Centered at On-Nut, Bangkok
              zoom: 14,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            myLocationEnabled: true,
          ),

          // Floating Header
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.map, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'On-Nut',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextField(
                    controller: _fromController,
                    onChanged: (value) => _filterPlaces(value, _fromController),
                    decoration: const InputDecoration(
                      labelText: 'From ?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _toController,
                    onChanged: (value) => _filterPlaces(value, _toController),
                    decoration: const InputDecoration(
                      labelText: 'To ?',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_filteredPlaces.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredPlaces.length,
                      itemBuilder: (context, index) {
                        final place = _filteredPlaces[index];
                        return ListTile(
                          title: Text(place['place_name']),
                          onTap: () {
                            setState(() {
                              if (_fromController.text.isNotEmpty) {
                                _fromController.text = place['place_name'];
                              } else {
                                _toController.text = place['place_name'];
                              }
                              _filteredPlaces = [];
                            });
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_fromController.text.isNotEmpty && _toController.text.isNotEmpty) {
                          // Navigate to BookingPage with parameters
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingPage(
                                fromLocation: _fromController.text,
                                toLocation: _toController.text,
                              ),
                            ),
                          );
                        } else {
                          // Show an error message if either field is empty
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Missing Information"),
                                content: Text("Please select both a starting and a destination point."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Next'),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
