import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import '../../../data/repositories/DoctorRepos/DoctorRepository.dart';

class DoctorActiveSwitch extends StatefulWidget {
  @override
  _DoctorActiveSwitchState createState() => _DoctorActiveSwitchState();
}

class _DoctorActiveSwitchState extends State<DoctorActiveSwitch> {
  final DoctorRepository doctorRepository = DoctorRepository();
  final Location location = Location();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: doctorRepository.isActiveStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final bool isActive = snapshot.data ?? false;
        return SwitchListTile(
          title: Text('Activate/Deactivate Session'),
          value: isActive,
          onChanged: (bool value) async {
            if (value) {
              await _updateLocationAndStatus();
            } else {
              await _updateDoctorStatus(false);
            }
          },
        );
      },
    );
  }

  Future<void> _updateLocationAndStatus() async {
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    _updateDoctorStatus(true, locationData.latitude, locationData.longitude);
  }

  Future<void> _updateDoctorStatus(bool isActive, [double? latitude, double? longitude]) async {
    String doctorId = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> data = {'isActive': isActive};
    if (latitude != null && longitude != null) {
      data.addAll({'latitude': latitude, 'longitude': longitude});
    }

    await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorId)
        .update(data)
        .catchError((error) {
      print('Error updating doctor status: $error');
    });
  }

  @override
  void dispose() {
    doctorRepository.dispose();
    super.dispose();
  }
}
