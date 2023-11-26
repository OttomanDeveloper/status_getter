import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/dashboard/layouts/whatsapp/bloc/whatsapp_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/item_card/item_card_widget.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/not_installed_text/not_installed_text_widget.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/permission_denied/permission_denied_widget.dart';

class WhatsAppLayoutView extends StatefulWidget {
  const WhatsAppLayoutView({super.key});

  @override
  State<WhatsAppLayoutView> createState() => _WhatsAppLayoutViewState();
}

class _WhatsAppLayoutViewState extends State<WhatsAppLayoutView>
    with AutomaticKeepAliveClientMixin {
  /// Create an Instance of `WhatsappBloc`
  final WhatsappBloc _whatsappBloc = getItInstance.get<WhatsappBloc>()
    ..add(WhatsappEventFetch());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<WhatsappBloc, WhatsappState>(
      bloc: _whatsappBloc,
      builder: (BuildContext context, WhatsappState state) {
        if (state is WhatsAppNotInstalled) {
          return const NotInstalledTextWidget(
            text: "Oops! WhatsApp is not installed on this device.",
          );
        } else if (state is WhatsappLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is WhatsAppStatusNotAvailable) {
          return const NotInstalledTextWidget(
            text: "At the moment, there is no image or video status available.",
          );
        } else if (state is WhatsAppPermissionDenied) {
          return PermissionDeniedWidget(
            onTap: () {
              _whatsappBloc.add(WhatsappEventAskPermission());
            },
          );
        } else if (state is WhatsAppStatusAvailable) {
          return GridView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            children: List<Widget>.generate(state.status.length, (int index) {
              return WhatsAppItemCard(itemPath: state.status[index]);
            }),
          );
        } else {
          return const NotInstalledTextWidget(text: "Please wait...");
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
