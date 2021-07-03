import 'package:wetune/analytics/analytics_service.dart';
import 'package:wetune/routes/routing_constants.dart';
import 'package:wetune/payments/upgrade.dart';
import 'package:wetune/ui/pages/favourite/favouriteSetupScreen.dart';
import 'package:wetune/ui/pages/favourite/favouriteSetupViewScreen.dart';
import 'package:wetune/ui/pages/favourite/favouriteWallScreen.dart';
import 'package:wetune/ui/pages/home/collections/collectionViewScreen.dart';
import 'package:wetune/ui/pages/download/downloadScreen.dart';
import 'package:wetune/ui/pages/download/downloadWallpaperViewScreen.dart';
import 'package:wetune/ui/pages/favourite/favouriteWallViewScreen.dart';
import 'package:wetune/ui/pages/home/core/pageManager.dart';
import 'package:wetune/ui/pages/home/core/splashScreen.dart';
import 'package:wetune/ui/pages/home/wallpapers/wallpaperFilterScreen.dart';
import 'package:wetune/ui/pages/home/wallpapers/wallpaperScreen.dart';
import 'package:wetune/ui/pages/onboarding/onboardingScreen.dart';
import 'package:wetune/ui/pages/profile/aboutScreen.dart';
import 'package:wetune/ui/pages/profile/editSetupDetails.dart';
import 'package:wetune/ui/pages/profile/followerProfile.dart';
// import 'package:wetune/ui/pages/profile/photographerProfile.dart';
import 'package:wetune/ui/pages/categories/colorScreen.dart';
import 'package:wetune/ui/pages/profile/profileScreen.dart';
import 'package:wetune/ui/pages/profile/profileSetupViewScreen.dart';
import 'package:wetune/ui/pages/profile/profileWallViewScreen.dart';
import 'package:wetune/ui/pages/profile/settings.dart';
import 'package:wetune/ui/pages/profile/sharePrismScreen.dart';
import 'package:wetune/ui/pages/profile/themeView.dart';
import 'package:wetune/ui/pages/profile/followersScreen.dart';
import 'package:wetune/ui/pages/profile/userProfileSetupViewScreen.dart';
import 'package:wetune/ui/pages/profile/userProfileWallViewScreen.dart';
import 'package:wetune/ui/pages/search/searchScreen.dart';
import 'package:wetune/ui/pages/search/searchWallpaperScreen.dart';
import 'package:wetune/ui/pages/setup/setupScreen.dart';
import 'package:wetune/ui/pages/setup/setupViewScreen.dart';
import 'package:wetune/ui/pages/setup/shareSetupViewScreen.dart';
import 'package:wetune/ui/pages/share/shareWallViewScreen.dart';
import 'package:wetune/ui/pages/undefinedScreen.dart';
import 'package:wetune/ui/pages/home/core/notificationScreen.dart';
import 'package:wetune/ui/pages/upload/editWallScreen.dart';
import 'package:wetune/ui/pages/upload/setupGuidelines.dart';
import 'package:wetune/ui/pages/upload/uploadSetupScreen.dart';
import 'package:wetune/ui/pages/upload/uploadWallScreen.dart';
import 'package:wetune/ui/pages/profile/reviewScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imagelib;

