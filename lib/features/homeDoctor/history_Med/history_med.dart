import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../data/repositories/EtatSante/EtatSateRealTimeRepositoryMedecin.dart';
import '../../home/Screen/historique/list_box_historique.dart';
import '../../personalization/models/EtatSante_model.dart';
import 'boxs_historique_med.dart';

class HistoryMed extends StatefulWidget {
  @override
  _HistoryMedState createState() => _HistoryMedState();
}

class _HistoryMedState extends State<HistoryMed> {
  DateTime _selectedDate = DateTime.now();
  late final EtatSanteRepository3 _repository;

  @override
  void initState() {
    super.initState();
    _repository = EtatSanteRepository3();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('État de santé'),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  Text(DateFormat('yyyy-MM-dd').format(_selectedDate)), // Affiche la date sélectionnée
                  SizedBox(width: 8), // Ajouter un espace entre le texte et l'icône
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              child: listBoxHistoriqueMed(),
            ),
            FutureBuilder<Stream<Map<DateTime, EtatSante>>>(
              future: _repository.getDailyEtatSanteData(_selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text('Erreur de chargement des données'));
                }
                return StreamBuilder<Map<DateTime, EtatSante>>(
                  stream: snapshot.data!,
                  builder: (context, asyncSnapshot) {
                    if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (asyncSnapshot.hasError || !asyncSnapshot.hasData) {
                      return Center(child: Text('Erreur de chargement des données'));
                    }

                    var chartData = asyncSnapshot.data!.entries.map((entry) {
                      int hour = entry.key.hour;
                      return _ChartData(hour, entry.value.bodyTemp, entry.value.bpm, entry.value.spo2);
                    }).toList();

                    return Column( // Changed from ListView to Column
                      children: [
                        _buildTemperatureChart(chartData),
                        _buildBpmChart(chartData),
                        _buildSpo2Chart(chartData),
                        SizedBox(height: 112.5),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemperatureChart(List<_ChartData> data) {
    return _buildChartContainer(
      'Température corporelle (°C)',
      data,
          (data, _) => data.y,
      Colors.orangeAccent,
    );
  }

  Widget _buildBpmChart(List<_ChartData> data) {
    return _buildChartContainer(
      'Bpm',
      data,
          (data, _) => data.bpm.toDouble(),
      Colors.redAccent,
    );
  }

  Widget _buildSpo2Chart(List<_ChartData> data) {
    return _buildChartContainer(
      'SpO2',
      data,
          (data, _) => data.spo2.toDouble(),
      Colors.blueAccent,
    );
  }

  Widget _buildChartContainer(
      String title,
      List<_ChartData> data,
      num? Function(_ChartData, int) yValueMapper,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          minimum: 0,
          maximum: 23,
          interval: 2,
          title: AxisTitle(text: 'Heure'),
          majorGridLines: MajorGridLines(width: 0),
        ),
        title: ChartTitle(
          text: title,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        series: <CartesianSeries>[
          SplineAreaSeries<_ChartData, int>(
            dataSource: data,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: yValueMapper,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.5), Colors.transparent],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderColor: color,
            borderWidth: 2,
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class _ChartData {
  final int x;
  final double y;
  final int bpm;
  final int spo2;
  _ChartData(this.x, this.y, this.bpm, this.spo2);
}
