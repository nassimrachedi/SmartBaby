import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../personalization/controllers/update_value.dart';


class AdjustVitalSignsForm extends StatelessWidget {
  AdjustVitalSignsForm({Key? key}) : super(key: key);

  // Obtenez une instance de votre UpdateVitalSignsController
  final UpdateVitalSignsController controller = Get.put(UpdateVitalSignsController(repository: Get.find()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adjust Child Vital Signs'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Form(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                _buildTextField(
                  controller.minBpmController,
                  'Minimum BPM',
                  'Enter Minimum BPM',
                ),
                SizedBox(height: 8),
                _buildTextField(
                  controller.maxBpmController,
                  'Maximum BPM',
                  'Enter Maximum BPM',
                ),
                SizedBox(height: 8),
                _buildTextField(
                  controller.minTempController,
                  'Minimum Temperature',
                  'Enter Minimum Temperature',
                ),
                SizedBox(height: 8),
                _buildTextField(
                  controller.maxTempController,
                  'Maximum Temperature',
                  'Enter Maximum Temperature',
                ),
                SizedBox(height: 8),
                _buildTextField(
                  controller.spo2Controller,
                  'SpO2',
                  'Enter SpO2 Level',
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (controller.validateVitalValues()) {
                      controller.updateVitalSigns();
                    }
                  },
                  child: Text('Update Vital Signs'),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Field cannot be empty';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }
}
