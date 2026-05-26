import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:statusgetter/core/extensions/file_system_entity/file_system_entity_extension_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/core/model/status_item/status_item_model.dart';

part 'whatsapp_state.dart';

class WhatsappBloc extends Cubit<WhatsappState> {
  WhatsappBloc() : super(const WhatsappState(isLoading: true));

  /// Emit new state if the bloc is not closed.
  void emitState(WhatsappState state) {
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
          WaUtils.whatsAppSafPath,
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

  /// Fetches the status from device storage and updates the application state accordingly.
  Future<void> fetchStatus() async {
    emitState(const WhatsappState(isLoading: true));
    await waUtils.ensureDeviceInfo();

    if (waUtils.useSaf) {
      try {
        final String? treeUri = await waUtils.checkSafPermission(
          WaUtils.whatsAppSafPath,
        );
        if (treeUri == null) {
          return emitState(const WhatsappState(permissionDenied: true));
        }
        final List<StatusItemModel>? statuses =
            await waUtils.fetchStatusesViaSaf(treeUri);
        if (statuses != null && statuses.isNotEmpty) {
          return emitState(WhatsappState(status: statuses));
        }
        return emitState(const WhatsappState(appNotInstalled: true));
      } catch (_) {
        return emitState(const WhatsappState(permissionDenied: true));
      }
    }

    // ── SDK < 30: Legacy path ──
    if ((await waUtils.askLegacyStoragePermission).isDenied) {
      "Storage denied".print("Permission");
      return emitState(const WhatsappState(permissionDenied: true));
    }
    final Directory directory = Directory(await waUtils.whatsAppPath);
    if (await directory.exists()) {
      return emitState(WhatsappState(
        status: await directory.listSync().waStatusList,
      ));
    }
    return emitState(const WhatsappState(appNotInstalled: true));
  }
}
