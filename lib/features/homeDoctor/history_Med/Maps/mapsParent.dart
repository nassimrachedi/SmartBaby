import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/repositories/MapsRepository/MapsRepository.dart';
import '../../../../features/personalization/models/RequestModel.dart';

class DoctorMapPage extends StatefulWidget {
  const DoctorMapPage({super.key});

  @override
  State<DoctorMapPage> createState() => _DoctorMapPageState();
}

class _DoctorMapPageState extends State<DoctorMapPage> {
  Location _locationController = Location();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  UnifiedDoctorRepository repository = UnifiedDoctorRepository();
  LatLng? _currentP;
  Map<MarkerId, Marker> _markers = {};
  bool _isLoading = true;
  bool _hasRequests = false;

  StreamSubscription<List<Request>>? _requestSubscription;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    _fetchRequests();
  }

  @override
  void dispose() {
    _requestSubscription?.cancel();
    super.dispose();
  }

  void _fetchRequests() {
    _requestSubscription = repository.getRequestsForDoctor().listen((requests) async {
      if (requests.isNotEmpty) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasRequests = true;
            _markers.clear();
          });

          for (var request in requests) {
            if (request.latitude != null && request.longitude != null) {
              // Récupérer les informations du parent
              DocumentSnapshot parentDoc = await FirebaseFirestore.instance.collection('Parents').doc(request.parentId).get();
              if (parentDoc.exists) {
                String parentName = parentDoc['FirstName'] + ' ' + parentDoc['LastName'];
                String phoneNumber = parentDoc['PhoneNumber'];
                LatLng requestPosition = LatLng(request.latitude!, request.longitude!);
                final markerId = MarkerId(request.id);

                setState(() {
                  _markers[markerId] = Marker(
                    markerId: markerId,
                    position: requestPosition,
                    infoWindow: InfoWindow(
                      title: 'Help Request',
                      snippet: 'Parent: $parentName\nPhone: $phoneNumber\nTap to manage request',
                      onTap: () {
                        _showRequestOptions(request, parentName, phoneNumber);
                      },
                    ),
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  );
                });
              } else {
                print('Parent document does not exist for request: ${request.id}');
              }
            } else {
              print('Latitude ou Longitude est null pour la requête: ${request.id}');
            }
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasRequests = false;
            _markers.clear();

            if (_currentP != null) {
              _markers[MarkerId('_currentLocation')] = Marker(
                markerId: MarkerId('_currentLocation'),
                position: _currentP!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                infoWindow: InfoWindow(title: 'Your Location'),
              );
            }
          });
        }
      }
    });
  }

  void _showRequestOptions(Request request, String parentName, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Manage Help Request"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Choose an action for this request."),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _acceptRequest(request.id);
                  },
                  child: Text('Accept Request'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _cancelRequest(request.id);
                  },
                  child: Text('Reject Request'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Espace entre les lignes de boutons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _callParent(phoneNumber);
              },
              icon: Icon(Icons.phone, color: Colors.white),
              label: Text('Call Parent'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callParent(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _acceptRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('Requests').doc(requestId).update({'status': 'accepted'});
  }

  void _cancelRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('Requests').doc(requestId).update({'status': 'rejected'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Requests'),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
            onMapCreated: (GoogleMapController controller) => _mapController.complete(controller),
            initialCameraPosition: CameraPosition(
              target: _currentP ?? LatLng(0, 0),
              zoom: 13,
            ),
            markers: {
              if (_currentP != null)
                Marker(
                  markerId: MarkerId("_currentLocation"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  position: _currentP!,
                ),
            }..addAll(_markers.values.toSet()),
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
          _fetchRequests();
        }
      } else {
        print("Current location is null.");
      }
    });
  }
}
