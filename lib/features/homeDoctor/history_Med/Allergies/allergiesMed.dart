import 'package:flutter/material.dart';
import 'package:SmartBaby/features/personalization/models/AllergieModel.dart';
import '../../../../data/repositories/allergieRep/allergieRepository.dart';
import 'AjouterAllergie.dart';
import 'DetailsAllergie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListAllergiesWidget extends StatelessWidget {
  final ChildAllergieRepository allergieRepository = ChildAllergieRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.allergies_title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: Colors.white, height: 1.0),
        ),
      ),
      body: StreamBuilder<List<Allergie>>(
        stream: allergieRepository.streamAllergie(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${AppLocalizations.of(context)!.loadingError}: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.no_allergy_found));
          }

          List<Allergie> allergies = snapshot.data!;
          return ListView.builder(
            itemCount: allergies.length,
            itemBuilder: (context, index) {
              Allergie allergie = allergies[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade50.withOpacity(0.5)),
                ),
                child: ListTile(
                  leading: Icon(Icons.coronavirus_outlined, size: 40, color:Colors.black),

                  title: Text(
                    allergie.nom,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    '${AppLocalizations.of(context)!.type}: ${allergie.type}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailsAllergiePage(allergie: allergie)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newAllergie = await Navigator.push<Allergie?>(
            context,
            MaterialPageRoute(builder: (context) => AjouterAllergie()),
          );


        },
        icon: Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.add_allergy, style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor:  Color(0xffc8d8fc),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
