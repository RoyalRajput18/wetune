import 'package:wetune/data/collections/provider/collectionsWithoutProvider.dart';
import 'package:wetune/routes/router.dart';
import 'package:wetune/ui/widgets/home/core/bottomNavBar.dart';
import 'package:wetune/ui/widgets/home/collections/collectionsViewGrid.dart';
import 'package:wetune/ui/widgets/home/core/headingChipBar.dart';
import 'package:wetune/ui/widgets/home/wallpapers/loading.dart';
import 'package:flutter/material.dart';

class CollectionViewScreen extends StatelessWidget {
  final List? arguments;
  const CollectionViewScreen({
    Key? key,
    @required this.arguments,
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
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: HeadingChipBar(
            current: (arguments![0] as String).capitalize(),
          ),
        ),
        body: FutureBuilder(
          future: getCollectionWithName(arguments![0].toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return const BottomBar(
                child: CollectionViewGrid(),
              );
            }
            return const LoadingCards();
          },
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
