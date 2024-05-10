import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../data/repositories/MapsRepository/MapsRepositoryDoctor.dart';
import '../../../personalization/models/user_model.dart';

class DoctorsMapScreen extends StatefulWidget {
  @override
  _DoctorsMapScreenState createState() => _DoctorsMapScreenState();
}

UnifiedDoctorRepository ss = UnifiedDoctorRepository();
class _DoctorsMapScreenState extends State<DoctorsMapScreen> {
  GoogleMapController? _mapController;
  final Map<MarkerId, Marker> _markers = {};
  LatLng? _currentUserLocation;

  @override
  void initState() {
    super.initState();
    // Suppose getActiveDoctorsStream est une méthode qui écoute les médecins actifs
    ss.getActiveDoctorsStream().listen((doctors) {
      _updateMarkers(doctors);
    });
    _trackUserLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> _trackUserLocation() async {
    // Méthode qui initialise et écoute les mises à jour de localisation
  }

  void _updateMarkers(List<Doctor> doctors) {
    setState(() {
      _markers.clear();
      for (var doctor in doctors) {
        final markerId = MarkerId(doctor.id);
        final marker = Marker(
          markerId: markerId,
          position: LatLng(doctor.lat!, doctor.lng!),
          infoWindow: InfoWindow(
            title: '${doctor.lastName}',
            snippet: 'Cliquez pour demander de l\'aide',
            onTap: () => _sendHelpRequest(doctor),
          ),
        );
        _markers[markerId] = marker;
      }
    });
  }

  void _sendHelpRequest(Doctor doctor) {
    // Envoyez une demande d'aide ici
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Médecins actifs')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentUserLocation ?? LatLng(37.7749, -122.4194),
          zoom: 13,
        ),
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}
