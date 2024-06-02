import 'package:SmartBaby/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:SmartBaby/features/home/Screen/historique/historique.dart';
import 'package:SmartBaby/features/home/Screen/widget/AppBarWidget.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import 'Session.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


final authRepo = AuthenticationRepository.instance;
final String displayName = authRepo.getUserID;

class primary_header_Med extends StatelessWidget {
  const primary_header_Med({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TPrimaryHeaderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBar(),
          Padding(
            padding: const EdgeInsets.only(left: 30.0), // Ajouter un padding à gauche du Column
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: FutureBuilder<UserModel>(
                    future: UserRepository.instance.fetchUserDetails(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Indicateur de chargement pendant la récupération des données
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text('Hello, User');
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              '${ AppLocalizations.of(context)!.hellodr}, ${snapshot.data!.fullName}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset('assets/application/doctors.png', width: 90, height: 90),

                          ],
                        );

                      }

                    },
                  ),
                ),
                SizedBox(height: 30,)
              ],
            ),

          ),
          DoctorActiveSwitch(),

        ],

      ),

    );
  }
}
