import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/repositories/MapsRepository/MapsRepository.dart';

class MapPages extends StatefulWidget {
  const MapPages({super.key});

  @override
  State<MapPages> createState() => _MapPageState();
}

class _MapPageState extends State<MapPages> {
  Location _locationController = Location();
  final UnifiedDoctorRepository _doctorRepository = UnifiedDoctorRepository();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  LatLng? _currentP;
  Map<MarkerId, Marker> _markers = {};
  bool _isLoading = true;
  bool _hasDoctors = false;

  StreamSubscription<List<Doctor>>? _doctorSubscription;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    _fetchActiveDoctors();
  }

  @override
  void dispose() {
    _doctorSubscription?.cancel();
    super.dispose();
  }

  void _fetchActiveDoctors() {
    _doctorSubscription = _doctorRepository.getActiveDoctorsStream().listen((doctors) {
      print("Fetching active doctors...");
      if (doctors.isNotEmpty) {
        print("Active doctors found: ${doctors.length}");
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasDoctors = true;
            _markers.clear();
            for (Doctor doctor in doctors) {
              print('Doctor: ${doctor.firstName} ${doctor.lastName}, Latitude: ${doctor.latitude}, Longitude: ${doctor.longitude}');
              if (doctor.latitude != null && doctor.longitude != null) {
                print("Adding marker for doctor: ${doctor.firstName} ${doctor.lastName}");
                final markerId = MarkerId(doctor.id);
                _markers[markerId] = Marker(
                  markerId: markerId,
                  position: LatLng(doctor.latitude!, doctor.longitude!),
                  infoWindow: InfoWindow(
                    title: '${doctor.firstName} ${doctor.lastName}',
                    snippet: 'Tap to request help',
                    onTap: () {
                      _sendHelpRequest(doctor.id);
                    },
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                );
              }
            }
          });
        }
      } else {
        print("No active doctors found.");
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasDoctors = false;
          });
        }
      }
    }, onError: (error) {
      print("Error fetching active doctors: $error");
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
              _doctorRepository.sendHelpRequest("parent_id_here", doctorId); // Replace "parent_id_here" with actual parent ID
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
            child:  FloatingActionButton.extended(
              onPressed: _callAmbulance,

              label: Text("Call an ambulance"),
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
        }
      } else {
        print("Current location is null.");
      }
    });
  }
}
