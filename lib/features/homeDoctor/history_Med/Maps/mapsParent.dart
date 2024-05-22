import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/repositories/MapsRepository/MapsRepository.dart';

class MapPagesss extends StatefulWidget {
  const MapPagesss({super.key});

  @override
  State<MapPagesss> createState() => _MapPageState();
}

class _MapPageState extends State<MapPagesss> {
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  UnifiedDoctorRepository hh = UnifiedDoctorRepository();
  LatLng? _currentP;
  Map<MarkerId, Marker> _markers = {};
  bool _isLoading = true;
  bool _hasDoctors = false;

  StreamSubscription<QuerySnapshot>? _doctorSubscription;
  DocumentSnapshot? _lastRequest;
  String? _doctorName;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    _fetchActiveDoctors();
    _fetchRequests();
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

  void _fetchRequests() {
    FirebaseFirestore.instance
        .collection('Requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _markers.clear();
            for (var doc in snapshot.docs) {
              var data = doc.data() as Map<String, dynamic>;
              LatLng requestPosition = LatLng(data['latitude'], data['longitude']);
              final markerId = MarkerId(doc.id);
              _markers[markerId] = Marker(
                markerId: markerId,
                position: requestPosition,
                infoWindow: InfoWindow(
                  title: 'Request from ${data['parentId']}',
                  snippet: 'Tap for actions',
                  onTap: () {
                    _showRequestActions(context, doc);
                  },
                ),
                icon: BitmapDescriptor.defaultMarker,
              );
            }
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  void _showRequestActions(BuildContext context, DocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Accepter'),
              onTap: () {
                FirebaseFirestore.instance.collection('Requests').doc(doc.id).update({'status': 'accepted'});
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Refuser'),
              onTap: () {
                FirebaseFirestore.instance.collection('Requests').doc(doc.id).update({'status': 'rejected'});
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Appeler'),
              onTap: () {
                _callParent(doc['parentId']);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _callParent(String parentId) async {
    // Remplacez par la logique réelle de récupération du numéro de téléphone
    String phoneNumber = 'tel:1234567890'; // Numéro d'exemple
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
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

  void _cancelRequest() async {
    if (_lastRequest != null) {
      await FirebaseFirestore.instance
          .collection('Requests')
          .doc(_lastRequest!.id)
          .update({'status': 'reject'});
      setState(() {
        _lastRequest = null; // Clear the last request
      });
    }
  }

  void _callAmbulance() async {
    const ambulanceNumber = 'tel:16';
    if (await canLaunch(ambulanceNumber)) {
      await launch(ambulanceNumber);
    } else {
      throw 'Could not launch $ambulanceNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Doctors'),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
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
            bottom: 60,
            left: 60,
            right: 60,
            child: Column(
              children: [
                if (_lastRequest != null)
                  Card(
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Request to ${_doctorName ?? _lastRequest!['doctorId']}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('Status: ${_lastRequest!['status']}'),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: _cancelRequest,
                            child: Text('Cancel Request'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                FloatingActionButton.extended(
                  onPressed: _callAmbulance,
                  label: Text("Call an ambulance"),
                  icon: Icon(Icons.local_hospital),
                ),
              ],
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
