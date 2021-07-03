import 'package:wetune/theme/darkThemeModel.dart';
import 'package:wetune/theme/jam_icons_icons.dart';
import 'package:wetune/theme/theme.dart';
import 'package:wetune/theme/themeModeProvider.dart';
import 'package:animations/animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void showChangelog(BuildContext context, Function func) {
  final controller = ScrollController();
  final AlertDialog aboutPopUp = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    content: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColor),
      width: MediaQuery.of(context).size.width * .78,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width * .78,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Theme.of(context).hintColor),
            child: const FlareActor(
              "assets/animations/Changelog.flr",
              animation: "changelog",
            ),
          ),
          SizedBox(
            height: 300,
            child: Scrollbar(
              radius: const Radius.circular(500),
              thickness: 5,
              controller: controller,
              isAlwaysShown: true,
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    ChangeVersion(number: 'v2.6.6'),
                    Change(
                        icon: JamIcons.bug,
                        text: "Minor bug fixes and improvements."),
                    ChangeVersion(number: 'v2.6.5'),
                    Change(
                        icon: JamIcons.user,
                        text: "Improved overall user experience."),
                    Change(
                        icon: JamIcons.bug,
                        text: "Major bug fixes and improvements."),
                    ChangeVersion(number: 'v2.6.4'),
                    Change(
                        icon: JamIcons.bell,
                        text: "Get notified when people you follow post."),
                    Change(
                        icon: JamIcons.shuffle,
                        text:
                            "Quickly change wallpaper, with quick tile. Changes wallpaper from the downloaded ones."),
                    Change(
                        icon: JamIcons.eye,
                        text: "New Splash screen animation."),
                    Change(
                        icon: JamIcons.users,
                        text: "Added option to turn followers feed off."),
                    Change(
                        icon: JamIcons.bug,
                        text: "Minor bug fixes and improvements."),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () {
          launch("https://bit.ly/prismchanges");
          func();
        },
        child: Text(
          'VIEW FULL',
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).errorColor,
          ),
        ),
      ),
      FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Theme.of(context).errorColor,
        onPressed: () {
          Navigator.of(context).pop();
          func();
        },
        child: const Text(
          'CLOSE',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    ],
    contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
    backgroundColor: Theme.of(context).primaryColor,
    actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  );
  showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) => aboutPopUp);
}

class ChangeVersion extends StatelessWidget {
  final String number;
  const ChangeVersion({required this.number});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 0, 4),
              child: Text(
                number,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class Change extends StatelessWidget {
  final IconData icon;
  final String text;
  const Change({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            Icon(
              icon,
              size: 22,
              color: Provider.of<ThemeModeExtended>(context)
                              .getCurrentModeStyle(
                                  MediaQuery.of(context).platformBrightness) ==
                          "Dark" &&
                      Provider.of<DarkThemeModel>(context).currentTheme ==
                          kDarkTheme2
                  ? Theme.of(context).errorColor == Colors.black
                      ? Theme.of(context).accentColor
                      : Theme.of(context).errorColor
                  : Theme.of(context).errorColor,
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
