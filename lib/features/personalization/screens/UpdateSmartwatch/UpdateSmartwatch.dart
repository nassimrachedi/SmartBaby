import 'package:flutter/material.dart';
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
      _checkAndUpdateSmartwatchId(newSmartwatchId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer l\'ID du bracelet connecté.')),
      );
    }
  }

  Future<void> _checkAndUpdateSmartwatchId(String newSmartwatchId) async {
    final bool isSmartwatchAssociated = await _childController.isSmartwatchAssociatedToChild();

    if (isSmartwatchAssociated) {
      _showConfirmationDialog(newSmartwatchId);
    } else {
      _childController.updateChildSmartwatchId(context, newSmartwatchId);
    }
  }

  void _showConfirmationDialog(String newSmartwatchId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bracelet déjà associé'),
          content: Text('Une smartwatch est déjà associée à cet enfant. Voulez-vous l\'écraser ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Écraser', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _childController.updateChildSmartwatchId(context, newSmartwatchId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bracelet connecté', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/application/smartwatch.png',
                  height: 100,
                ),
                SizedBox(height: 10),
                Text(
                  'Associer le bracelet connecté',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _smartwatchIdController,
              decoration: InputDecoration(
                labelText: 'ID du bracelet',
                hintText: 'Entrez l\'ID du bracelet',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.watch, color: Colors.blueAccent),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateSmartwatchId,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Enregistrer',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
