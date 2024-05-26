import 'package:SmartBaby/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import '../../../../../data/repositories/Maladie/maladieRepository.dart';
import 'DetailsMaladies.dart';

class Maladies extends StatelessWidget {
  final ChildMaladieRepository maladiesRepository = ChildMaladieRepository();

  @override
  Widget build(BuildContext context) {
    Color background =Colors.white;
    // Styling for the cards
    var cardStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    );

    // Styling for subtitles
    var subtitleStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 16,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context)!.diseases}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Container(
        color: background,
        child: StreamBuilder<List<Maladie>>(
          stream: maladiesRepository.streamMaladiesPrents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('${AppLocalizations.of(context)!.loadingError}: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noDiseaseFound));
            } else {
              List<Maladie> maladies = snapshot.data!;
              return ListView.builder(
                itemCount: maladies.length,
                itemBuilder: (context, index) {
                  Maladie maladie = maladies[index];
                  return Card(
                    color: Colors.blue.shade50,
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    elevation: 2, // Adding elevation for depth
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.coronavirus_outlined, size: 40, color: Colors.blue.shade800),
                      title: Text(maladie.nom, style: cardStyle),
                      subtitle: Text(' ${AppLocalizations.of(context)!.type}: ${maladie.type}',
                          style: subtitleStyle),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              DetailsMaladie(maladie: maladie)),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