List<String> navStack = ["Home"];

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case splashRoute:
      navStack.add("Splash");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: splashRoute);
      return CupertinoPageRoute(builder: (context) => SplashWidget());
    case searchRoute:
      navStack.add("Search");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: searchRoute);
      return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => SearchScreen());
    case homeRoute:
      navStack.add("Home");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: homeRoute);
      return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => PageManager());
    case profileRoute:
      navStack.add("Profile");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: profileRoute);
      return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => ProfileScreen());
    case followerProfileRoute:
      navStack.add("Follower Profile");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: followerProfileRoute);
      return CupertinoPageRoute(
          builder: (context) => FollowerProfile(settings.arguments as List?));
    case downloadRoute:
      navStack.add("Downloads");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: downloadRoute);
      return CupertinoPageRoute(builder: (context) => DownloadScreen());
    case reviewRoute:
      navStack.add("Review Screen");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: reviewRoute);
      return CupertinoPageRoute(builder: (context) => ReviewScreen());
    case favWallRoute:
      navStack.add("Fav Walls");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: favWallRoute);
      return CupertinoPageRoute(
          builder: (context) => const FavouriteWallpaperScreen());
    case favSetupRoute:
      navStack.add("Fav Setups");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: favSetupRoute);
      return CupertinoPageRoute(
          builder: (context) => const FavouriteSetupScreen());
    case premiumRoute:
      navStack.add("Buy Premium");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: premiumRoute);
      return CupertinoPageRoute(builder: (context) => UpgradeScreen());
    case notificationsRoute:
      navStack.add("Notifications");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: notificationsRoute);
      analytics.logEvent(
        name: 'notifications_checked',
      );
      return CupertinoPageRoute(builder: (context) => NotificationScreen());
    case colorRoute:
      navStack.add("Color");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: colorRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              ColorScreen(arguments: settings.arguments as List?));
    case collectionViewRoute:
      navStack.add("CollectionsView");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: collectionViewRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              CollectionViewScreen(arguments: settings.arguments as List?));
    case wallpaperRoute:
      navStack.add("Wallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: wallpaperRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              WallpaperScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case searchWallpaperRoute:
      navStack.add("Search Wallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: searchWallpaperRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              SearchWallpaperScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case downloadWallpaperRoute:
      navStack.add("DownloadedWallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: downloadWallpaperRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              DownloadWallpaperScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case shareRoute:
      navStack.add("SharedWallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: shareRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              ShareWallpaperViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case shareSetupViewRoute:
      navStack.add("SharedSetup");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: shareSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              ShareSetupViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case favWallViewRoute:
      navStack.add("FavouriteWallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: favWallViewRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              FavWallpaperViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case favSetupViewRoute:
      navStack.add("Favourite Setup View");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: favSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              FavSetupViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case setupRoute:
      navStack.add("Setups");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: setupRoute);
      return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const SetupScreen());
    case setupViewRoute:
      navStack.add("SetupView");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: setupViewRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              SetupViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case profileSetupViewRoute:
      navStack.add("ProfileSetupView");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: profileSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) => ProfileSetupViewScreen(
                arguments: settings.arguments as List?,
              ),
          fullscreenDialog: true);
    case profileWallViewRoute:
      navStack.add("ProfileWallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: profileWallViewRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              ProfileWallViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case userProfileWallViewRoute:
      navStack.add("User ProfileWallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: userProfileWallViewRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              UserProfileWallViewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case userProfileSetupViewRoute:
      navStack.add("User ProfileSetup");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: userProfileSetupViewRoute);
      return CupertinoPageRoute(
          builder: (context) => UserProfileSetupViewScreen(
              arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case themeViewRoute:
      navStack.add("Themes");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: themeViewRoute);
      return CupertinoPageRoute(builder: (context) => ThemeView());
    case editWallRoute:
      navStack.add("Edit Wallpaper");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: editWallRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              EditWallScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case uploadSetupRoute:
      navStack.add("Upload Setup");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: uploadSetupRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              UploadSetupScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case editSetupDetailsRoute:
      navStack.add("Edit Setup Details");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: editSetupDetailsRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              EditSetupReviewScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case setupGuidelinesRoute:
      navStack.add("Setup Guidelines");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: setupGuidelinesRoute);
      return CupertinoPageRoute(
          builder: (context) => const SetupGuidelinesScreen(),
          fullscreenDialog: true);
    case uploadWallRoute:
      navStack.add("Add");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: uploadWallRoute);
      return CupertinoPageRoute(
          builder: (context) =>
              UploadWallScreen(arguments: settings.arguments as List?),
          fullscreenDialog: true);
    case aboutRoute:
      navStack.add("About Prism");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: aboutRoute);
      return CupertinoPageRoute(
          builder: (context) => AboutScreen(), fullscreenDialog: true);
    case settingsRoute:
      navStack.add("Settings");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: settingsRoute);
      return CupertinoPageRoute(
          builder: (context) => const SettingsScreen(), fullscreenDialog: true);
    case sharePrismRoute:
      navStack.add("Share Prism");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: sharePrismRoute);
      return CupertinoPageRoute(
          builder: (context) => SharePrismScreen(), fullscreenDialog: true);
    case wallpaperFilterRoute:
      navStack.add("Wallpaper Filter");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: wallpaperFilterRoute);
      return CupertinoPageRoute(
          builder: (context) => WallpaperFilterScreen(
                image: (settings.arguments as List?)![0] as imagelib.Image,
                finalImage: (settings.arguments as List?)![1] as imagelib.Image,
                filename: (settings.arguments as List?)![2] as String,
                finalFilename: (settings.arguments as List?)![3] as String,
              ),
          fullscreenDialog: true);
    case onboardingRoute:
      navStack.add("Onboarding");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: wallpaperFilterRoute);
      return CupertinoPageRoute(
        builder: (context) => OnboardingScreen(),
      );
    case followersRoute:
      navStack.add("Followers");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: followersRoute);
      return CupertinoPageRoute(
          builder: (context) => FollowersScreen(
                arguments: settings.arguments as List?,
              ));
    default:
      navStack.add("undefined");
      debugPrint(navStack.toString());
      analytics.setCurrentScreen(screenName: "/undefined");
      return CupertinoPageRoute(
        builder: (context) => UndefinedScreen(
          name: settings.name,
        ),
      );
  }
}
