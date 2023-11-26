import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:statusgetter/core/ad_flow/model/ads/ads_model_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';

@immutable
abstract interface class _SettingsRepository {
  /// `fetchAds`
  ///
  /// Get `Ads Detail` from the `Server`
  Future<AdsModel?> fetchAds();

  /// `db`
  ///
  /// Get Initial `Collection` Reference of the `Server`
  @protected
  CollectionReference<Map<String, dynamic>> get db;

  /// `ads`
  ///
  /// Get `Ads` Document Reference of the `Server`
  @protected
  DocumentReference<Map<String, dynamic>> get ads;
}

@immutable
final class SettingsRepository implements _SettingsRepository {
  /// Create an Instance
  static SettingsRepository? _instance;

  /// Privatised the constructor
  SettingsRepository._internal() {
    "SettingsRepository constructor called".print();
  }

  /// Provide a instance whenever it's needed
  static SettingsRepository get instance {
    // Provide a instance if not initialized yet
    _instance ??= SettingsRepository._internal();
    return _instance!;
  }

  /// Create an Instance of `Firestore`
  final FirebaseFirestore _db = FirebaseFirestore.instance
    ..settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

  /// Hold `Settings` Collection `Name`
  final String _settingCollection = "settings";

  /// Hold `Ads` Document for `Settings` Collection `Name`
  final String _adsDocument = "ads";

  @override
  CollectionReference<Map<String, dynamic>> get db {
    return _db.collection(_settingCollection);
  }

  @override
  DocumentReference<Map<String, dynamic>> get ads {
    return _db.collection(_settingCollection).doc(_adsDocument);
  }

  @override
  Future<AdsModel?> fetchAds() {
    try {
      return ads.get().then<AdsModel?>(
        (DocumentSnapshot<Map<String, dynamic>> result) {
          return AdsModel.fromFirestore(result);
        },
      );
    } catch (e) {
      // Print Error in Debug Console
      e.toString().print("SettingsRepository fetchAds Error:");
    }
    // return `null` because there was an error
    return Future<AdsModel?>.value(null);
  }
}
