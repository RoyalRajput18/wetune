import 'package:wetune/data/favourites/provider/favouriteSetupProvider.dart';
import 'package:wetune/routes/router.dart';
import 'package:wetune/ui/widgets/favourite/favSetupLoader.dart';
import 'package:wetune/ui/widgets/home/core/bottomNavBar.dart';
import 'package:wetune/ui/widgets/home/core/headingChipBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class FavouriteSetupScreen extends StatelessWidget {
  const FavouriteSetupScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navStack.length > 1) navStack.removeLast();
        debugPrint(navStack.toString());
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: const PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: HeadingChipBar(
              current: "Favourites",
            ),
          ),
          body: BottomBar(
            child: FavSetupLoader(
              future:
                  Provider.of<FavouriteSetupProvider>(context, listen: false)
                      .getDataBase(),
            ),
          )),
    );
  }
}
