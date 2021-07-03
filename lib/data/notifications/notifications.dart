import 'package:wetune/data/notifications/model/inAppNotifModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:wetune/global/globals.dart' as globals;
import 'package:wetune/main.dart' as main;
import 'package:flutter/material.dart';

import 'model/inAppNotifModel.dart';

final FirebaseFirestore databaseReference = FirebaseFirestore.instance;

Future<QuerySnapshot> getLastMonthNotifs(String modifier) async {
  return databaseReference
      .collection("notifications")
      .orderBy("createdAt", descending: true)
      .where("createdAt",
          isGreaterThan: DateTime.now().subtract(const Duration(days: 30)))
      .where('modifier', isEqualTo: modifier)
      .get();
}

Future<QuerySnapshot> getLatestNotifs(String modifier) async {
  return databaseReference
      .collection("notifications")
      .orderBy("createdAt", descending: true)
      .where("createdAt", isGreaterThan: main.prefs.get('lastFetchTime'))
      .where('modifier', isEqualTo: modifier)
      .get();
}

Future<void> getNotifs() async {
  debugPrint("Fetching notifs");
  final Box<InAppNotif> box = Hive.box('inAppNotifs');
  if (main.prefs.get('lastFetchTime') != null) {
    debugPrint("Last fetch time ${main.prefs.get('lastFetchTime')}");
    if (globals.prismUser.premium == false) {
      getLatestNotifs('free').then((snap) {
        for (final doc in snap.docs) {
          box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
        }
      });
    }
    if (globals.prismUser.premium == true) {
      getLatestNotifs('premium').then((snap) {
        for (final doc in snap.docs) {
          box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
        }
      });
    }
    getLatestNotifs('all').then((snap) {
      for (final doc in snap.docs) {
        box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
      }
    });
    getLatestNotifs(globals.currentAppVersion).then((snap) {
      for (final doc in snap.docs) {
        box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
      }
    });
    getLatestNotifs(globals.prismUser.email).then((snap) {
      for (final doc in snap.docs) {
        box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
      }
    });
    main.prefs.put('lastFetchTime', DateTime.now());
  } else {
    debugPrint("Fetching for first time");
    box.clear();
    if (globals.prismUser.premium == false) {
      getLastMonthNotifs('free').then((snap) {
        for (final doc in snap.docs) {
          box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
        }
      });
    }
    if (globals.prismUser.premium == true) {
      getLastMonthNotifs('premium').then((snap) {
        for (final doc in snap.docs) {
          box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
        }
      });
    }
    getLastMonthNotifs('all').then((snap) {
      for (final doc in snap.docs) {
        box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
      }
    });
    getLastMonthNotifs(globals.currentAppVersion).then((snap) {
      for (final doc in snap.docs) {
        box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
      }
    });
    getLastMonthNotifs(globals.prismUser.email).then((snap) {
      for (final doc in snap.docs) {
        box.add(InAppNotif.fromSnapshot(doc.data() as dynamic));
      }
    });
    main.prefs.put('lastFetchTime', DateTime.now());
  }
}
