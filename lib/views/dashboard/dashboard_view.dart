import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/dashboard/cubit/dashboard_cubit.dart';
import 'package:statusgetter/views/dashboard/layouts/business_wa/business_wa_layout_view.dart';
import 'package:statusgetter/views/dashboard/layouts/tiktok_download/tiktok_download_layout_view.dart';
import 'package:statusgetter/views/dashboard/layouts/whatsapp/whatsapp_layout_view.dart';
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
  late final DashboardCubit cubit = getItInstance.get<DashboardCubit>();

  @override
  void dispose() {
    cubit.dispose();
    super.dispose();
  }

  static final List<({String label, FaIconData icon})> _tabs = [
    (label: "WhatsApp", icon: FontAwesomeIcons.whatsapp),
    (label: "Business", icon: FontAwesomeIcons.squareWhatsapp),
    (label: "TikTok", icon: FontAwesomeIcons.tiktok),
  ];

  static const List<Widget> _pages = <Widget>[
    WhatsAppLayoutView(),
    BusinessWhatsAppLayoutView(),
    TiktokDownloadLayoutView(),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.theme.colorScheme;

    return CustomScaffold(
      isScrollable: false,
      globalKey: cubit.drawerKey,
      drawer: const DashboardDrawer(),
      uiOverlay: AppThemes().primaryWithBG(context),
      onWillPop: () async {
        showExitDialog(context);
        return false;
      },
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: scheme.primary,
        surfaceTintColor: scheme.primary,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0),
            child: BlocBuilder<DashboardCubit, int>(
              bloc: cubit,
              builder: (BuildContext context, int selectedIndex) {
                return Container(
                  height: 40.0,
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints constraints) {
                      final double tabWidth =
                          constraints.maxWidth / _tabs.length;
                      return Stack(
                        children: <Widget>[
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            left: selectedIndex * tabWidth,
                            top: 0,
                            bottom: 0,
                            width: tabWidth,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.kWhite,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Row(
                              children: List<Widget>.generate(
                                _tabs.length,
                                (int i) {
                                  final bool isActive = i == selectedIndex;
                                  return Expanded(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () =>
                                          cubit.updateBottomNavIndex(
                                        i,
                                        movePage: true,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                      children: <Widget>[
                                        FaIcon(
                                          _tabs[i].icon,
                                          size: 14.0,
                                          color: isActive
                                              ? scheme.primary
                                              : AppColors.kWhite
                                                  .withValues(alpha: 0.7),
                                        ),
                                        const SizedBox(width: 6.0),
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          curve: Curves.easeOutCubic,
                                          style: context
                                              .textTheme.labelMedium!
                                              .copyWith(
                                            fontWeight: isActive
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isActive
                                                ? scheme.primary
                                                : AppColors.kWhite
                                                    .withValues(alpha: 0.7),
                                          ),
                                          child: Text(_tabs[i].label),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
      children: <Widget>[
        Expanded(
          child: PageView.builder(
            controller: cubit.pageController,
            itemCount: _pages.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (_, int i) => _pages[i],
            onPageChanged: (int index) {
              return cubit.updateBottomNavIndex(index, movePage: false);
            },
          ),
        ),
      ],
    );
  }
}
