import 'package:SmartBaby/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../homeDoctor/Doctor_intents.dart';
import 'ChatAi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ChatMessageScreen.dart';

class ChooseOption extends StatelessWidget {
  const ChooseOption({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(image: AssetImage(TImages.DoctorAi), height: height * 0.6,),
            Row(
              children: [
                Expanded(child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatSessionsScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    foregroundColor: Colors.pink,
                    side: BorderSide(color: Colors.pink),
                    padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                  ),
                  child: Center(
                    child: Text('Historique des messages',textAlign: TextAlign.center,),
                  ),
                )),
                SizedBox(width: 10.0,),
                Expanded(child: OutlinedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                } ,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                    ),
                    child: Text('Nouvelle     discussion', textAlign: TextAlign.center)
                )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
