import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../personalization/controllers/update_value.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdjustValuesScreen extends StatelessWidget {

  AdjustValuesScreen({Key? key}) : super(key: key);
  final UpdateVitalSignsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.adjustvital),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSlider( AppLocalizations.of(context)!.maxbpm, controller.minBpm, 0, 200),
            _buildSlider( AppLocalizations.of(context)!.maxbpm, controller.maxBpm, controller.minBpm.value, 200),
            _buildSlider( AppLocalizations.of(context)!.mintemp, controller.minTemp, 0, 200),
            _buildSlider( AppLocalizations.of(context)!.maxtemp, controller.maxTemp, controller.minTemp.value, 200),
            _buildSlider( AppLocalizations.of(context)!.spo2, controller.spo2, 75, 100),
            ElevatedButton(
              onPressed: () {
                if (controller.validateVitalValues()) {
                  controller.updateVitalSigns();
                }
              },
              child: Text( AppLocalizations.of(context)!.update),
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
