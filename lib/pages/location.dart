import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LiveLocationExample extends StatefulWidget {
  @override
  _LiveLocationExampleState createState() => _LiveLocationExampleState();
}

class _LiveLocationExampleState extends State<LiveLocationExample> {
  String location = "Getting location...";

  @override
  void initState() {
    super.initState();
    getLiveLocation();
  }

  Future<void> getLiveLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        location = "Location services are disabled.";
      });
      return;
    }

    // Request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          location = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        location = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Reverse geocode to get the town/city
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        location =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } else {
      setState(() {
        location = "Town not found.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location")),
      body: Center(child: Text(location)),
    );
  }
}
