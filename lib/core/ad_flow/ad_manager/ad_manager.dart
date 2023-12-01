import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_manager/ad_manager_cubit.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_server/ad_server_cubit.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';

class AdManagerFunctions {
  /// Instance for this class
  static AdManagerFunctions? _instance;

  /// Privatised the constructor
  AdManagerFunctions._internal() {
    "AdManagerFunctions constructor called".print();
  }

  /// Provide a instance whenever it's needed
  static AdManagerFunctions get instance {
    // Provide a instance if not initialized yet
    _instance ??= AdManagerFunctions._internal();
    return _instance!;
  }

  /// Get an Instance of `AdManagerCubit`
  AdManagerCubit get adManagerCubit {
    return getItInstance.get<AdManagerCubit>();
  }

  /// Get an Instance of `AdServerCubit`
  AdServerCubit get adServerCubit {
    return getItInstance.get<AdServerCubit>();
  }

  /// Show `Interstitial` Ad Based on Active `AD NETWORK`
  Future<void> loadInterstitialAD() {
    if (adManagerCubit.state is AdManagerGoogle) {
      return _googleInterstitial();
    } else {
      // Print Details in Debug Console
      "Ad isn't Initialized Yet".print("loadInterstitialAD");
      return Future<void>.value();
    }
  }

  /// Loads an Interstitial ad.
  Future<void> _googleInterstitial() async {
    // Get Interstitial AdUnit
    final String adunit =
        (adManagerCubit.state as AdManagerGoogle).interstitial;
    // Check if AdUnit is not empty then load the ad
    if (adunit.isEmpty) {
      // Print Details in Debug Console
      return "AdUnit Not Available".print("_googleInterstitial");
    }
    // Print Details in Debug Console
    "Loading AD".print("_googleInterstitial");
    // Send request to Load Interstitial Ad
    return InterstitialAd.load(
      adUnitId: adunit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
            // Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              // Dispose the ad here to free resources.
              ad.dispose();
            },
          );
          '$ad loaded.'.print("_googleInterstitial");
          // Keep a reference to the ad so you can show it later.
          ad.show();
          return;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          return 'Failed to load: $error'.print("_googleInterstitial");
        },
      ),
    );
  }
}
