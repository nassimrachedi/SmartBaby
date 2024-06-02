import 'package:SmartBaby/features/homeDoctor/Doctor_intents.dart';
import 'package:SmartBaby/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import '../../../../utils/constants/image_strings.dart';
import 'QuestionHistory.dart';

class DoctorOptions extends StatelessWidget {
  const DoctorOptions({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(image: AssetImage(TImages.QuestRep), height: height * 0.6,),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatbotScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        foregroundColor: Colors.pink,
                        side: BorderSide(color: Colors.pink),
                        padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                      ),
                      child: Center(
                        child: Text(
                          'Questions Amélioration',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ),
                SizedBox(width: 10.0,),
                SizedBox(width: 10.0,),
                Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuestionHistoryScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.blue),
                        padding: EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
                      ),
                      child: Text(
                        'Historique Am\élioration' ,
                        textAlign: TextAlign.center,
                      ),
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