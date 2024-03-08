import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/domain/model/site_model.dart';
import 'package:statusgetter/core/domain/repo/social_repo_domain_core.dart';
import 'package:statusgetter/core/extensions/int/int_extensions_core.dart';
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

  /// Emit new state if the bloc is not closed.
  void emitState({
    required TiktokDownloadState state,
    required Emitter<TiktokDownloadState> emit,
  }) {
    if (!isClosed) {
      return emit(state);
    }
  }

  /// Validate and Start Downloading the file.
  Future<void> _validateAndDownload(
      TiktokDownloadEventDownloadFile event) async {
    if (event.url.isEmpty) {
      return "Input valid url".showSnackbar(event.context);
    }
    // Try to get file extension if possible
    final String? ext = await _getFileType(event.url.trim());
    // Load an Interstitial Ad
    AdManagerFunctions.instance.loadInterstitialAD();
    // Download Video by Given URL
    return FileDownloader.downloadFile(
      url: event.url.trim().nullSafe,
      notificationType: NotificationType.all,
      downloadDestination: DownloadDestinations.publicDownloads,
      name: ext.isNotEmpty
          ? "${DateTime.now().microsecondsSinceEpoch}$ext"
          : null,
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
    emitState(
      emit: emit,
      state: TiktokDownloadLoading(),
    );
    // Send url to fetch details
    return _socialDownloadRepo
        .check(url: url.trim())
        .then<void>((SiteModel? result) {
      // Check if the result is null then emit no data found state
      if (result == null) {
        return emitState(
          emit: emit,
          state: TiktokDownloadNoResult(),
        );
      }
      // pass request response
      return emitState(
        emit: emit,
        state: TiktokDownloadLoaded(result: result),
      );
    });
  }

  /// Validates a user input URL.
  ///
  /// The function checks if the input [value] is empty. If it is, it returns
  /// an error message indicating that a URL needs to be entered.
  ///
  /// Then, it uses a regular expression ([RegExp]) to check if the entered URL
  /// is in a valid format. The regular expression allows URLs that start with
  /// 'http', 'https', or 'ftp', followed by '://', and then any valid URL
  /// characters. If the entered URL doesn't match this pattern, it returns
  /// an error message indicating that a valid URL is required.
  ///
  /// If the [value] is not empty and matches the URL pattern, the function
  /// returns `null`, indicating that the URL is valid.
  ///
  /// Usage example:
  /// ```dart
  /// String? validationResult = validateURL('https://example.com');
  /// if (validationResult != null) {
  ///   print('Validation Error: $validationResult');
  /// } else {
  ///   print('URL is valid.');
  /// }
  /// ```
  String? validateURL(String? value) {
    // Check if the input value is empty
    if (value.isEmpty) {
      return 'Please enter a URL';
    }

    // Regular expression for a valid URL
    final RegExp regExp = RegExp(r'^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$');

    // Check if the entered URL matches the pattern
    if (!regExp.hasMatch(value.nullSafe)) {
      return 'Enter a valid URL';
    }

    // If the URL is not empty and matches the pattern, return null
    return null;
  }

  /// Function to get the file type based on the content type of the provided URL.
  /// Returns the file extension (e.g., ".mp3", ".mp4", ".pdf") or null if not recognized.
  Future<String?> _getFileType(String url) {
    try {
      // Make a HEAD request to the URL to retrieve the response headers
      return Client().head(Uri.parse(url)).then<String?>((Response result) {
        // Check if the response status code is 200 (OK)
        if (result.statusCode.isSame(200)) {
          // Extract the content type from the response headers
          final String? contentType = result.headers['content-type'];

          // Check the content type for specific file types
          if (contentType.nullSafe.contains('audio')) {
            // Return ".mp3" for audio files
            return ".mp3";
          } else if (contentType.nullSafe.contains('video')) {
            // Return ".mp4" for video files
            return ".mp4";
          } else if (contentType.nullSafe.contains('pdf')) {
            // Return ".pdf" for PDF files
            return '.pdf';
          }
        }

        // Return null if the response status code is not 200 or the content type is not recognized
        return null;
      }).catchError((_) => null);
    } catch (e) {
      // Print an error message if an exception occurs during the process
      e.toString().print("_getFileType Error:");
      // Return null in case of an error
      return Future<String?>.value(null);
    }
  }
}
