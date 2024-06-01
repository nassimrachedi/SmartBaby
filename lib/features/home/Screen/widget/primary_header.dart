import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_shapes/containers/primary_header_container.dart';
import '../../../../data/repositories/child/child_repository.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../personalization/models/children_model.dart';
import '../../../personalization/models/user_model.dart';
import 'AppBarWidget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrimaryHeader extends StatelessWidget {
  const PrimaryHeader({super.key});

  @override
  Widget build(BuildContext context) {

    return TPrimaryHeaderContainer(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appBar(),
          SizedBox(height: 20),
          FutureBuilder<UserModel>(
            future: UserRepository.instance.fetchUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('${AppLocalizations.of(context)!.error}: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('Hello, User');
              } else {
                UserModel user = snapshot.data!;
                return Text(
                  '${AppLocalizations.of(context)!.helloUser}, ${user.firstName} ${user.lastName}',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              }
            },
          ),
          SizedBox(height: 10), // Add some space between user greeting and child info
          FutureBuilder<ModelChild?>(
            future: ChildRepository().getChild(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Text(AppLocalizations.of(context)!.no_child_assigned_to_this_user);
              } else {
                ModelChild child = snapshot.data!;
                return GestureDetector(
                  onTap: () => TDeviceUtils.launchWebsiteUrl('http://192.168.62.28/'), // Modify with the dynamic URL if needed
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // This will ensure the container wraps tightly around its content
                      children: [
                        Icon(
                          Icons.baby_changing_station,
                          size: 24.0,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text(
                              AppLocalizations.of(context)!.cam,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.blue[800],
                              ),
                            ),
                            Text(
                              '${child.firstName} ${child.lastName}',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
