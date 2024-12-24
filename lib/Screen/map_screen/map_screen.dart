import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  // Fetch data from your API
  Future<void> fetchRiskZones() async {
    try {
      final response = await http.get(Uri.parse('https://emergency-alert-backend.onrender.com/api/high-risk-areas'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _markers.clear();
          _circles.clear();

          for (var zone in data) {
            double lat = double.parse(zone['latitude'].toString());
            double lng = double.parse(zone['longitude'].toString());
            String riskLevel = zone['riskLevel'];

            // Add marker
            _markers.add(Marker(
              markerId: MarkerId('$lat,$lng'),
              position: LatLng(lat, lng),
              infoWindow: const InfoWindow(title: 'Risk Zone'),
            ));

            // Add circle
            Color zoneColor = riskLevel.trim().toLowerCase() == "high" ? Colors.black : Colors.red;

            _circles.add(Circle(
              circleId: CircleId('$lat,$lng'),
              center: LatLng(lat, lng),
              radius: 200,
              fillColor: zoneColor.withOpacity(0.1), // Transparent fill
              strokeColor: zoneColor,
              strokeWidth: 1,
            ));
          }
        });
      } else {
        throw Exception('Failed to load risk zones');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Request location permission
  Future<void> requestPermissions() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      print("Location permission granted");
    } else if (status.isDenied) {
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      print("Location permission permanently denied. Enable it from settings.");
      openAppSettings();
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    fetchRiskZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Zones Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(18.5204, 73.8567), // Pune location
          zoom: 12,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          print('Map created');
        },
        markers: _markers,
        circles: _circles,
      ),
    );
  }
}
