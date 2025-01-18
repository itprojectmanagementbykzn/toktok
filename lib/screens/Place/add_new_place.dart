import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNewPlace extends StatefulWidget {
  @override
  _AddNewPlaceState createState() => _AddNewPlaceState();
}

class _AddNewPlaceState extends State<AddNewPlace> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _photoLinkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Function to save data to Firestore
  Future<void> _saveDataToFirestore() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Reference to Firestore collection
        final firestore = FirebaseFirestore.instance;

        // Add data to the collection
        await firestore.collection('places').add({
          'place_name': _placeNameController.text.trim(),
          'location': _locationController.text.trim(),
          'photo_link': _photoLinkController.text.trim(),
          'description': _descriptionController.text.trim(),
          'created_at': Timestamp.now(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Place added successfully!')),
        );

        // Clear form fields
        _formKey.currentState?.reset();
        _placeNameController.clear();
        _locationController.clear();
        _photoLinkController.clear();
        _descriptionController.clear();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _placeNameController,
                  decoration: InputDecoration(labelText: 'Place Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the place name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _photoLinkController,
                  decoration: InputDecoration(labelText: 'Place Photo Link'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the photo link';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveDataToFirestore,
                  child: const Text('Save Place'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
