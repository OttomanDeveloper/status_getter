import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:go_router/go_router.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/utils/utils_fun_core.dart';
import 'package:statusgetter/core/router/router_name.dart';
import 'package:statusgetter/meta/assets/assets_meta.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/widgets/scaffold/scaffold_widgets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  late final Animation<double> _scaleAnim = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutBack,
  );

  late final Animation<double> _fadeAnim = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    WaUtils().getDeviceInfo();
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdManagerFunctions.instance.adServerCubit.fetchData();
      FileDownloader.setLogEnabled(kDebugMode);
      Future<void>.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) context.pushReplacement(AppRoutes.dashboard);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = context.theme.colorScheme;

    return CustomScaffold(
      isScrollable: false,
      uiOverlay: AppThemes().normalGB(context),
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Spacer(flex: 3),
        ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  Assets.icon,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: <Widget>[
              AutoSizeText(
                AppSettings.appName,
                maxLines: 1,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 6.0),
              AutoSizeText(
                "Save & share statuses",
                maxLines: 1,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        const Spacer(flex: 2),
        FadeTransition(
          opacity: _fadeAnim,
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: scheme.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 40.0),
        FadeTransition(
          opacity: _fadeAnim,
          child: Text(
            "v1.2.0",
            style: context.textTheme.labelSmall?.copyWith(
              color: context.textTheme.bodySmall?.color?.withValues(
                alpha: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
