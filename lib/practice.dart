import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  // Fetch data from your API
  Future<void> fetchRiskZones() async {
    final response = await http.get(Uri.parse('http://localhost:5000/api/high-risk-areas'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _markers.clear();
        _circles.clear();

        for (var zone in data) {
          double lat = zone['latitude'];
          double lng = zone['longitude'];
          String riskLevel = zone['riskLevel']; // Assuming riskLevel is "high" or "medium"

          // Add a marker and a circle for the zone
          _markers.add(Marker(
            markerId: MarkerId('$lat,$lng'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(title: 'Risk Zone'),
          ));

          Color zoneColor = (riskLevel == 'high') ? Colors.red : Colors.yellow;

          _circles.add(Circle(
            circleId: CircleId('$lat,$lng'),
            center: LatLng(lat, lng),
            radius: 500, // Adjust radius as needed
            fillColor: zoneColor.withOpacity(0.5),
            strokeColor: zoneColor,
            strokeWidth: 1,
          ));
        }
      });
    } else {
      throw Exception('Failed to load risk zones');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRiskZones(); // Fetch the risk zones when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Risk Zones Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(18.5204, 73.8567), // Pune location
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: _markers,
        circles: _circles,
      ),
    );
  }
}
