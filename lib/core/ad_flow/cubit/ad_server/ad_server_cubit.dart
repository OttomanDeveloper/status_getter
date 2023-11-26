import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_manager/ad_manager_cubit.dart';
import 'package:statusgetter/core/ad_flow/model/ads/ads_model_core.dart';
import 'package:statusgetter/core/ad_flow/setting_repo/settings_repository_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/meta/constants/storage_constants_meta.dart';

class AdServerCubit extends HydratedCubit<AdsModel?> {
  AdServerCubit() : super(null);

  /// Create an Instance of `SettingsRepository`
  final SettingsRepository _repo = SettingsRepository.instance;

  /// Get an Instance of `AdManagerCubit`
  AdManagerCubit get adManager {
    return getItInstance.get<AdManagerCubit>();
  }

  /// Send request to server to load data
  void fetchData() async {
    /// Send request to Initialize SDK
    adManager.initializeSDK();
    // Get Latest Ads Details from Firestore
    return _repo.fetchAds().then<void>((AdsModel? result) {
      // Emit New Data
      emit(result);
      // Send request to Initialize SDK
      return adManager.initializeSDK();
    });
  }

  @override
  AdsModel? fromJson(Map<String, dynamic> json) {
    // Get stored data from map
    final String? data = (json[StorageConstants.ads] as String?);
    // Check if data is null then don't do anything
    if (data.isEmpty) {
      return null;
    } else {
      return AdsModel.fromDatabase(data.nullSafe);
    }
  }

  @override
  Map<String, dynamic>? toJson(AdsModel? state) {
    return {StorageConstants.ads: state?.toDatabase()};
  }
}
