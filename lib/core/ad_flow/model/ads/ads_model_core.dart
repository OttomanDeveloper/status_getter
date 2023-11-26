import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/map/map_extension_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';

@immutable
class AdsModel {
  final bool adenable;
  final String? appstoreurl;
  final String? googlebanner;
  final String? googlenative;
  final String? privacyPolicyUrl;
  final String? googleinterstitial;

  const AdsModel({
    this.appstoreurl,
    this.googlebanner,
    this.googlenative,
    this.adenable = false,
    this.privacyPolicyUrl,
    this.googleinterstitial,
  });

  Map<String, dynamic> newRecord() {
    return <String, dynamic>{
      'adenable': adenable,
      'appstoreurl': appstoreurl,
      'googlebanner': googlebanner,
      'googlenative': googlenative,
      'privacyPolicyUrl': privacyPolicyUrl,
      'googleinterstitial': googleinterstitial,
    };
  }

  /// Parse Firestore `DocumentSnapshot` Into a `Model`
  factory AdsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    try {
      // Get `Document` Data in a `Separate` Variable
      final Map<String, dynamic> data = document.data().nullSafe;
      // Check if Document has Data or not
      if (document.exists && data.isNotEmpty) {
        return AdsModel._fromMapDatabase(data);
      }
    } catch (e) {
      // Print error in debug console
      e.toString().print("AdsModel.fromFirestore Error");
    }
    // Document has an error so return an empty model
    return const AdsModel();
  }

  factory AdsModel._fromMapDatabase(Map<String, dynamic> map) {
    return AdsModel(
      adenable: (map['adenable'] as bool?) ?? false,
      appstoreurl:
          map['appstoreurl'] != null ? map['appstoreurl'] as String : null,
      googlebanner:
          map['googlebanner'] != null ? map['googlebanner'] as String : null,
      googlenative:
          map['googlenative'] != null ? map['googlenative'] as String : null,
      privacyPolicyUrl: map['privacyPolicyUrl'] != null
          ? map['privacyPolicyUrl'] as String
          : null,
      googleinterstitial: map['googleinterstitial'] != null
          ? map['googleinterstitial'] as String
          : null,
    );
  }

  String toDatabase() => json.encode(newRecord());

  factory AdsModel.fromDatabase(String source) {
    return AdsModel._fromMapDatabase(
      json.decode(source) as Map<String, dynamic>,
    );
  }

  @override
  bool operator ==(covariant AdsModel other) {
    if (identical(this, other)) return true;

    return other.adenable == adenable &&
        other.appstoreurl == appstoreurl &&
        other.googlebanner == googlebanner &&
        other.googlenative == googlenative &&
        other.privacyPolicyUrl == privacyPolicyUrl &&
        other.googleinterstitial == googleinterstitial;
  }

  @override
  int get hashCode {
    return adenable.hashCode ^
        appstoreurl.hashCode ^
        googlebanner.hashCode ^
        googlenative.hashCode ^
        privacyPolicyUrl.hashCode ^
        googleinterstitial.hashCode;
  }

  @override
  String toString() {
    return 'AdsModel(adenable: $adenable, appstoreurl: $appstoreurl, googlebanner: $googlebanner, googlenative: $googlenative, privacyPolicyUrl: $privacyPolicyUrl, googleinterstitial: $googleinterstitial)';
  }
}
