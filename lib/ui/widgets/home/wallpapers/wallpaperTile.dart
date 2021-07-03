import 'package:wetune/routes/routing_constants.dart';
import 'package:wetune/theme/themeModeProvider.dart';
import 'package:wetune/ui/widgets/home/wallpapers/wallpaperGrid.dart';
import 'package:wetune/ui/widgets/popup/signInPopUp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wetune/data/prism/provider/prismWithoutProvider.dart' as Data;
import 'package:provider/provider.dart';
import 'package:wetune/global/globals.dart' as globals;

class WallpaperTile extends StatelessWidget {
  const WallpaperTile({
    Key? key,
    required this.widget,
    required this.index,
  }) : super(key: key);

  final WallpaperGrid widget;
  final int index;

  void showGooglePopUp(BuildContext context, Function func) {
    debugPrint(globals.prismUser.loggedIn.toString());
    if (globals.prismUser.loggedIn == false) {
      googleSignInPopUp(context, func);
    } else {
      func();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: Data.subPrismWalls!.isEmpty
              ? BoxDecoration(
                  color: Provider.of<ThemeModeExtended>(context)
                              .getCurrentModeStyle(
                                  MediaQuery.of(context).platformBrightness) ==
                          "Dark"
                      ? Colors.white10
                      : Colors.black.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                )
              : BoxDecoration(
                  color: Provider.of<ThemeModeExtended>(context)
                              .getCurrentModeStyle(
                                  MediaQuery.of(context).platformBrightness) ==
                          "Dark"
                      ? Colors.white10
                      : Colors.black.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      Data.subPrismWalls![index]["wallpaper_thumb"].toString(),
                    ),
                    fit: BoxFit.cover,
                  )),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Theme.of(context).accentColor.withOpacity(0.3),
              highlightColor: Theme.of(context).accentColor.withOpacity(0.1),
              onTap: () {
                if (Data.subPrismWalls == []) {
                } else {
                  globals.isPremiumWall(
                                  globals.premiumCollections,
                                  Data.subPrismWalls![index]["collections"]
                                          as List? ??
                                      []) ==
                              true &&
                          globals.prismUser.premium == true
                      ? showGooglePopUp(context, () {
                          Navigator.pushNamed(
                            context,
                            premiumRoute,
                          );
                        })
                      : Navigator.pushNamed(
                          context,
                          wallpaperRoute,
                          arguments: [
                            widget.provider,
                            index,
                            Data.subPrismWalls![index]["wallpaper_thumb"],
                          ],
                        );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
