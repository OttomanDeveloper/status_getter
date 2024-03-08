import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_manager/ad_manager_cubit.dart';
import 'package:statusgetter/core/ad_flow/model/ads/ads_model_core.dart';
import 'package:statusgetter/core/ad_flow/setting_repo/settings_repository_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/meta/constants/storage_constants_meta.dart';

class AdServerCubit extends HydratedCubit<AdsModel?> {
  AdServerCubit() : super(null);

  /// Emit new state if the bloc is not closed.
  void emitState(AdsModel? state) {
    if (!isClosed) {
      return emit(state);
    }
  }

  /// Create an Instance of `SettingsRepository`
  final SettingsRepository _repo = SettingsRepository.instance;

  /// Get an Instance of `AdManagerCubit`
  AdManagerCubit get adManager {
    return getItInstance.get<AdManagerCubit>();
  }

  /// Send request to server to load data
  Future<void> fetchData() async {
    /// Send request to Initialize SDK
    adManager.initializeSDK();
    // Get Latest Ads Details from Firestore
    return _repo.fetchAds().then<void>((AdsModel? result) {
      // Print Ads details into Console.
      result?.toString().print("Firestore Ads Settings");
      // Emit New Data
      emitState(result);
      // Send request to Initialize SDK
      return adManager.initializeSDK();
    });
  }

  /// Hold `HydratedCubit` Data Key.
  final String _dataKey = StorageConstants.ads;

  @override
  AdsModel? fromJson(Map<String, dynamic> json) {
    // Get stored data from map
    final String? data = (json[_dataKey] as String?);
    // Check if data is null then don't do anything
    if (data.isEmpty) {
      return null;
    } else {
      return AdsModel.fromDatabase(data.nullSafe);
    }
  }

  @override
  Map<String, dynamic>? toJson(AdsModel? state) {
    return {_dataKey: state?.toDatabase()};
  }
}
