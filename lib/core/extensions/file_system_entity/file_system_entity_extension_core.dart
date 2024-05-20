import 'dart:io';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';

/// Extension module for FileSystemEntity to add custom functionality.
extension FileSystemEntityExtensionModule on FileSystemEntity {
  /// Getter to check if the file is a video file.
  /// This checks if the file path ends with ".mp4".
  bool get isVideo => path.endsWith(".mp4");

  /// Getter to check if the file is a picture file.
  /// This checks if the file path ends with ".jpg".
  bool get isPicture => path.endsWith(".jpg");
}

/// Extension module on Iterable<FileSystemEntity> to generate a list of StatusItemModel
extension FileSystemEntityListExtensionModule on Iterable<FileSystemEntity> {
  /// Asynchronously generates a list of StatusItemModel representing the
  /// status of each FileSystemEntity in the iterable.
  Future<List<StatusItemModel>> get waStatusList async {
    /// Initialize an empty list to store the status items
    final List<StatusItemModel> items = <StatusItemModel>[];

    /// Iterate through each FileSystemEntity in the iterable
    for (final FileSystemEntity e in this) {
      /// Check if the entity is a picture
      if (e.isPicture) {
        /// Add a StatusItemModel for the picture with isVideo set to false
        items.add(StatusItemModel(
          isVideo: false,
          filePath: e.path,
        ));
      }

      /// Check if the entity is a video
      else if (e.isVideo) {
        /// Generate a thumbnail for the video asynchronously and add a StatusItemModel
        items.add(
          StatusItemModel(
            isVideo: true,
            filePath: e.path,
            videoThumbnail: await WaUtils().getThumbnail(e.path),
          ),
        );
      }
    }

    /// Return the list of status items as a future
    return Future<List<StatusItemModel>>.value(items);
  }
}
