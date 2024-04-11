import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/repositories/EtatSante/EtatSante_repository.dart';
import '../../../personalization/models/EtatSante_model.dart';

class HomePageV extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageV> {
  late RepositorySignVitauxVlues repository;
  late Stream<EtatSante?> etatSanteStream;

  @override
  void initState() {
    super.initState();
    repository = RepositorySignVitauxVlues();
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
          return Center(child: Text('Aucune donnée disponible pour le moment.', style: TextStyle(color: Colors.grey)));
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
                ),
                MySensorCard(
                  value: etatSante.bpm.toString(),
                  unit: 'BPM',
                  name: 'Rythme cardiaque',
                  iconPath: 'assets/application/bpm.png',
                ),
                MySensorCard(
                  value: etatSante.temp.toStringAsFixed(2),
                  unit: '°C',
                  name: 'Température',
                  iconPath: 'assets/application/Temperature.png',
                ),
                MySensorCard(
                  value: etatSante.spo2.toString(),
                  unit: '%',
                  name: 'Oxygène',
                  iconPath: 'assets/application/Spo2.png',
                ),
                MySensorCard(
                  value: etatSante.humidity.toString(),
                  unit: '%',
                  name: 'Humidité',
                  iconPath: 'assets/application/humm.png',
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

  MySensorCard({
    Key? key,
    required this.value,
    required this.unit,
    required this.name,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        leading: Image.asset(iconPath),
        title: Text(name, style: TextStyle(fontSize: 18)),
        subtitle: Text('$value $unit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
