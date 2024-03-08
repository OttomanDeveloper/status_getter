import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';

part 'business_whats_app_event.dart';
part 'business_whats_app_state.dart';

class BusinessWhatsAppBloc
    extends Bloc<BusinessWhatsAppEvent, BusinessWhatsAppState> {
  BusinessWhatsAppBloc() : super(BusinessWhatsAppLoading()) {
    on<BusinessWhatsAppEventFetch>((event, emit) async {
      return fetchStatus(emit);
    });
    on<BusinessWhatsAppEventAskPermission>((event, emit) async {
      /// Ask for user device storage permission
      return waUtils.askStoragePermission.then<void>((PermissionStatus status) {
        return fetchStatus(emit);
      });
    });
  }

  /// Emit new state if the bloc is not closed.
  void emitState({
    required BusinessWhatsAppState state,
    required Emitter<BusinessWhatsAppState> emit,
  }) {
    if (!isClosed) {
      return emit(state);
    }
  }

  /// Create an Instance of `WaUtils`
  final WaUtils waUtils = WaUtils()..getDeviceInfo();

  /// Fetch Status from Device Storage
  Future<void> fetchStatus(Emitter<BusinessWhatsAppState> emit) async {
    // Emit Loading State.
    emitState(
      emit: emit,
      state: BusinessWhatsAppLoading(),
    );
    // Check permission status. If permission granted then continue the process.
    if ((await waUtils.askStoragePermission).isDenied) {
      "Storage denied".print("Permission");
      // Emit Permission Denied State.
      return emitState(
        emit: emit,
        state: BusinessWhatsAppPermissionDenied(),
      );
    }
    // Now try to get BusinessWhatsApp status from user Device.
    final Directory directory = Directory(await waUtils.whatsAppBusinessPath);
    // Check if the given directory exists or not
    if (await directory.exists()) {
      // BusinessWhatsApp is installed so now get status from device.
      final Iterable<FileSystemEntity> results =
          directory.listSync().where((FileSystemEntity e) {
        return (e.path.endsWith(".mp4") || e.path.endsWith(".jpg"));
      });
      // Check if status available then emit status available state
      // otherwise status not available state.
      if (results.isNotEmpty) {
        return emitState(
          emit: emit,
          state: BusinessWhatsAppStatusAvailable(status: results.toList()),
        );
      } else {
        return emitState(
          emit: emit,
          state: BusinessWhatsAppStatusNotAvailable(),
        );
      }
    } else {
      // BusinessWhatsApp is not installed on user device.
      return emitState(
        emit: emit,
        state: BusinessWhatsAppNotInstalled(),
      );
    }
  }
}
