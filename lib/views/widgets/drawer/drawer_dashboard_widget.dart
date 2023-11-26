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

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4.0,
      shape: InputBorder.none,
      width: context.width * 0.75,
      backgroundColor: context.bgColor,
      surfaceTintColor: context.bgColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.kWhite),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(Assets.icon),
                  ),
                ),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary,
                ),
                accountName: AutoSizeText(
                  maxLines: 1,
                  AppSettings.appName,
                  textAlign: TextAlign.start,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.kWhite.withOpacity(0.9),
                  ),
                ),
                accountEmail: AutoSizeText(
                  maxLines: 1,
                  "If you encounter any issues, let us know.",
                  textAlign: TextAlign.start,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.kWhite.withOpacity(0.9),
                    fontSize: 12.0,
                  ),
                ),
              ),
              DrawerItem(
                onTap: () {
                  Share.share(
                    '${AppSettings.shareMessage} ${settings?.appstoreurl}',
                  );
                  return;
                },
                title: "Share",
                icon: Icons.share_outlined,
              ),
              DrawerItem(
                onTap: () {
                  settings?.privacyPolicyUrl.openURL();
                  return;
                },
                title: "Privacy Policy",
                icon: Icons.privacy_tip_outlined,
              ),
              DrawerItem(
                onTap: () {
                  settings?.appstoreurl.openURL();
                  return;
                },
                title: "Rate Us",
                icon: Icons.rate_review_outlined,
              ),
              DrawerItem(
                icon: Icons.clear,
                title: "Close App",
                onTap: () => showExitDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Create an Instance of `AdManagerFunctions`
  AdsModel? get settings {
    return AdManagerFunctions.instance.adServerCubit.state;
  }
}
