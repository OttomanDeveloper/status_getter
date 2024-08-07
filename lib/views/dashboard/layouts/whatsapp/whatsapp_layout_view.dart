import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/list/list_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/dashboard/layouts/whatsapp/bloc/whatsapp_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/not_installed_text/not_installed_text_widget.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/permission_denied/permission_denied_widget.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/status_viewer_layout/status_viewer_layout_widget.dart';

class WhatsAppLayoutView extends StatefulWidget {
  const WhatsAppLayoutView({super.key});

  @override
  State<WhatsAppLayoutView> createState() => _WhatsAppLayoutViewState();
}

class _WhatsAppLayoutViewState extends State<WhatsAppLayoutView>
    with AutomaticKeepAliveClientMixin {
  /// Create an Instance of `WhatsappBloc`
  final WhatsappBloc _whatsappBloc = getItInstance.get<WhatsappBloc>()
    ..fetchStatus();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: context.width,
      height: context.height,
      child: BlocBuilder<WhatsappBloc, WhatsappState>(
        bloc: _whatsappBloc,
        builder: (BuildContext context, WhatsappState state) {
          if (state.appNotInstalled ?? false) {
            return const NotInstalledTextWidget(
              text: "Oops! WhatsApp is not installed on this device.",
            );
          } else if (state.isLoading ?? false) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state.status.nullSafe.isEmpty) {
            return const NotInstalledTextWidget(
              text:
                  "At the moment, there is no image or video status available.",
            );
          } else if (state.permissionDenied ?? false) {
            return PermissionDeniedWidget(
              onTap: () {
                _whatsappBloc.askStoragePermission();
                return;
              },
            );
          } else if (state.status.nullSafe.isNotEmpty) {
            return StatusViewerLayoutWidget(
              files: state.status.nullSafe,
              pageStorageKey: toStringShort(),
            );
          } else {
            return const NotInstalledTextWidget(
              text: "Please wait...",
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
