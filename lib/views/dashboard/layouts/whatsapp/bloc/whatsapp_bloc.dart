import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';

part 'whatsapp_event.dart';
part 'whatsapp_state.dart';

class WhatsappBloc extends Bloc<WhatsappEvent, WhatsappState> {
  WhatsappBloc() : super(WhatsappLoading()) {
    on<WhatsappEventFetch>((event, emit) async {
      return fetchStatus(emit);
    });
    on<WhatsappEventAskPermission>((event, emit) async {
      /// Ask for user device storage permission
      return waUtils.askStoragePermission.then<void>((PermissionStatus status) {
        return fetchStatus(emit);
      });
    });
  }

  /// Create an Instance of `WaUtils`
  final WaUtils waUtils = WaUtils()..getDeviceInfo();

  /// Fetch Status from Device Storage
  Future<void> fetchStatus(Emitter<WhatsappState> emit) async {
    // Emit Loading State.
    emit(WhatsappLoading());
    // Check permission status. If permission granted then continue the process.
    if ((await waUtils.askStoragePermission).isDenied) {
      "Storage denied".print("Permission");
      // Emit Permission Denied State.
      return emit(WhatsAppPermissionDenied());
    }
    // Now try to get WhatsApp status from user Device.
    final Directory directory = Directory(await waUtils.whatsAppPath);
    // Check if the given directory exists or not
    if (await directory.exists()) {
      // WhatsApp is installed so now get status from device.
      final Iterable<FileSystemEntity> results =
          directory.listSync().where((FileSystemEntity e) {
        return (e.path.endsWith(".mp4") || e.path.endsWith(".jpg"));
      });
      // Check if status available then emit status available state
      // otherwise status not available state.
      if (results.isNotEmpty) {
        return emit(WhatsAppStatusAvailable(status: results.toList()));
      } else {
        return emit(WhatsAppStatusNotAvailable());
      }
    } else {
      // WhatsApp is not installed on user device.
      return emit(WhatsAppNotInstalled());
    }
  }
}
