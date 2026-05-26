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

  /// Requests permission and then fetches statuses.
  Future<void> askStoragePermission() async {
    await waUtils.ensureDeviceInfo();
    if (waUtils.useSaf) {
      try {
        final String? treeUri = await waUtils.requestSafPermission(
          WaUtils.whatsAppBusinessSafPath,
        );
        if (treeUri != null) return fetchStatus();
      } catch (_) {}
      return;
    }
    await waUtils.askLegacyStoragePermission;
    return fetchStatus();
  }

  /// Create an Instance of `WaUtils`
  final WaUtils waUtils = WaUtils()..getDeviceInfo();

  /// Fetches BusinessWhatsApp status from the device storage.
  Future<void> fetchStatus() async {
    emitState(const BusinessWhatsAppState(isLoading: true));
    await waUtils.ensureDeviceInfo();

    if (waUtils.useSaf) {
      try {
        final String? treeUri = await waUtils.checkSafPermission(
          WaUtils.whatsAppBusinessSafPath,
        );
        if (treeUri == null) {
          return emitState(const BusinessWhatsAppState(permissionDenied: true));
        }
        final List<StatusItemModel>? statuses =
            await waUtils.fetchStatusesViaSaf(treeUri);
        if (statuses != null && statuses.isNotEmpty) {
          return emitState(BusinessWhatsAppState(status: statuses));
        }
        return emitState(const BusinessWhatsAppState(appNotInstalled: true));
      } catch (_) {
        return emitState(const BusinessWhatsAppState(permissionDenied: true));
      }
    }

    // ── SDK < 30: Legacy path ──
    if ((await waUtils.askLegacyStoragePermission).isDenied) {
      "Storage denied".print("Permission");
      return emitState(const BusinessWhatsAppState(permissionDenied: true));
    }
    final Directory directory = Directory(await waUtils.whatsAppBusinessPath);
    if (await directory.exists()) {
      return emitState(BusinessWhatsAppState(
        status: await directory.listSync().waStatusList,
      ));
    }
    return emitState(const BusinessWhatsAppState(appNotInstalled: true));
  }
}
