import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/domain/model/site_model.dart';
import 'package:statusgetter/core/domain/repo/social_repo_domain_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';

part 'tiktok_download_event.dart';
part 'tiktok_download_state.dart';

class TiktokDownloadBloc
    extends Bloc<TiktokDownloadEvent, TiktokDownloadState> {
  final SocialDownloadRepo _socialDownloadRepo;
  TiktokDownloadBloc(this._socialDownloadRepo)
      : super(TiktokDownloadInitial()) {
    on<TiktokDownloadEventFetch>((event, emit) async {
      return _fetchUrlDetails(url: event.url, emit: emit);
    });
    on<TiktokDownloadEventDownloadFile>((event, emit) async {
      return _validateAndDownload(event);
    });
  }

  /// Validate and Start Downloading the file.
  Future<void> _validateAndDownload(TiktokDownloadEventDownloadFile event) {
    if (event.url.isEmpty) {
      return "Input valid url".showSnackbar(event.context);
    }
    // Load an Interstitial Ad
    AdManagerFunctions.instance.loadInterstitialAD();
    // Download Video by Given URL
    return FileDownloader.downloadFile(
      url: event.url.nullSafe,
      notificationType: NotificationType.all,
      downloadDestination: DownloadDestinations.publicDownloads,
      onProgress: (String? fileName, double? progress) {
        'FILE $fileName HAS PROGRESS $progress'.print();
      },
      onDownloadCompleted: (String path) {
        return 'FILE DOWNLOADED TO PATH: $path'.print();
      },
      onDownloadError: (String error) {
        return 'DOWNLOAD ERROR: $error'.print();
      },
    ).then((File? value) => null);
  }

  /// Fetch Request URL
  Future<void> _fetchUrlDetails({
    required String url,
    required Emitter<TiktokDownloadState> emit,
  }) {
    /// Emit Loading state until we got something back to return
    emit(TiktokDownloadLoading());
    // Send url to fetch details
    return _socialDownloadRepo.check(url: url).then<void>((SiteModel? result) {
      // Check if the result is null then emit no data found state
      if (result == null) {
        return emit(TiktokDownloadNoResult());
      }
      // pass request response
      return emit(TiktokDownloadLoaded(result: result));
    });
  }

  /// Validate User Input URL
  String? validateURL(String? value) {
    if (value.isEmpty) {
      return 'Please enter a URL';
    }
    // Regular expression for a valid URL
    final RegExp regExp = RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$');
    if (!regExp.hasMatch(value.nullSafe)) {
      return 'Enter a valid URL';
    }
    return null;
  }
}
