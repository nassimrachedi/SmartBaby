import 'package:SmartBaby/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/image_strings.dart';
import 'ChatAi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Column(
              children: [
                Text(AppLocalizations.of(context)!.chooseOption, style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,),
              ],
            ),
            Row(
              children: [
                Expanded(child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Container()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    foregroundColor: Colors.pink,
                    side: BorderSide(color: Colors.pink),
                    padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                  ),
                  child: Text(AppLocalizations.of(context)!.doctorAi),
                )),
                SizedBox(width: 10.0,),
                Expanded(child: OutlinedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatAi()),
                  );
                } ,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                    ),
                    child: Text(AppLocalizations.of(context)!.chatBot)
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
