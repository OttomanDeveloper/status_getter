import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_manager/ad_manager_cubit.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<StatefulWidget> createState() => BannerAdState();
}

class BannerAdState extends State<BannerAdWidget>
    with AutomaticKeepAliveClientMixin {
  /// Hold `Banner` Ad
  BannerAd? _bannerAd;
  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();

  /// Create an Instance of `AdManagerCubit`
  final AdManagerCubit ad = getItInstance.get<AdManagerCubit>();

  /// Admob Banner Ads Size
  AnchoredAdaptiveBannerAdSize? size;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load Banner Ad
      return _loadBannerAd();
    });
  }

  /// Send request to load banner ad
  void _loadBannerAd() async {
    // Check if Ad Network is Not Google then Reject the Request
    if (ad.state is AdManagerInitial) {
      // Print Details in Debug Console
      return "Not Allowed to Load Banner".print("BannerAdWidget");
    }
    // Get Banner AdUnit
    final String adunit = (ad.state as AdManagerGoogle).banner;
    // Print Details in Debug Console
    "Google Ads are enabled".print("BannerAdWidget");
    // Check if Google Banner Ad Unit is available or not
    if (adunit.isNotEmpty) {
      /// Get an `AnchoredAdaptiveBannerAdSize` before loading the ad.
      size ??= await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        context.width.truncate(),
      );
      if (size == null) {
        // Print Details in Debug Console
        return 'Unable to get height of anchored banner.'.print();
      }
      // Load Banner Ad
      Future<void>.delayed(const Duration(milliseconds: 650), () {
        // Set Banner Ad
        _bannerAd = BannerAd(
          size: size!,
          adUnitId: adunit,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (Ad ad) {
              // Print Details in Debug Console
              '$BannerAd loaded.'.print();
              // Push AD to completer
              return bannerCompleter.complete(ad as BannerAd);
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              // Dispose the Ad
              ad.dispose();
              // Print Details in Debug Console
              '$BannerAd failedToLoad: $error'.print();
              // Push Error to completer
              return bannerCompleter.completeError(error);
            },
            onAdOpened: (Ad ad) => '$BannerAd onAdOpened.'.print(),
            onAdClosed: (Ad ad) => '$BannerAd onAdClosed.'.print(),
            onAdImpression: (Ad ad) => 'Ad impression.'.print(),
          ),
        )..load().then<void>((_) {
            // Print Details in Debug Console
            _bannerAd?.size.toString().print("Banner Ad Loaded:");
          });
      });
    } else {
      // Print Details in Debug Console
      return "Google Banner AdUnit not available".print("BannerAdWidget");
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AdManagerCubit, AdManagerState>(
      bloc: ad,
      builder: (BuildContext _, AdManagerState state) {
        if (state is AdManagerGoogle) {
          if (state.banner.isNotEmpty) {
            return _AdmobBannerAd(
              size: size,
              bannerCompleter: bannerCompleter,
            );
          }
        }
        // don't show anything. Just Occupy the Ad Space
        return const SizedBox.shrink();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Hold `AdmobBannerAd` Widget
class _AdmobBannerAd extends StatelessWidget {
  final AnchoredAdaptiveBannerAdSize? size;
  final Completer<BannerAd> bannerCompleter;
  const _AdmobBannerAd({
    required this.size,
    required this.bannerCompleter,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (_, AsyncSnapshot<BannerAd> snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData && snap.data != null) {
            return SizedBox(
              width: snap.data?.size.width.toDouble(),
              height: snap.data?.size.height.toDouble(),
              child: AdWidget(ad: snap.data!),
            );
          }
        }
        // Ad is not ready yet so don't show anything
        return SizedBox(
          width: snap.data?.size.width.toDouble(),
          height: snap.data?.size.height.toDouble(),
        );
      },
    );
  }
}
