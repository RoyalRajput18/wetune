import 'dart:async';
import 'package:wetune/data/favourites/provider/favouriteProvider.dart';
import 'package:wetune/data/favourites/provider/favouriteSetupProvider.dart';
import 'package:wetune/data/profile/wallpaper/profileSetupProvider.dart';
import 'package:wetune/data/profile/wallpaper/profileWallProvider.dart';
import 'package:wetune/routes/router.dart';
import 'package:wetune/theme/jam_icons_icons.dart';
import 'package:wetune/routes/routing_constants.dart';
import 'package:wetune/ui/widgets/profile/aboutList.dart';
import 'package:wetune/ui/widgets/profile/drawerWidget.dart';
import 'package:wetune/ui/widgets/profile/generalList.dart';
import 'package:wetune/ui/widgets/profile/downloadList.dart';
import 'package:wetune/ui/widgets/profile/premiumList.dart';
import 'package:wetune/ui/widgets/home/core/bottomNavBar.dart';
import 'package:wetune/ui/widgets/home/core/inheritedScrollControllerProvider.dart';
import 'package:wetune/ui/widgets/profile/uploadedWallsLoader.dart';
import 'package:wetune/ui/widgets/profile/uploadedSetupsLoader.dart';
import 'package:wetune/ui/widgets/profile/userList.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wetune/main.dart' as main;
import 'package:provider/provider.dart';
import 'package:wetune/global/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetune/global/svgAssets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        body: BottomBar(
          child: ProfileChild(),
        ),
        endDrawer: globals.prismUser.loggedIn
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.68,
                child: ProfileDrawer())
            : null);
  }
}

class ProfileChild extends StatefulWidget {
  @override
  _ProfileChildState createState() => _ProfileChildState();
}

class _ProfileChildState extends State<ProfileChild> {
  int favCount = main.prefs.get('userFavs') as int? ?? 0;
  int profileCount = ((main.prefs.get('userPosts') as int?) ?? 0) +
      ((main.prefs.get('userSetups') as int?) ?? 0);
  final ScrollController scrollController = ScrollController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int count = 0;
  @override
  void initState() {
    count = main.prefs.get('easterCount', defaultValue: 0) as int;
    checkFav();
    super.initState();
  }

  Future<bool> onWillPop() async {
    if (navStack.length > 1) navStack.removeLast();
    debugPrint(navStack.toString());
    return true;
  }

