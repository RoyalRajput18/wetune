import 'package:wetune/main.dart' as main;
import 'package:wetune/theme/jam_icons_icons.dart';
import 'package:wetune/ui/widgets/popup/signInPopUp.dart';
import 'package:wetune/routes/routing_constants.dart';
import 'package:flutter/material.dart';
import 'package:wetune/global/globals.dart' as globals;

class PremiumList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (globals.prismUser.premium == true)
          Container()
        else
          ListTile(
            onTap: () {
              if (globals.prismUser.loggedIn == false) {
                googleSignInPopUp(context, () {
                  if (globals.prismUser.premium == true) {
                    main.RestartWidget.restartApp(context);
                  } else {
                    Navigator.pushNamed(context, premiumRoute);
                  }
                });
              } else {
                Navigator.pushNamed(context, premiumRoute);
              }
            },
            leading: const Icon(JamIcons.instant_picture_f),
            title: Text(
              "Buy Premium",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Proxima Nova"),
            ),
            subtitle: const Text(
              "Get unlimited setups and filters.",
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}
