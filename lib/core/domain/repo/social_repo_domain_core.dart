import 'package:flutter/material.dart';
import 'package:statusgetter/core/domain/mixin/social_mixin_domain_core.dart';
import 'package:statusgetter/core/domain/model/site_model.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';

@immutable
abstract interface class _SocialDownloadRepo {
  /// Check Request url and If it's valid then return SiteModel
  Future<SiteModel?> check({
    Duration? duration,
    required String url,
  });
}

@immutable
class SocialDownloadRepo with SocialDomainMixin implements _SocialDownloadRepo {
  /// puppeteer executablePath
  final String? executablePath;

  const SocialDownloadRepo({this.executablePath});

  @override
  Future<SiteModel?> check({Duration? duration, required String url}) {
    try {
      return get(
        url: url,
        timeout: duration,
        executablePath: executablePath,
      );
    } catch (e) {
      e.toString().print("SocialDownloadRepo check: Error");
      return Future<SiteModel?>.value(null);
    }
  }
}
