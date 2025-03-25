import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'Dashboard1.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LocationScreen()));
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(28.6139, 77.2090);
  bool _locationFetched = false;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission denied!")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _locationFetched = true;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));

    // 🟢 Navigate to Dashboard1 with location data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Dashboard1(location: _currentLocation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 406,
              height: 406,
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: _locationFetched
                  ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentLocation,
                  zoom: 15,
                ),
                onMapCreated: (controller) => _mapController = controller,
                markers: {
                  Marker(
                    markerId: MarkerId("currentLocation"),
                    position: _currentLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  ),
                },
                myLocationButtonEnabled: false,
              )
                  : Image.asset('assets/images/map_placeholder.png',
                  fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 80),
          SizedBox(
            width: 327,
            height: 62,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF7622),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _getCurrentLocation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("ACCESS LOCATION",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.my_location, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "DFOOD WILL ACCESS YOUR LOCATION ONLY WHILE USING THE APP",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
