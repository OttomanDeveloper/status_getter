import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/dashboard/layouts/business_wa/bloc/business_whats_app_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/item_card/item_card_widget.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/not_installed_text/not_installed_text_widget.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/permission_denied/permission_denied_widget.dart';

class BusinessWhatsAppLayoutView extends StatefulWidget {
  const BusinessWhatsAppLayoutView({super.key});

  @override
  State<BusinessWhatsAppLayoutView> createState() =>
      _BusinessWhatsAppLayoutViewState();
}

class _BusinessWhatsAppLayoutViewState extends State<BusinessWhatsAppLayoutView>
    with AutomaticKeepAliveClientMixin {
  /// Create an Instance of `BusinessWhatsAppBloc`
  final BusinessWhatsAppBloc _businessWhatsAppBloc = getItInstance
      .get<BusinessWhatsAppBloc>()
    ..add(BusinessWhatsAppEventFetch());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<BusinessWhatsAppBloc, BusinessWhatsAppState>(
      bloc: _businessWhatsAppBloc,
      builder: (BuildContext context, BusinessWhatsAppState state) {
        if (state is BusinessWhatsAppNotInstalled) {
          return const NotInstalledTextWidget(
            text: "Oops! WhatsApp Business is not installed on this device.",
          );
        } else if (state is BusinessWhatsAppLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is BusinessWhatsAppStatusNotAvailable) {
          return const NotInstalledTextWidget(
            text: "At the moment, there is no image or video status available.",
          );
        } else if (state is BusinessWhatsAppPermissionDenied) {
          return PermissionDeniedWidget(
            onTap: () {
              _businessWhatsAppBloc.add(BusinessWhatsAppEventAskPermission());
            },
          );
        } else if (state is BusinessWhatsAppStatusAvailable) {
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
