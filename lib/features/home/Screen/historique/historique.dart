import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../data/repositories/EtatSante/EtatSanteRealTime_repository.dart';
import '../../../personalization/models/EtatSante_model.dart';
import 'list_box_historique.dart';

class EtatSantePage extends StatefulWidget {
  @override
  _EtatSantePageState createState() => _EtatSantePageState();
}

class _EtatSantePageState extends State<EtatSantePage> {
  DateTime _selectedDate = DateTime.now();
  late final EtatSanteRepository2 _repository;

  @override
  void initState() {
    super.initState();
    _repository = EtatSanteRepository2();
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
              child: ListBoxHistorique(),
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

                    var chartData = _generateHourlyData(asyncSnapshot.data!);

                    return Column(
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

  List<_ChartData> _generateHourlyData(Map<DateTime, EtatSante> data) {
    List<_ChartData> chartData = List.generate(24, (index) {
      DateTime hour = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, index);
      EtatSante? etatSante = data[hour];
      return _ChartData(
        DateFormat.Hm().format(hour),
        etatSante?.bodyTemp ?? 0.0,
        etatSante?.bpm ?? 0,
        etatSante?.spo2 ?? 0,
        index, // Set 'x' to the current index (hour)
      );
    });
    return chartData;
  }

  Widget _buildTemperatureChart(List<_ChartData> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GraphDetailPage(
              title: 'Température corporelle (°C)',
              data: data,
              color: Colors.amberAccent,
              yValueMapper: (item) => item.bodyTemp,
            ),
          ),
        );
      },
      child: Column(
        children: [
        _buildChartContainer(
        'Température corporelle (°C)',
        data,
            (data, _) => data.bodyTemp,
        Colors.orangeAccent,
           ),
        ],
      ),
    );
  }

  Widget _buildBpmChart(List<_ChartData> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GraphDetailPage(
              title: 'Bpm',
              data: data,
              color: Colors.redAccent,
              yValueMapper: (item) => item.bpm.toDouble(),
            ),
          ),
        );
      },
      child: Column(
        children: [
        _buildChartContainer(
        'Bpm',
        data,
            (data, _) => data.bpm.toDouble(),
        Colors.redAccent,
        ),
        ],
      ),
    );
  }

  Widget _buildSpo2Chart(List<_ChartData> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GraphDetailPage(
              title: 'SpO2 (%)',
              data: data,
              color: Colors.blueAccent,
              yValueMapper: (item) => item.spo2.toDouble(),
            ),
          ),
        );
      },
      child: Column(
        children: [
        _buildChartContainer(
        'SpO2',
        data,
            (data, _) => data.spo2.toDouble(),
        Colors.blueAccent,
         ),
        ],
      ),
    );
  }

  String _formatHour(int hour) {
    if (hour == 0) return '00:00';
    if (hour < 10) return '0$hour:00';
    return '$hour:00';
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
          xValueMapper: (_ChartData data, _) =>  data.x,
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




class _ChartData {
  final String hour;
  final double bodyTemp;
  final int bpm;
  final int spo2;
  final double value;
  final int x;


  _ChartData(this.hour, this.bodyTemp, this.bpm, this.spo2, this.x) : value = 0;
  _ChartData.value(this.hour, this.value, this.x,)
      : bodyTemp = 0,
        bpm = 0,
        spo2 = 0;
}


class GraphDetailPage extends StatelessWidget {
  final String title;
  final List<_ChartData> data;
  final Color color;
  final double Function(_ChartData) yValueMapper;

  GraphDetailPage({
    required this.title,
    required this.data,
    required this.color,
    required this.yValueMapper,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 1200, // Largeur ajustée pour permettre le défilement horizontal
          child: SfCartesianChart(
            title: ChartTitle(text: title),
            primaryXAxis: CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
              labelRotation: 0,
              labelStyle: TextStyle(fontSize: 12),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: MajorGridLines(color: Colors.grey[200]),
            ),
            series: <ColumnSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.hour,
                yValueMapper: (data, _) => yValueMapper(data),
                color: color,
                width: 0.8,
                spacing: 0.2,
                dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
