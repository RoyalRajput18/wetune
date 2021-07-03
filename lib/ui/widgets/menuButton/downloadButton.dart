import 'package:wetune/analytics/analytics_service.dart';
import 'package:wetune/theme/jam_icons_icons.dart';
import 'package:wetune/routes/routing_constants.dart';
import 'package:wetune/ui/widgets/popup/signInPopUp.dart';
import 'package:animations/animations.dart';
import 'package:device_info/device_info.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:wetune/theme/toasts.dart' as toasts;
import 'package:flutter/services.dart';
import 'package:wetune/main.dart' as main;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wetune/global/globals.dart' as globals;
import 'package:flutter/foundation.dart';

const int maxFailedLoadAttempts = 3;

class DownloadButton extends StatefulWidget {
  final String? link;
  final bool colorChanged;

  const DownloadButton({
    required this.link,
    required this.colorChanged,
    Key? key,
  }) : super(key: key);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  late bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  static const platform = MethodChannel('flutter.prism.set_wallpaper');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!isLoading) {
          if (globals.prismUser.loggedIn == true) {
            if (globals.prismUser.premium == true) {
              onDownload();
            } else {
              showDownloadPopup(context, () {
                debugPrint("Download");
                onDownload();
              });
            }
          } else {
            showDownloadPopup(context, () {
              debugPrint("Download");
              onDownload();
            });
          }
        } else {
          toasts.error("Wait for download to complete!");
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.25),
                    blurRadius: 4,
                    offset: const Offset(0, 4))
              ],
              borderRadius: BorderRadius.circular(500),
            ),
            padding: const EdgeInsets.all(17),
            child: Icon(
              JamIcons.download,
              color: Theme.of(context).accentColor,
              size: 20,
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              height: 53,
              width: 53,
              child:
                  isLoading ? const CircularProgressIndicator() : Container())
        ],
      ),
    );
  }

  void showPremiumPopUp(Function func) {
    if (globals.prismUser.premium == false) {
      toasts.codeSend("Variants are a premium feature.");
      Navigator.pushNamed(context, premiumRoute);
    } else {
      func();
    }
  }

  Future<void> onDownload() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    setState(() {
      isLoading = true;
    });
    debugPrint(widget.link);

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;
    debugPrint('(SDK $sdkInt)');
    toasts.codeSend("Starting Download");
    main.localNotification.createDownloadNotification();
    if (sdkInt >= 30) {
      if (widget.link!.contains("com.hash.prism")) {
        await platform.invokeMethod(
            'save_image_file', {"link": widget.link}).then((value) {
          if (value as bool) {
            analytics.logEvent(
                name: 'download_wallpaper', parameters: {'link': widget.link});
            toasts.codeSend("Wall Downloaded in Pictures/Prism!");
          } else {
            toasts.error("Couldn't download! Please Retry!");
          }
          setState(() {
            isLoading = false;
          });
          main.localNotification.cancelDownloadNotification();
        }).catchError((e) {
          debugPrint(e.toString());
          setState(() {
            isLoading = false;
          });
        });
      } else {
        await platform
            .invokeMethod('save_image', {"link": widget.link}).then((value) {
          if (value as bool) {
            analytics.logEvent(
                name: 'download_wallpaper', parameters: {'link': widget.link});
            toasts.codeSend("Wall Downloaded in Pictures/Prism!");
          } else {
            toasts.error("Couldn't download! Please Retry!");
          }
          setState(() {
            isLoading = false;
          });
          main.localNotification.cancelDownloadNotification();
        }).catchError((e) {
          debugPrint(e.toString());
          setState(() {
            isLoading = false;
          });
        });
      }
    } else {
      GallerySaver.saveImage(widget.link!, albumName: "Prism").then((value) {
        analytics.logEvent(
            name: 'download_wallpaper', parameters: {'link': widget.link});
        toasts.codeSend("Wall Downloaded in Internal Storage/Prism!");
        setState(() {
          isLoading = false;
        });
        main.localNotification.cancelDownloadNotification();
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
        // TODO Cancel all
        main.localNotification.cancelDownloadNotification();
      });
    }
  }
}

void showDownloadPopup(BuildContext context, Function rewardFunc) {
  showModal(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(),
      builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: DownloadDialogContent(
                rewardFunc: rewardFunc,
              ),
            );
          }));
}

class DownloadDialogContent extends StatefulWidget {
  final Function rewardFunc;

  const DownloadDialogContent({required this.rewardFunc});

  @override
  _DownloadDialogContentState createState() => _DownloadDialogContentState();
}

class _DownloadDialogContentState extends State<DownloadDialogContent> {
  num downloadCoins = 0;
  static const AdRequest request = AdRequest(
    nonPersonalizedAds: false,
    keywords: <String>['Apps', 'Games', 'Mobile', 'Game'],
  );
  int _numRewardedLoadAttempts = 0;

  void rewardFn(num rewardAmount) {
    downloadCoins += rewardAmount;
    debugPrint("Coins : ${downloadCoins.toString()}");
  }

  @override
  void initState() {
    _createRewardedAd();
    super.initState();
  }

  void _createRewardedAd() async {
    if (globals.adHelper.loadingAd == false &&
        globals.adHelper.adLoaded == false) {
      setState(() {
        globals.adHelper.loadingAd = true;
      });
      await RewardedAd.load(
        adUnitId: kReleaseMode
            ? "ca-app-pub-4649644680694757/3358009164"
            : RewardedAd.testAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('$ad loaded.');
            globals.adHelper.rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
            setState(() {
              globals.adHelper.loadingAd = false;
              globals.adHelper.adLoaded = true;
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
            setState(() {
              globals.adHelper.loadingAd = false;
            });
            globals.adHelper.rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            } else {
              if (mounted) {
                Navigator.pop(context);
                widget.rewardFunc();
              }
            }
          },
        ),
      );
    }
  }

  void _showRewardedAd() {
    setState(() {
      globals.adHelper.adLoaded = false;
    });
    if (globals.adHelper.rewardedAd == null) {
      debugPrint('Warning: attempt to show rewarded before loaded.');
      return;
    }
    globals.adHelper.rewardedAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    globals.adHelper.rewardedAd!.show(
        onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      debugPrint(
          '$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      rewardFn(reward.amount);
      if (downloadCoins >= 10) widget.rewardFunc();
    });
    globals.adHelper.rewardedAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Theme.of(context).hintColor),
            child: const FlareActor(
              "assets/animations/Update.flr",
              animation: "update",
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      "Watch a small video ad to download this wallpaper.",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                shape: const StadiumBorder(),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  if (globals.prismUser.loggedIn == false) {
                    googleSignInPopUp(context, () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, premiumRoute);
                    });
                  } else {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, premiumRoute);
                  }
                },
                child: Text(
                  'BUY PREMIUM',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              FlatButton(
                shape: const StadiumBorder(),
                color: Theme.of(context).accentColor.withOpacity(0.3),
                onPressed: () {
                  if (globals.adHelper.loadingAd == false &&
                      globals.adHelper.adLoaded == true) {
                    _showRewardedAd();
                    Navigator.of(context).pop();
                  } else {
                    toasts.error("Loading ads");
                  }
                },
                child: globals.adHelper.loadingAd == false &&
                        globals.adHelper.adLoaded == true
                    ? Text(
                        'WATCH AD',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).accentColor,
                        ),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            'WATCH AD',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.3),
                            ),
                          ),
                          const CircularProgressIndicator(),
                        ],
                      ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
