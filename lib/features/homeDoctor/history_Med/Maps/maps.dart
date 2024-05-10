import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsMapScreen extends StatefulWidget {
  @override
  _DoctorsMapScreenState createState() => _DoctorsMapScreenState();
}

class _DoctorsMapScreenState extends State<DoctorsMapScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleMapController? _mapController;
  final Map<MarkerId, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Médecins actifs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Doctors').where('isActive', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun médecin actif trouvé'));
          }
          _updateMarkers(snapshot.data!.docs);
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 13,
            ),
            markers: _markers.values.toSet(),
            onMapCreated: (controller) {
              _mapController = controller;
            },
          );
        },
      ),
    );
  }

  void _updateMarkers(List<QueryDocumentSnapshot> doctors) {
    setState(() {
      _markers.clear();
      for (var doc in doctors) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('lat') && data.containsKey('lng')) {
          if (data['lat'] is double && data['lng'] is double) {
            final markerId = MarkerId(doc.id);
            final marker = Marker(
              markerId: markerId,
              position: LatLng(data['lat'] as double, data['lng'] as double),
              infoWindow: InfoWindow(
                title: data['name'],
                snippet: 'Demander de l\'aide',
                onTap: () => _requestHelp(doc.id, data['name'] as String),
              ),
            );
            _markers[markerId] = marker;
          }
        }
      }
    });
  }


  void _requestHelp(String doctorId, String doctorName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Demander de l\'aide'),
        content: Text('Voulez-vous demander de l\'aide à $doctorName ?'),
        actions: [
          TextButton(
            child: Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Oui'),
            onPressed: () async {
              await _firestore.collection('Requests').add({
                'parentId': 'CURRENT_PARENT_ID', // Remplacez par l'ID du parent actuel
                'doctorId': doctorId,
                'status': 'pending',
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demande d\'aide envoyée à $doctorName')));
            },
          ),
        ],
      ),
    );
  }
}
