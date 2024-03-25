import 'package:SmartBaby/features/homeDoctor/history_Med/boxs_historique_med.dart';
import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class HistoryMed extends StatefulWidget {
  const HistoryMed({Key? key}) : super(key: key);

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoryMed> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(children: [
              SizedBox(
                height: 60,
                child: listBoxHistoriqueMed(),
              )
            ],),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: SfCartesianChart(
                title: ChartTitle(
                  text: 'Historique de la température',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

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
                  text: 'Historique de la fréquence cardiaque',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

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
                  text: 'Historique de la SpO2',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                primaryXAxis: DateTimeAxis(
                  minimum: DateTime.now().subtract(Duration(hours: 24)),
                  maximum: DateTime.now(),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}

