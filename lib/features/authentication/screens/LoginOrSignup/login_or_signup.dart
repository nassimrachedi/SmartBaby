import 'package:SmartBaby/app.dart';
import 'package:SmartBaby/features/authentication/screens/LoginMed/login_med.dart';
import 'package:SmartBaby/features/authentication/screens/SignUpMed/signup_med.dart';
import 'package:SmartBaby/features/authentication/screens/login/login.dart';
import 'package:SmartBaby/features/authentication/screens/signup/signup.dart';
import 'package:SmartBaby/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginSignupPage extends StatelessWidget {
  final UserRole role;

  const LoginSignupPage({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (role == UserRole.parent) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else if (role == UserRole.doctor) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreenMed()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
              ),
              child: Text(
                AppLocalizations.of(context)!.login,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                if (role == UserRole.parent) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupParentScreen(role: role)),
                  );
                } else if (role == UserRole.doctor) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupMedScreen(role: role)),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
              ),
              child: Text(
                AppLocalizations.of(context)!.signup,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