  Future checkFav() async {
    if (globals.prismUser.loggedIn) {
      await Provider.of<FavouriteProvider>(context, listen: false)
          .countFav()
          .then(
        (value) async {
          await Provider.of<FavouriteSetupProvider>(context, listen: false)
              .countFavSetups()
              .then((value2) {
            debugPrint(value.toString());
            debugPrint(value2.toString());
            if (mounted) {
              setState(
                () {
                  favCount = value + value2;
                  main.prefs.put('userFavs', favCount);
                },
              );
            }
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController? controller =
        InheritedDataProvider.of(context)!.scrollController;
    final CollectionReference users = firestore.collection('users');

    return WillPopScope(
        onWillPop: onWillPop,
        child: globals.prismUser.loggedIn
            ? DefaultTabController(
                length: 2,
                child: Stack(
                  children: [
                    Scaffold(
                      backgroundColor: Theme.of(context).primaryColor,
                      body: NestedScrollView(
                        controller: controller,
                        headerSliverBuilder: (context, innerBoxIsScrolled) =>
                            <Widget>[
                          SliverAppBar(
                            actions: globals.prismUser.loggedIn == false
                                ? []
                                : [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                          icon: Icon(JamIcons.menu,
                                              color: Theme.of(context)
                                                  .accentColor),
                                          onPressed: () {
                                            scaffoldKey.currentState!
                                                .openEndDrawer();
                                          }),
                                    )
                                  ],
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
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 25, 16, 0),
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
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .errorColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5000),
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
                                                            Colors.transparent,
                                                        foregroundColor:
                                                            Colors.transparent,
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
                                                              fit: BoxFit.cover,
                                                              imageUrl: globals
                                                                  .prismUser
                                                                  .profilePhoto
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
                                                        .contains(globals
                                                            .prismUser.email))
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
                                                        .bottom,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 20),
                                                  child: globals.prismUser
                                                              .premium ==
                                                          false
                                                      ? Text(
                                                          globals.prismUser
                                                              .username
                                                              .toUpperCase(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Proxima Nova",
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontSize: 18,
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
                                                              globals.prismUser
                                                                  .username
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Proxima Nova",
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor,
                                                                  fontSize: 18,
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
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              TableCell(
                                                  verticalAlignment:
                                                      TableCellVerticalAlignment
                                                          .middle,
                                                  child: Container()
                                                  //ToDo Add link button in profile
                                                  // IconButton(
                                                  //     icon: Icon(
                                                  //       JamIcons.link,
                                                  //       color: Theme.of(context)
                                                  //           .accentColor,
                                                  //     ),
                                                  //     onPressed: () {
                                                  //       showLinksPopUp(context,
                                                  //           globals.prismUser.id);
                                                  //     }),
                                                  ),
                                              TableCell(
                                                verticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            favWallRoute);
                                                      },
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "${favCount.toString()} ",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Proxima Nova",
                                                                fontSize: 22,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                          Icon(
                                                            JamIcons.heart_f,
                                                            size: 20,
                                                            color: Theme.of(
                                                                    context)
                                                                .accentColor,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Row(
                                                    //   children: <Widget>[
                                                    //     FutureBuilder(
                                                    //         future: Provider.of<
                                                    //                     ProfileWallProvider>(
                                                    //                 context,
                                                    //                 listen:
                                                    //                     false)
                                                    //             .getProfileWallsLength(),
                                                    //         builder: (context,
                                                    //             snapshot) {
                                                    //           return Text(
                                                    //             snapshot.data ==
                                                    //                     null
                                                    //                 ? "${profileCount.toString()} "
                                                    //                 : "${snapshot.data.toString()} ",
                                                    //             style: TextStyle(
                                                    //                 fontFamily:
                                                    //                     "Proxima Nova",
                                                    //                 fontSize:
                                                    //                     22,
                                                    //                 color: Theme.of(
                                                    //                         context)
                                                    //                     .accentColor,
                                                    //                 fontWeight:
                                                    //                     FontWeight
                                                    //                         .normal),
                                                    //           );
                                                    //         }),
                                                    //     Icon(
                                                    //       JamIcons.upload,
                                                    //       size: 20,
                                                    //       color:
                                                    //           Theme.of(context)
                                                    //               .accentColor,
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream: users
                                                            .where("email",
                                                                isEqualTo: globals
                                                                    .prismUser
                                                                    .email)
                                                            .snapshots(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    QuerySnapshot>
                                                                snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Row(
                                                              children: [
                                                                Text(
                                                                  "0",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Proxima Nova",
                                                                      fontSize:
                                                                          22,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .accentColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                Icon(
                                                                  JamIcons
                                                                      .users,
                                                                  size: 20,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .accentColor,
                                                                ),
                                                              ],
                                                            );
                                                          } else {
                                                            List followers = [];
                                                            if (snapshot.data!
                                                                        .docs !=
                                                                    null &&
                                                                snapshot
                                                                    .data!
                                                                    .docs
                                                                    .isNotEmpty) {
                                                              followers = (snapshot
                                                                          .data!
                                                                          .docs[0]
                                                                          .data() as dynamic)['followers']
                                                                      as List? ??
                                                                  [];
                                                            }
                                                            return GestureDetector(
                                                              onTap: () {
                                                                // Navigator.pushNamed(
                                                                //     context,
                                                                //     followersRoute,
                                                                //     arguments: [
                                                                //       followers
                                                                //     ]);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    followers.length >
                                                                            1000
                                                                        ? NumberFormat
                                                                                .compactCurrency(
                                                                            decimalDigits:
                                                                                2,
                                                                            symbol:
                                                                                '',
                                                                          )
                                                                            .format(followers
                                                                                .length)
                                                                            .toString()
                                                                        : followers
                                                                            .length
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Proxima Nova",
                                                                        fontSize:
                                                                            22,
                                                                        color: Theme.of(context)
                                                                            .accentColor,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                  Icon(
                                                                    JamIcons
                                                                        .users,
                                                                    size: 20,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor,
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                        }),
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
                          ),
                          SliverAppBar(
                            backgroundColor: Theme.of(context).errorColor,
                            automaticallyImplyLeading: false,
                            pinned: true,
                            titleSpacing: 0,
                            expandedHeight: globals.prismUser.loggedIn ? 50 : 0,
                            title: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 57,
                              child: Container(
                                color: Theme.of(context).errorColor,
                                child: SizedBox.expand(
                                  child: TabBar(
                                      indicatorColor:
                                          Theme.of(context).accentColor,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      unselectedLabelColor:
                                          const Color(0xFFFFFFFF)
                                              .withOpacity(0.5),
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
                        body: TabBarView(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ProfileLoader(
                              future: Provider.of<ProfileWallProvider>(context,
                                      listen: false)
                                  .getProfileWalls(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: UploadedSetupsLoader(
                              future: Provider.of<ProfileSetupProvider>(context,
                                      listen: false)
                                  .getProfileSetups(),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ))
            : Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body:
                    CustomScrollView(controller: controller, slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).errorColor,
                    automaticallyImplyLeading: false,
                    expandedHeight: 280.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Stack(
                            children: <Widget>[
                              Container(
                                color: Theme.of(context).errorColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: const FlareActor(
                                      "assets/animations/Text.flr",
                                      animation: "Untitled",
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: PremiumList(),
                    ),
                    DownloadList(),
                    const GeneralList(
                      expanded: false,
                    ),
                    UserList(
                      expanded: false,
                    ),
                    AboutList(),
                    const SizedBox(
                      height: 300,
                    ),
                  ]))
                ]),
              ));
  }
}
