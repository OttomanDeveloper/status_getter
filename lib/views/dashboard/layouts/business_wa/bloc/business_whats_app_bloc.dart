import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:statusgetter/core/extensions/file_system_entity/file_system_entity_extension_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';

part 'business_whats_app_state.dart';

class BusinessWhatsAppBloc extends Cubit<BusinessWhatsAppState> {
  BusinessWhatsAppBloc() : super(const BusinessWhatsAppState(isLoading: true));

  /// Emit new state if the bloc is not closed.
  void emitState(BusinessWhatsAppState state) {
    if (!isClosed) {
      return emit(state);
    }
  }

  /// Requests permission from the user to access device storage and then fetches the status.
  Future<void> askStoragePermission() {
    // Asks the user for storage permission using a utility function.
    return waUtils.askStoragePermission.then<void>((_) {
      // After permission is granted, fetches the storage status.
      return fetchStatus();
    });
  }

  /// Create an Instance of `WaUtils`
  final WaUtils waUtils = WaUtils()..getDeviceInfo();

  /// Fetches BusinessWhatsApp status from the device storage.
  Future<void> fetchStatus() async {
    /// Emit Loading State to indicate that the process has started.
    emitState(const BusinessWhatsAppState(isLoading: true));

    /// Check permission status for accessing device storage.
    /// If permission is denied, print a message and emit Permission Denied State.
    if ((await waUtils.askStoragePermission).isDenied) {
      "Storage denied".print("Permission");
      return emitState(const BusinessWhatsAppState(permissionDenied: true));
    }

    /// Try to get the path for BusinessWhatsApp from the user's device.
    final Directory directory = Directory(await waUtils.whatsAppBusinessPath);

    /// Check if the BusinessWhatsApp directory exists.
    if (await directory.exists()) {
      /// If the directory exists, list its contents and emit Status Available State.
      /// Otherwise, emit Status Not Available State.
      return emitState(BusinessWhatsAppState(
        status: await directory.listSync().waStatusList,
      ));
    } else {
      /// If the directory does not exist, it means BusinessWhatsApp is not installed.
      return emitState(const BusinessWhatsAppState(appNotInstalled: true));
    }
  }
}
