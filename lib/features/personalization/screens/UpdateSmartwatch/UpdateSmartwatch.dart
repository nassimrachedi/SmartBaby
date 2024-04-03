import 'package:flutter/material.dart';

import '../../../../data/repositories/child/child_repository.dart';
import '../../controllers/children_controller.dart';

class SmartwatchUpdateFormPage extends StatefulWidget {
  @override
  _SmartwatchUpdateFormPageState createState() => _SmartwatchUpdateFormPageState();
}

class _SmartwatchUpdateFormPageState extends State<SmartwatchUpdateFormPage> {
  final TextEditingController _smartwatchIdController = TextEditingController();
  final ChildController _childController = ChildController();

  @override
  void dispose() {
    _smartwatchIdController.dispose();
    super.dispose();
  }

  void _updateSmartwatchId() {
    final newSmartwatchId = _smartwatchIdController.text.trim();
    if (newSmartwatchId.isNotEmpty) {
      _childController.updateChildSmartwatchId(context, newSmartwatchId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer l\'ID de la smartwatch.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mettre à jour l\'ID de la smartwatch'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _smartwatchIdController,
              decoration: InputDecoration(
                labelText: 'ID de la Smartwatch',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateSmartwatchId,
              child: Text('Mettre à jour'),
            ),
          ],
        ),
      ),
    );
  }
}
