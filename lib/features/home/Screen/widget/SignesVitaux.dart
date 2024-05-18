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
          return Center(child: Text('associer un bracelet a l \'enfant choisi', style: TextStyle(color: Colors.grey)));
        } else {
          final etatSante = snapshot.data;
          if (etatSante == null) {
            return Center(child: Text('Les données de santé ne sont pas disponibles.', style: TextStyle(color: Colors.grey)));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MySensorCard(
                  value: etatSante.bodyTemp.toStringAsFixed(2),
                  unit: '°C',
                  name: 'Température corporelle',
                  iconPath: 'assets/application/tempcorp.png',
                  min: currentChild?.minTemp.toString() ?? 'N/A',
                  max: currentChild?.maxTemp.toString() ?? 'N/A',
                ),

                MySensorCard(
                  value: etatSante.bpm.toString(),
                  unit: 'BPM',
                  name: 'Rythme cardiaque',
                  iconPath: 'assets/application/bpm.png',
                  min: currentChild?.minBpm.toString() ?? 'N/A',
                  max: currentChild?.maxBpm.toString() ?? 'N/A',
                ),
                MySensorCard(
                  value: etatSante.spo2.toString(),
                  unit: '%',
                  name: 'Oxygène',
                  iconPath: 'assets/application/Spo2.png',
                  min: currentChild?.spo2.toString() ?? 'N/A',
                  max: "100",
                ),
                MySensorCard(
                  value: etatSante.temp.toStringAsFixed(2),
                  unit: '°C',
                  name: 'Température',
                  iconPath: 'assets/application/Temperature.png',
                  min: currentChild?.minTemp.toString() ?? 'N/A',
                  max: currentChild?.maxTemp.toString() ?? 'N/A',
                ),
                MySensorCard(
                  value: etatSante.humidity.toString(),
                  unit: '%',
                  name: 'Humidité',
                  iconPath: 'assets/application/humm.png',
                  min:  'N/A',
                  max:  'N/A',
                ),
                if (etatSante.heure != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'Dernière mise à jour: ${DateFormat('HH:mm:ss').format(etatSante.heure!)}',
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
              ],
            ),
          );
        }
      },
    );
  }
}
class MySensorCard extends StatelessWidget {
  final String value;
  final String unit;
  final String name;
  final String iconPath;
  final String min;
  final String max;

  MySensorCard({
    Key? key,
    required this.value,
    required this.unit,
    required this.name,
    required this.iconPath,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        splashColor: Colors.deepPurple.withAlpha(30),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple.shade50,
                child: Image.asset(iconPath, width: 36),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$value $unit',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Range: $min - $max $unit',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleSensorCard extends StatelessWidget {
  final String value;
  final String unit;
  final String iconPath;

  SimpleSensorCard({
    Key? key,
    required this.value,
    required this.unit,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple.shade50,
                child: Image.asset(iconPath, width: 36),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$value $unit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
