import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/dashboard/cubit/dashboard_cubit.dart';
import 'package:statusgetter/views/dashboard/layouts/business_wa/business_wa_layout_view.dart';
import 'package:statusgetter/views/dashboard/layouts/tiktok_download/tiktok_download_layout_view.dart';
import 'package:statusgetter/views/dashboard/layouts/whatsapp/whatsapp_layout_view.dart';
import 'package:statusgetter/views/widgets/bottom_nav/bottom_nav_dashboard_widget.dart';
import 'package:statusgetter/views/widgets/dialogs/exit_dialog_widget.dart';
import 'package:statusgetter/views/widgets/drawer/drawer_dashboard_widget.dart';
import 'package:statusgetter/views/widgets/scaffold/scaffold_widgets.dart';
import 'package:statusgetter/views/widgets/theme_switch/theme_switch_widget.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  /// Create an Instance of `DashboardCubit`
  late final DashboardCubit cubit = getItInstance.get<DashboardCubit>();

  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }

  /// List to Hold `PageViews`
  final Map<NavigationDestination, Widget> _pageViews =
      <NavigationDestination, Widget>{
    const NavigationDestination(
      label: "WhatsApp",
      icon: Icon(FontAwesomeIcons.whatsapp),
    ): const WhatsAppLayoutView(),
    const NavigationDestination(
      label: "Business WA",
      icon: Icon(FontAwesomeIcons.squareWhatsapp),
    ): const BusinessWhatsAppLayoutView(),
    const NavigationDestination(
      label: "TikTok",
      icon: Icon(FontAwesomeIcons.tiktok),
    ): const TiktokDownloadLayoutView(),
  };

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      globalKey: cubit.drawerKey,
      drawer: const DashboardDrawer(),
      uiOverlay: AppThemes().primaryWithBG(context),
      onWillPop: () async {
        showExitDialog(context);
        return false;
      },
      bottomNavigationBar: DashboardBottomNav(
        destinations: _pageViews.keys.toList(),
      ),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: context.theme.colorScheme.primary,
        surfaceTintColor: context.theme.colorScheme.primary,
        systemOverlayStyle: AppThemes().primaryWithBG(context),
        title: const AutoSizeText(AppSettings.appName, maxLines: 1),
        leading: IconButton(
          onPressed: () {
            return cubit.drawerKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu_outlined),
          color: context.appBar.iconTheme?.color,
        ),
        actions: const <Widget>[
          ThemeModeSwitch(),
          SizedBox(width: 6.0),
        ],
      ),
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: cubit.pageController,
            itemCount: _pageViews.keys.length,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (_, int i) => _pageViews.values.elementAt(i),
            onPageChanged: (int index) {
              return cubit.updateBottomNavIndex(index, movePage: false);
            },
          ),
        ),
      ],
    );
  }
}
