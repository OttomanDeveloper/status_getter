import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/views/dashboard/cubit/dashboard_cubit.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconBgColor;
  final void Function() onTap;
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color? textColor = context.textTheme.bodyLarge?.color;
    final Color bgColor = iconBgColor ??
        context.theme.colorScheme.primary.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      child: Material(
        color: AppColors.noColor,
        borderRadius: BorderRadius.circular(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            getItInstance
                .get<DashboardCubit>()
                .drawerKey
                .currentState
                ?.openEndDrawer();
            return onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(icon, size: 20.0, color: textColor),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: AutoSizeText(
                    title,
                    maxLines: 1,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.0,
                  color: textColor?.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
