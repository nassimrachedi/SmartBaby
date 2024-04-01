import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'boxs_historique_med.dart';

class HistoryMed extends StatefulWidget {
  const HistoryMed({Key? key}) : super(key: key);

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoryMed> {
  late DateTime _minimumDateTime;
  late DateTime _maximumDateTime;

  @override
  void initState() {
    super.initState();
    _minimumDateTime = DateTime.now().subtract(Duration(hours: 24));
    _maximumDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.history),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 60,
                  child: listBoxHistoriqueMed(),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: AppLocalizations.of(context)!.temperatureHistory,
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                primaryXAxis: DateTimeAxis(
                  minimum: _minimumDateTime,
                  maximum: _maximumDateTime,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: AppLocalizations.of(context)!.heartRateHistory,
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                primaryXAxis: DateTimeAxis(
                  minimum: _minimumDateTime,
                  maximum: _maximumDateTime,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: AppLocalizations.of(context)!.spo2History,
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                primaryXAxis: DateTimeAxis(
                  minimum: _minimumDateTime,
                  maximum: _maximumDateTime,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
