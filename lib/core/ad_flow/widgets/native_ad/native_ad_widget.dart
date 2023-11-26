import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_manager/ad_manager_cubit.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';

class NativeAdWidget extends StatefulWidget {
  final TemplateType adType;
  const NativeAdWidget({
    super.key,
    this.adType = TemplateType.medium,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget>
    with AutomaticKeepAliveClientMixin {
  /// Hold State of is Ad Load Sent
  bool _isAdLoadRequestSent = false;

  /// Completer to Hold `NativeAd` State
  final Completer<NativeAd> nativeCompleter = Completer<NativeAd>();

  /// Create an Instance of `AdManagerCubit`
  final AdManagerCubit ad = getItInstance.get<AdManagerCubit>();

  /// Hold Native Ad
  NativeAd? _nativeAd;

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Now listen and send request to load ad
      if (!_isAdLoadRequestSent) {
        loadNativeAd();
      }
      return;
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  /// Update `isAdLoadRequestSent` State
  void updateIsAdLoadRequestSent(bool state) {
    _isAdLoadRequestSent = state;
    return;
  }

  /// Validate and send request to Load `NativeAd`
  void loadNativeAd() {
    // Check if Ad Network is Not Google then Reject the Request
    if (ad.state is AdManagerInitial) {
      // Print Details in Debug Console
      return "Not Allowed to Load NativeAd".print("NativeAdWidget");
    }
    // Get Native AdUnit
    final String adunit = (ad.state as AdManagerGoogle).native;
    // Print Details in Debug Console
    "Google Ads are enabled".print("NativeAdWidget");
    // Check if Native `AdUnit` is Available then send a request to load
    // Otherwise close this return the function.
    // Check if already ad load request sent then don't send another request
    if (adunit.isEmpty || _isAdLoadRequestSent) {
      // Print Details in Debug Console
      return "AdUnit is Empty or Request sent".print("NativeAdWidget");
    }
    // Save `updateIsAdLoadRequestSent` to `true`
    updateIsAdLoadRequestSent(true);
    // Send request to load `NativeAd`
    _nativeAd = NativeAd(
      adUnitId: adunit,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          // Native Ad loaded
          "Native Ad Loaded".print("loadNativeAd");
          // Mark Completer as Complete
          nativeCompleter.complete(ad as NativeAd);
          return;
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) async {
          error.toString().print("failedToLoad NativeAd");
          // Dispose the ad here to free resources.
          ad.dispose();
          // Mark Completer as CompleteError
          return nativeCompleter.completeError(error);
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        // Required: Choose a template.
        templateType: widget.adType,
        // Optional: Customize the ad's style.
        mainBackgroundColor: context.bgColor,
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          size: 16.0,
          textColor: AppColors.kWhite,
          style: NativeTemplateFontStyle.monospace,
          backgroundColor: context.theme.colorScheme.primary,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          size: 16.0,
          backgroundColor: context.bgColor,
          textColor: context.theme.colorScheme.primary,
          style: NativeTemplateFontStyle.italic,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          size: 16.0,
          backgroundColor: context.bgColor,
          style: NativeTemplateFontStyle.bold,
          textColor: context.theme.colorScheme.secondary,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          size: 16.0,
          backgroundColor: context.bgColor,
          textColor: context.theme.colorScheme.primary,
          style: NativeTemplateFontStyle.normal,
        ),
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AdManagerCubit, AdManagerState>(
      bloc: ad,
      builder: (BuildContext _, AdManagerState state) {
        if (state is AdManagerGoogle) {
          if (state.native.isNotEmpty) {
            return _AdmobNativeAd(
              nativeAd: _nativeAd,
              adType: widget.adType,
              nativeCompleter: nativeCompleter,
            );
          }
        }
        // don't show anything.
        return const SizedBox.shrink();
      },
    );
  }
}

/// Hold `_AdmobNativeAd` Widget
class _AdmobNativeAd extends StatelessWidget {
  final NativeAd? nativeAd;
  final TemplateType adType;
  final Completer<NativeAd> nativeCompleter;
  const _AdmobNativeAd({
    required this.adType,
    required this.nativeAd,
    required this.nativeCompleter,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NativeAd>(
      future: nativeCompleter.future,
      builder: (_, AsyncSnapshot<NativeAd> snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData && snap.data != null) {
            /// Hold admob native `AdSize`
            late final BoxConstraints constraints;
            // Apply `AdSize` based on `TemplateType`
            if (adType.name.isSame(TemplateType.medium.name)) {
              constraints = BoxConstraints(
                minHeight: 320,
                maxHeight: 350,
                minWidth: context.sizeApi.width,
                maxWidth: context.sizeApi.width,
              );
            } else {
              constraints = BoxConstraints(
                minHeight: 90,
                maxHeight: 115,
                minWidth: context.sizeApi.width,
                maxWidth: context.sizeApi.width,
              );
            }
            // return the adSize
            return Container(
              color: context.bgColor,
              constraints: constraints,
              child: AdWidget(ad: snap.data!),
            );
          }
        }
        // Ad is not ready yet so don't show anything
        return const SizedBox.shrink();
      },
    );
  }
}
