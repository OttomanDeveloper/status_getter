import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/ad_flow/model/ads/ads_model_core.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/meta/assets/assets_meta.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/views/widgets/dialogs/exit_dialog_widget.dart';
import 'package:statusgetter/views/widgets/drawer/drawer_tile_dashboard_widget.dart';
import 'package:statusgetter/views/widgets/theme_switch/theme_switch_widget.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.theme.colorScheme;

    return Drawer(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20.0)),
      ),
      width: context.width * 0.78,
      backgroundColor: context.bgColor,
      surfaceTintColor: context.bgColor,
      child: Column(
        children: <Widget>[
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 24.0,
              left: 24.0,
              right: 24.0,
              bottom: 24.0,
            ),
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(28.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.kWhite.withValues(alpha: 0.5),
                      width: 2.0,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage(Assets.icon),
                  ),
                ),
                const SizedBox(height: 16.0),
                AutoSizeText(
                  AppSettings.appName,
                  maxLines: 1,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.kWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4.0),
                AutoSizeText(
                  "Save & share statuses easily",
                  maxLines: 1,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.kWhite.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12.0),

          // Menu items
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  DrawerItem(
                    icon: Icons.share_rounded,
                    title: "Share App",
                    onTap: () {
                      SharePlus.instance.share(
                        ShareParams(
                          text:
                              '${AppSettings.shareMessage} ${settings?.appstoreurl}',
                        ),
                      );
                    },
                  ),
                  DrawerItem(
                    icon: Icons.privacy_tip_rounded,
                    title: "Privacy Policy",
                    onTap: () => settings?.privacyPolicyUrl.openURL(),
                  ),
                  DrawerItem(
                    icon: Icons.star_rounded,
                    title: "Rate Us",
                    onTap: () => settings?.appstoreurl.openURL(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 8.0,
                    ),
                    child: Divider(height: 1.0),
                  ),
                  DrawerItem(
                    icon: Icons.power_settings_new_rounded,
                    title: "Exit App",
                    iconBgColor: Colors.red.withValues(alpha: 0.1),
                    onTap: () => showExitDialog(context),
                  ),
                ],
              ),
            ),
          ),

          // Footer — theme switch
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 20.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.palette_rounded,
                  size: 20.0,
                  color: context.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 10.0),
                Text(
                  "Appearance",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const ThemeModeSwitch(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AdsModel? get settings {
    return AdManagerFunctions.instance.adServerCubit.state;
  }
}
