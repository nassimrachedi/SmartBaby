import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/EtatSante/EtatSante_repository.dart';
import '../../../personalization/models/EtatSante_model.dart';
import '../../../personalization/models/children_model.dart';

class HomePageV extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageV> {
  late RepositorySignVitauxVlues repository;
  late Stream<EtatSante?> etatSanteStream;
  ModelChild? currentChild;

  @override
  void initState() {
    super.initState();
    repository = RepositorySignVitauxVlues();
    repository.getChild().then((child) {
      setState(() {
        currentChild = child;
      });
    });
    etatSanteStream = repository.getEtatSanteStreamForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EtatSante?>(
      stream: etatSanteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error.toString()}', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData) {
          return Center(child: Text('Associer un bracelet à l\'enfant choisi', style: TextStyle(color: Colors.grey)));
        } else {
          final etatSante = snapshot.data;
          if (etatSante == null) {
            return Center(child: Text('Les données de santé ne sont pas disponibles.', style: TextStyle(color: Colors.grey)));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SensorCard(
                  value: etatSante.bodyTemp.toStringAsFixed(2),
                  unit: '°C',
                  name: 'Température corporelle',
                  icon: Icons.thermostat_outlined,
                  backgroundColor: Colors.orange.shade50,
                  accentColor: Colors.orange,
                  min: currentChild?.minTemp.toString() ?? 'N/A',
                  max: currentChild?.maxTemp.toString() ?? 'N/A',
                ),
                SensorCard(
                  value: etatSante.bpm.toString(),
                  unit: 'BPM',
                  name: 'Rythme cardiaque',
                  icon: Icons.favorite_outline,
                  backgroundColor: Colors.red.shade50,
                  accentColor: Colors.red,
                  min: currentChild?.minBpm.toString() ?? 'N/A',
                  max: currentChild?.maxBpm.toString() ?? 'N/A',
                ),
                SensorCard(
                  value: etatSante.spo2.toString(),
                  unit: '%',
                  name: 'Oxygène',
                  icon: Icons.opacity,
                  backgroundColor: Colors.green.shade50,
                  accentColor: Colors.green,
                  min: currentChild?.spo2.toString() ?? 'N/A',
                  max: "100",
                ),
                SensorCard(
                  value: etatSante.temp.toStringAsFixed(2),
                  unit: '°C',
                  name: 'Température',
                  icon: Icons.thermostat_outlined,
                  backgroundColor: Colors.lightBlue.shade100,
                  accentColor: Colors.blueAccent,
                  min: '15',
                  max: "35",
                ),
                SensorCard(
                  value: etatSante.humidity.toString(),
                  unit: '%',
                  name: 'Humidité',
                  icon: Icons.water_damage_outlined,
                  backgroundColor: Colors.lightBlue.shade100,
                  accentColor: Colors.blueAccent,
                  min: 'N/A',
                  max: 'N/A',
                ),
                if (etatSante.heure != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Dernière mise à jour: ${DateFormat('HH:mm:ss').format(etatSante.heure!)}',
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                SizedBox(height: 70),
              ],
            ),
          );
        }
      },
    );
  }
}

class SensorCard extends StatelessWidget {
  final String value;
  final String unit;
  final String name;
  final IconData icon;
  final Color backgroundColor;
  final Color accentColor;
  final String min;
  final String max;

  SensorCard({
    Key? key,
    required this.value,
    required this.unit,
    required this.name,
    required this.icon,
    required this.backgroundColor,
    required this.accentColor,
    required this.min,
    required this.max,
  }) : super(key: key);

  bool isValueInRange() {
    final doubleValue = double.tryParse(value) ?? 0;
    final doubleMin = double.tryParse(min) ?? double.negativeInfinity;
    final doubleMax = double.tryParse(max) ?? double.infinity;
    return doubleValue >= doubleMin && doubleValue <= doubleMax;
  }

  double getProgressValue() {
    final doubleValue = double.tryParse(value) ?? 0;
    final doubleMin = double.tryParse(min) ?? 0;
    final doubleMax = double.tryParse(max) ?? 100;
    if (doubleMax - doubleMin == 0) return 0;
    return (doubleValue - doubleMin) / (doubleMax - doubleMin);
  }

  @override
  Widget build(BuildContext context) {
    final isInRange = isValueInRange();
    final valueColor = isInRange ? Colors.black : Colors.redAccent;
    final progressValue = getProgressValue();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 30),
              SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.white24,
            color: accentColor,
            minHeight: 5,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$value $unit',
                style: TextStyle(
                  color: valueColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Min: $min $unit',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Max: $max $unit',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
