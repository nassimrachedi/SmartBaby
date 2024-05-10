import 'package:flutter/material.dart';

import '../../../data/repositories/DoctorRepos/DoctorRepository.dart';

class DoctorActiveSwitch extends StatefulWidget {
  @override
  _DoctorActiveSwitchState createState() => _DoctorActiveSwitchState();
}

class _DoctorActiveSwitchState extends State<DoctorActiveSwitch> {
  final DoctorRepository doctorRepository = DoctorRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: doctorRepository.isActiveStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          // Gestion du cas où il n'y a pas encore de données.
          return CircularProgressIndicator();
        }
        final bool isActive = snapshot.data ?? false;
        return SwitchListTile(
          value: isActive,
          onChanged: (bool value) {
            doctorRepository.updateDoctorStatus(value);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    doctorRepository.dispose();
    super.dispose();
  }
}
