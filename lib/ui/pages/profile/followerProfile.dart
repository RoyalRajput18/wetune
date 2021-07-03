import 'dart:async';
import 'dart:convert';
import 'package:wetune/gitkey.dart';
import 'package:wetune/routes/router.dart';
import 'package:wetune/theme/jam_icons_icons.dart';
import 'package:wetune/ui/widgets/animated/loader.dart';
import 'package:wetune/ui/widgets/popup/noLoadLinkPopUp.dart';
import 'package:wetune/ui/widgets/profile/userProfileLoader.dart';
import 'package:wetune/ui/widgets/profile/userProfileSetupLoader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wetune/data/profile/wallpaper/getUserProfile.dart';
import 'package:wetune/main.dart' as main;
import 'package:wetune/theme/toasts.dart' as toasts;
import 'package:wetune/global/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetune/global/svgAssets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class FollowerProfile extends StatefulWidget {
  final List? arguments;
  const FollowerProfile(this.arguments);
  @override
  _FollowerProfileState createState() => _FollowerProfileState();
}

class _FollowerProfileState extends State<FollowerProfile> {
  String? name;
  String? email;
  String? userPhoto;
  bool? premium;
  Map? links;
  final ScrollController scrollController = ScrollController();
  final key = GlobalKey();
  @override
  void initState() {
    email = widget.arguments![0].toString();
    super.initState();
  }

