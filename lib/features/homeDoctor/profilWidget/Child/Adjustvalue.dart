import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../personalization/controllers/update_value.dart';

class AdjustValuesScreen extends StatelessWidget {

  AdjustValuesScreen({Key? key}) : super(key: key);
  final UpdateVitalSignsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjust Vital Sign Values'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSlider('Minimum BPM', controller.minBpm, 0, 200),
            _buildSlider('Maximum BPM', controller.maxBpm, controller.minBpm.value, 200),
            _buildSlider('Minimum Temperature', controller.minTemp, 0, 200),
            _buildSlider('Maximum Temperature', controller.maxTemp, controller.minTemp.value, 200),
            _buildSlider('SpO2', controller.spo2, 75, 100),
            ElevatedButton(
              onPressed: () {
                if (controller.validateVitalValues()) {
                  controller.updateVitalSigns();
                }
              },
              child: const Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, Rx<double> observable, double min, double max) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Slider(
            value: observable.value,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: observable.value.round().toString(),
            onChanged: (newValue) => observable.value = newValue,
          ),
        ],
      );
    });
  }
}
