import 'package:SmartBaby/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:SmartBaby/features/home/Screen/Maps/pages/map_page.dart';
import 'package:SmartBaby/utils/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../personalization/models/user_model.dart';
import 'AppBarWidget.dart';

final authRepo = AuthenticationRepository.instance;
final String displayName = authRepo.getUserID;

class primary_header extends StatelessWidget {
  const primary_header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TPrimaryHeaderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          appBar(),
          SizedBox(height: 40), // Espacement entre la barre de recherche et les boutons
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<UserModel>(
                  future: UserRepository.instance.fetchUserDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Indicateur de chargement pendant la récupération des données
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return Text('Hello, User');
                    } else {
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Bonjour, ${snapshot.data!.fullName}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            WidgetSpan(
                              child: SizedBox(height: TSizes.spaceBtwItems), // Ajoute de l'espace
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => TDeviceUtils.launchWebsiteUrl('http://192.168.62.28/'),
                                child: Row(
                                  children: [
                                    SizedBox(height: 100),
                                    Text(
                                      ' Open Cam ',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Image.asset(
                                      'assets/logos/CamBaby.png',
                                      height: 40.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