  Future<bool> onWillPop() async {
    if (navStack.length > 1) {
      navStack.removeLast();
      if ((navStack.last == "Wallpaper") ||
          (navStack.last == "Search Wallpaper") ||
          (navStack.last == "SharedWallpaper") ||
          (navStack.last == "SetupView")) {}
    }
    debugPrint(navStack.toString());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (main.prefs.get('followTooltipShow', defaultValue: false) as bool) {
    } else {
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        try {
          final dynamic tooltip = key.currentState;
          tooltip.ensureTooltipVisible();
          main.prefs.put('followTooltipShow', true);
          Future.delayed(const Duration(seconds: 5)).then((_) {
            tooltip.deactivate();
          });
        } catch (e) {
          debugPrint(e.toString());
        }
      });
    }
    return WillPopScope(
        onWillPop: onWillPop,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: StreamBuilder<QuerySnapshot>(
              stream: getUserProfile(email!),
              builder: (context, snap) {
                if (snap.hasData && snap.data != null) {
                  name =
                      (snap.data!.docs[0].data() as dynamic)["name"].toString();
                  userPhoto =
                      (snap.data!.docs[0].data() as dynamic)["profilePhoto"]
                          .toString();
                  premium =
                      (snap.data!.docs[0].data() as dynamic)["premium"] as bool;
                  links =
                      (snap.data!.docs[0].data() as dynamic)["links"] as Map;
                  debugPrint("Name : $name");
                  debugPrint("Email : $email");
                  debugPrint("Profile Photo : $userPhoto");
                  debugPrint("Premium : $premium");
                  debugPrint("Links : $links");
                  return NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) =>
                        <Widget>[
                      SliverAppBar(
                        backgroundColor: Theme.of(context).errorColor,
                        automaticallyImplyLeading: false,
                        expandedHeight: 200.0,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: Theme.of(context).errorColor,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 25, 16, 0),
                                child: Column(
                                  children: [
                                    const Spacer(flex: 5),
                                    Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(3),
                                        1: FlexColumnWidth(5)
                                      },
                                      children: [
                                        TableRow(children: [
                                          TableCell(
                                            child: userPhoto == null
                                                ? Container()
                                                : Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5000),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 16,
                                                                offset:
                                                                    const Offset(
                                                                        0, 4),
                                                                color: const Color(
                                                                        0xFF000000)
                                                                    .withOpacity(
                                                                        0.24))
                                                          ],
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          foregroundColor:
                                                              Colors
                                                                  .transparent,
                                                          radius: 50,
                                                          child: ClipOval(
                                                            child: Container(
                                                              height: 120,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                imageUrl: userPhoto
                                                                    .toString(),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Container(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if (globals.verifiedUsers
                                                          .contains(
                                                              email.toString()))
                                                        Positioned(
                                                          top: 5,
                                                          left: 100,
                                                          child: SizedBox(
                                                            width: 30,
                                                            height: 30,
                                                            child: SvgPicture
                                                                .string(verifiedIcon
                                                                    .replaceAll(
                                                                        "E57697",
                                                                        "FFFFFF")),
                                                          ),
                                                        )
                                                      else
                                                        Container(),
                                                    ],
                                                  ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Column(
                                              children: [
                                                if (name == null)
                                                  Container()
                                                else
                                                  premium == false
                                                      ? Text(
                                                          name
                                                              .toString()
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Proxima Nova",
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                              name
                                                                  .toString()
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Proxima Nova",
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          6.0),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor,
                                                                ),
                                                                child: Text(
                                                                  "PRO",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText2!
                                                                      .copyWith(
                                                                        fontSize:
                                                                            9,
                                                                        color: Theme.of(context)
                                                                            .errorColor,
                                                                      ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                // const Text("Write bio here...")
                                              ],
                                            ),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: links != null &&
                                                    links!.isNotEmpty
                                                ? IconButton(
                                                    icon: Icon(
                                                      JamIcons.link,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    onPressed: () {
                                                      showNoLoadLinksPopUp(
                                                          context, links!);
                                                    })
                                                : Container(),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                const Spacer(flex: 2),
                                                // Row(
                                                //   children: <Widget>[
                                                //     FutureBuilder(
                                                //         future: userData
                                                //             .getProfileWallsLength(
                                                //                 email),
                                                //         builder: (context,
                                                //             snapshot) {
                                                //           return Text(
                                                //             snapshot.data ==
                                                //                     null
                                                //                 ? "0 "
                                                //                 : "${snapshot.data.toString()} ",
                                                //             style: TextStyle(
                                                //                 fontFamily:
                                                //                     "Proxima Nova",
                                                //                 fontSize: 22,
                                                //                 color: Theme.of(
                                                //                         context)
                                                //                     .accentColor,
                                                //                 fontWeight:
                                                //                     FontWeight
                                                //                         .normal),
                                                //           );
                                                //         }),
                                                //     Icon(
                                                //       JamIcons.picture,
                                                //       size: 20,
                                                //       color: Theme.of(context)
                                                //           .accentColor,
                                                //     ),
                                                //   ],
                                                // ),
                                                // const Spacer(),
                                                // Row(
                                                //   children: <Widget>[
                                                //     FutureBuilder(
                                                //         future: userData
                                                //             .getProfileSetupsLength(
                                                //                 email),
                                                //         builder: (context,
                                                //             snapshot) {
                                                //           return Text(
                                                //             snapshot.data ==
                                                //                     null
                                                //                 ? "0 "
                                                //                 : "${snapshot.data.toString()} ",
                                                //             style: TextStyle(
                                                //                 fontFamily:
                                                //                     "Proxima Nova",
                                                //                 fontSize: 22,
                                                //                 color: Theme.of(
                                                //                         context)
                                                //                     .accentColor,
                                                //                 fontWeight:
                                                //                     FontWeight
                                                //                         .normal),
                                                //           );
                                                //         }),
                                                //     Icon(
                                                //       JamIcons.instant_picture,
                                                //       size: 20,
                                                //       color: Theme.of(context)
                                                //           .accentColor,
                                                //     ),
                                                //   ],
                                                // ),
                                                Row(
                                                  children: [
                                                    const SizedBox(width: 15),
                                                    Text(
                                                      ((snap.data!.docs[0].data()
                                                                              as dynamic)['followers']
                                                                          as List? ??
                                                                      [])
                                                                  .length >
                                                              1000
                                                          ? NumberFormat
                                                                  .compactCurrency(
                                                              decimalDigits: 2,
                                                              symbol: '',
                                                            )
                                                              .format(((snap.data!.docs[0].data()
                                                                              as dynamic)['followers']
                                                                          as List? ??
                                                                      [])
                                                                  .length)
                                                              .toString()
                                                          : ((snap.data!.docs[0]
                                                                              .data()
                                                                          as dynamic)['followers']
                                                                      as List? ??
                                                                  [])
                                                              .length
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "Proxima Nova",
                                                          fontSize: 22,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                    Icon(
                                                      JamIcons.users,
                                                      size: 20,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(flex: 2),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        leading: IconButton(
                          icon: const Icon(
                            JamIcons.chevron_left,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (navStack.length > 1) {
                              navStack.removeLast();
                              if ((navStack.last == "Wallpaper") ||
                                  (navStack.last == "Search Wallpaper") ||
                                  (navStack.last == "SharedWallpaper") ||
                                  (navStack.last == "SetupView")) {}
                            }
                            debugPrint(navStack.toString());
                          },
                        ),
                        actions: [
                          if (globals.prismUser.loggedIn == true &&
                              globals.prismUser.email != email)
                            if (((snap.data!.docs[0].data()
                                        as dynamic)['followers'] as List? ??
                                    [])
                                .contains(globals.prismUser.email))
                              IconButton(
                                icon: const Icon(JamIcons.user_remove),
                                onPressed: () {
                                  unfollow(email!, snap.data!.docs[0].id);
                                  toasts.error("Unfollowed $name!");
                                },
                              )
                            else
                              Tooltip(
                                margin: EdgeInsets.fromLTRB(
                                    MediaQuery.of(context).size.width * 0.4,
                                    0,
                                    16,
                                    0),
                                showDuration: const Duration(seconds: 4),
                                key: key,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                message:
                                    "Follow $name to get notified for new posts!",
                                child: IconButton(
                                  icon: const Icon(JamIcons.user_plus),
                                  onPressed: () {
                                    follow(email!, snap.data!.docs[0].id);
                                    http.post(
                                      Uri.parse(
                                        'https://fcm.googleapis.com/fcm/send',
                                      ),
                                      headers: <String, String>{
                                        'Content-Type': 'application/json',
                                        'Authorization': 'key=$fcmServerToken',
                                      },
                                      body: jsonEncode(
                                        <String, dynamic>{
                                          'notification': <String, dynamic>{
                                            'title': '🎉 New Follower!',
                                            'body':
                                                '${globals.prismUser.username} is now following you.',
                                            'color': "#e57697",
                                            'tag':
                                                '${globals.prismUser.username} Follow',
                                            'image':
                                                globals.prismUser.profilePhoto,
                                            'android_channel_id': "followers",
                                            'icon': '@drawable/ic_follow'
                                          },
                                          'priority': 'high',
                                          'data': <String, dynamic>{
                                            'click_action':
                                                'FLUTTER_NOTIFICATION_CLICK',
                                            'id': '1',
                                            'status': 'done'
                                          },
                                          'to':
                                              "/topics/${email!.split("@")[0]}"
                                        },
                                      ),
                                    );
                                    toasts.codeSend("Followed $name!");
                                  },
                                ),
                              )
                          else
                            Container(),
                        ],
                      ),
                      SliverAppBar(
                        backgroundColor: Theme.of(context).errorColor,
                        automaticallyImplyLeading: false,
                        pinned: true,
                        titleSpacing: 0,
                        expandedHeight: 50,
                        title: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 57,
                          child: Container(
                            color: Theme.of(context).errorColor,
                            child: SizedBox.expand(
                              child: TabBar(
                                  indicatorColor: Theme.of(context).accentColor,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  unselectedLabelColor:
                                      const Color(0xFFFFFFFF).withOpacity(0.5),
                                  labelColor: const Color(0xFFFFFFFF),
                                  tabs: [
                                    Text(
                                      "Wallpapers",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .accentColor),
                                    ),
                                    Text(
                                      "Setups",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .accentColor),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                    body: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: UserProfileLoader(
                            email: email,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: UserProfileSetupLoader(
                            email: email,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Loader(),
                  );
                }
              },
            ),
          ),
        ));
  }
}
