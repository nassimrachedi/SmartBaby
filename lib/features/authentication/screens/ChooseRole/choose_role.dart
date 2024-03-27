import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:SmartBaby/features/authentication/screens/LoginOrSignup/login_or_signup.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:SmartBaby/data/repositories/authentication/authentication_repository.dart';

class ChooseYourRole extends StatelessWidget {
  const ChooseYourRole({Key? key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage('assets/application/imageDegardeP.png'),
              height: height * 0.6,
            ),
            Column(
              children: [
                Text(
                  'Choose your role',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline3
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Are you",
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      navigateToScreen(context, UserRole.parent);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.pink,
                      side: BorderSide(color: Colors.pink),
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text("Parent"),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      navigateToScreen(context, UserRole.doctor);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      padding: EdgeInsets.symmetric(vertical: 20),
                    ),
                    child: Text("Doctor"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void navigateToScreen(BuildContext context, UserRole role) {
    final authRepo = AuthenticationRepository.instance;
    authRepo.saveUserRole(role); // Enregistrer le rôle sélectionné
    Get.off(() => LoginSignupPage(role: role));
  }
}
