import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/core/router/router_name.dart';
import 'package:statusgetter/meta/assets/assets_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/widgets/scaffold/scaffold_widgets.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      uiOverlay: AppThemes().normalGB(context),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      mainAxisAlignment: MainAxisAlignment.center,
      initState: () {
        // Get Android Device Information
        WaUtils().getDeviceInfo();
        return WidgetsBinding.instance.addPostFrameCallback((_) {
          // get Ads from Server
          AdManagerFunctions.instance.adServerCubit.fetchData();
          //You can enable or disable the log, this will help you track your download batches
          FileDownloader.setLogEnabled(kDebugMode);
          // Wait for a second and move to setup screen
          Future<void>.delayed(const Duration(seconds: 1), () {
            return context.pushReplacement(AppRoutes.dashboard);
          });
          return;
        });
      },
      children: <Widget>[Image.asset(Assets.icon, width: 220.0, height: 220.0)],
    );
  }
}
