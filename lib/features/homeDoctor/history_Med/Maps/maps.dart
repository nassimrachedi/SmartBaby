import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/repositories/MapsRepository/MapsRepository.dart';

class MapPages extends StatefulWidget {
  const MapPages({super.key});

  @override
  State<MapPages> createState() => _MapPageState();
}

class _MapPageState extends State<MapPages> {
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  UnifiedDoctorRepository hh = new UnifiedDoctorRepository();
  LatLng? _currentP;
  Map<MarkerId, Marker> _markers = {};
  bool _isLoading = true;
  bool _hasDoctors = false;

  StreamSubscription<QuerySnapshot>? _doctorSubscription;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  void dispose() {
    _doctorSubscription?.cancel();
    super.dispose();
  }

  void _fetchActiveDoctors() {
    _doctorSubscription = FirebaseFirestore.instance
        .collection('Doctors')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasDoctors = true;
            _markers.clear();

            for (var doc in snapshot.docs) {
              var data = doc.data() as Map<String, dynamic>;
              LatLng doctorPosition = LatLng(data['latitude'], data['longitude']);
              final markerId = MarkerId(doc.id);
              _markers[markerId] = Marker(
                markerId: markerId,
                position: doctorPosition,
                infoWindow: InfoWindow(
                  title: '${data['firstName']} ${data['lastName']}',
                  snippet: 'Tap to request help',
                  onTap: () {
                    _sendHelpRequest(doc.id);
                  },
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              );
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasDoctors = false;
          });
        }
      }
    }, onError: (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasDoctors = false;
        });
      }
    });
  }

  void _callAmbulance() async {
    const ambulanceNumber = 'tel:16';
    if (await canLaunch(ambulanceNumber)) {
      await launch(ambulanceNumber);
    } else {
      throw 'Could not launch $ambulanceNumber';
    }
  }

  void _sendHelpRequest(String doctorId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Send Help Request"),
        content: Text("Do you want to request help from this doctor?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              hh.sendHelpRequest(doctorId);
              Navigator.of(context).pop();
            },
            child: Text('Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : !_hasDoctors
          ? Center(child: Text("No active doctors found."))
          : Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) => _mapController.complete(controller),
            initialCameraPosition: CameraPosition(
              target: _currentP ?? LatLng(0, 0), // Position initiale quelconque
              zoom: 13,
            ),
            markers: {
              if (_currentP != null)
                Marker(
                  markerId: MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
            }..addAll(_markers.values.toSet()), // Fusionner les marqueurs existants avec les marqueurs des médecins
          ),
          Positioned(
            bottom: 20,
            left: 90,
            right: 160,
            child: FloatingActionButton.extended(
              onPressed: _callAmbulance,
              label: Text("Appeler l'ambulance."),
              icon: Icon(Icons.local_hospital),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        print("Location services are disabled.");
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("Location permission not granted.");
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraToPosition(_currentP!);
            print("Current location: $_currentP");
          });
          _fetchActiveDoctors(); // Appeler cette fonction après avoir mis à jour la position actuelle
        }
      } else {
        print("Current location is null.");
      }
    });
  }
}
