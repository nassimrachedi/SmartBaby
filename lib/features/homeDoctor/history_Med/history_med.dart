import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../data/repositories/EtatSante/EtatSateRealTimeRepositoryMedecin.dart';
import '../../home/Screen/historique/list_box_historique.dart';
import '../../personalization/models/EtatSante_model.dart';
import 'boxs_historique_med.dart';


class HistoryMed extends StatefulWidget {
  @override
  _EtatSantePageState createState() => _EtatSantePageState();
}

class _EtatSantePageState extends State<HistoryMed> {
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
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Température corp(°C)'),
      series: <ColumnSeries<_ChartData, int>>[
        ColumnSeries<_ChartData, int>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          color: Colors.amberAccent,
        ),
      ],
    );
  }
  Widget _buildBpmChart(List<_ChartData> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      title: ChartTitle(text: 'Bpm'),
      series: <ColumnSeries<_ChartData, int>>[
        ColumnSeries<_ChartData, int>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.bpm,
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildSpo2Chart(List<_ChartData> data) {
    return Container(
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        title: ChartTitle(text: 'SpO2'),
        series: <ColumnSeries<_ChartData, int>>[
          ColumnSeries<_ChartData, int>(
            dataSource: data,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.Spo2,
            color: Colors.blueAccent,
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
  final int Spo2;
  _ChartData(this.x, this.y,this.bpm,this.Spo2);
}
