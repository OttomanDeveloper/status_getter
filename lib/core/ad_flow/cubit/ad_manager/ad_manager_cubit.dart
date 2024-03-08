import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_server/ad_server_cubit.dart';
import 'package:statusgetter/core/ad_flow/model/ads/ads_model_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';

part 'ad_manager_state.dart';

class AdManagerCubit extends Cubit<AdManagerState> {
  AdManagerCubit() : super(AdManagerInitial());

  /// Create a Getter of `AdsModel?`
  AdsModel? get ad {
    return getItInstance.get<AdServerCubit>().state;
  }

  /// Emit new state if the bloc is not closed.
  void emitState(AdManagerState state) {
    if (!isClosed) {
      return emit(state);
    }
  }

  /// Initialize `Ads` SDK
  Future<void> initializeSDK() async {
    // Check if SDK is Already Initialize then Reject the request
    if (state is AdManagerGoogle) {
      // Print Details in Debug Console
      return "AD SDK Already Initialized".print("AdManagerCubit");
    }
    // Get Ads details in sparate variable
    final AdsModel? i = ad;
    // Print Details in Debug Console
    "Initializing AD SDK".print("AdManagerCubit");
    // Check if Ads are available.
    if (i == null) {
      // Print Details in Debug Console
      return "Ads Not Available".print("AdManagerCubit");
    }
    // Print Details in Debug Console
    "Ads Are Available".print("AdManagerCubit");
    // Check if Ads are enabled.
    if (!(i.adenable)) {
      // Print Details in Debug Console
      return "Ads Are Disabled".print("AdManagerCubit");
    }
    // Print Details in Debug Console
    "Ads Are Enabled".print("AdManagerCubit");
    // Print Details in Debug Console
    "Initializing Google Ads".print("AdManagerCubit");
    // Initialize Admob and AdManager SDK
    MobileAds.instance.initialize();
    // Emit Google Ads State
    return emitState(AdManagerGoogle(
      banner: i.googlebanner.nullSafe,
      native: i.googlenative.nullSafe,
      interstitial: i.googleinterstitial.nullSafe,
    ));
  }
}
