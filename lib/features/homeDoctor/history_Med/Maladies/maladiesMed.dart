import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/MaladieModel.dart';
import '../../../../data/repositories/Maladie/maladieRepository.dart';
import 'DetailsMaladiePage.dart';
import 'AjouterMaladie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListMaladiesMedWidget extends StatelessWidget {
  final ChildMaladieRepository maladiesRepository = ChildMaladieRepository();

  @override
  Widget build(BuildContext context) {

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
        elevation: 0, // Removing elevation for a flatter design
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<List<Maladie>>(
          stream: maladiesRepository.streamMaladies(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('${AppLocalizations.of(context)!.loadingError}: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noDiseaseFound));
            } else {
              List<Maladie> maladies = snapshot.data!;
              return ListView.builder(
                itemCount: maladies.length,
                itemBuilder: (context, index) {
                  Maladie maladie = maladies[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 2, // Adding elevation for depth
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blue.shade50,
                    child: ListTile(
                      leading: Icon(Icons.coronavirus_outlined, size: 40, color:Colors.blue),
                      title: Text(maladie.nom, style:
                      TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      ),
                      subtitle: Text(' ${AppLocalizations.of(context)!.type}: ${maladie.type}', style:  TextStyle(color: Colors.black54) ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.purple),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailsMaladiePage(maladie: maladie)),
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
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        backgroundColor:  Color(0xffc8d8fc),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterMaladie()),
          );
        },
        icon: Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addDisease, style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
