import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';

Future<void> showExitDialog(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: AppSettings.empty,
    barrierColor: AppColors.kBlack.withOpacity(0.2),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (_, Animation<double> a1, Animation<double> a2, __) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: const _ExitDialog(),
        ),
      );
    },
  );
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4.0,
      backgroundColor: context.bgColor,
      surfaceTintColor: context.bgColor,
      insetPadding: EdgeInsets.symmetric(horizontal: (context.width * 0.06)),
      child: Container(
        width: context.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Exit App',
              maxLines: 1,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            AutoSizeText(
              maxLines: 3,
              style: context.textTheme.bodyMedium,
              'Are you sure you want to exit the app?',
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const Spacer(),
                TextButton(
                  child: const AutoSizeText('Cancel', maxLines: 1),
                  onPressed: () => context.popNavigator(),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () => SystemNavigator.pop(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      context.theme.colorScheme.primary,
                    ),
                    surfaceTintColor: MaterialStatePropertyAll(
                      context.theme.colorScheme.primary,
                    ),
                    foregroundColor: const MaterialStatePropertyAll(
                      AppColors.kWhite,
                    ),
                    iconColor: const MaterialStatePropertyAll(
                      AppColors.kWhite,
                    ),
                  ),
                  child: const AutoSizeText('Exit', maxLines: 1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
