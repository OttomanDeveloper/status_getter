import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/dashboard/cubit/dashboard_cubit.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;
  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        getItInstance
            .get<DashboardCubit>()
            .drawerKey
            .currentState
            ?.openEndDrawer();
        return onTap();
      },
      title: AutoSizeText(
        title,
        maxLines: 1,
        style: context.textTheme.bodyMedium?.copyWith(fontSize: 15.0),
      ),
      leading: Icon(icon),
      tileColor: context.bgColor,
      textColor: context.textTheme.bodyLarge?.color,
      iconColor: context.textTheme.bodyLarge?.color,
      trailing: Icon(
        size: 20.0,
        Icons.arrow_forward_outlined,
        color: context.textTheme.bodyLarge?.color,
      ),
      visualDensity: const VisualDensity(vertical: -0.5, horizontal: -0.5),
    );
  }
}
