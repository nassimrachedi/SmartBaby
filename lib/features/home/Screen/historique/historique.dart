import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'data_classe.dart';
import 'list_box_historique.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({Key? key}) : super(key: key);

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  List<TemperatureData> _temperatureData = [];
  List<HeartRateData> _heartRateData = [];
  List<SpO2Data> _spo2Data = [];


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
            Column(children: [
              SizedBox(
                  height: 60,
                  child: ListBoxHistorique(),
              )
            ],),
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
                series: <CartesianSeries<dynamic, dynamic>>[
                  LineSeries<TemperatureData, DateTime>(
                    dataSource: _temperatureData,
                    xValueMapper: (data, _) => data.date,
                    yValueMapper: (data, _) => data.temperature,
                    name: 'Température (°C)',
                    color: Colors.red,
                    markerSettings: MarkerSettings(isVisible: true),
                  ),
                ],
                primaryXAxis: DateTimeAxis(
                  minimum: DateTime.now().subtract(Duration(hours: 24)),
                  maximum: DateTime.now(),
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
                series: <CartesianSeries<dynamic, dynamic>>[
                  LineSeries<HeartRateData, DateTime>(
                    dataSource: _heartRateData,
                    xValueMapper: (data, _) => data.date,
                    yValueMapper: (data, _) => data.heartRate,
                    name: AppLocalizations.of(context)!.heartRateHistory,
                    color: Colors.green,
                    markerSettings: MarkerSettings(isVisible: true),
                  ),
                ],
                primaryXAxis: DateTimeAxis(
                  minimum: DateTime.now().subtract(Duration(hours: 24)),
                  maximum: DateTime.now(),
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
                series: <CartesianSeries<dynamic, dynamic>>[
                  LineSeries<SpO2Data, DateTime>(
                    dataSource: _spo2Data,
                    xValueMapper: (data, _) => data.date,
                    yValueMapper: (data, _) => data.spo2,
                    name: 'SpO2 (%)',
                    color: Colors.blue,
                    markerSettings: MarkerSettings(isVisible: true),
                  ),
                ],
                primaryXAxis: DateTimeAxis(
                  minimum: DateTime.now().subtract(Duration(hours: 24)),
                  maximum: DateTime.now(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }

