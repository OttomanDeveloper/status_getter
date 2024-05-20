import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/dashboard/cubit/dashboard_cubit.dart';

class DashboardBottomNav extends StatelessWidget {
  final List<NavigationDestination> destinations;
  const DashboardBottomNav({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    final double? fontSize = context.textTheme.labelLarge?.fontSize;
    return Theme(
      data: context.theme.copyWith(
        navigationBarTheme: context.theme.navigationBarTheme.copyWith(
          iconTheme: const WidgetStatePropertyAll(
            IconThemeData(size: 24.0),
          ),
          elevation: 4.0,
          backgroundColor: context.bgColor,
          surfaceTintColor: context.bgColor,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          labelTextStyle: WidgetStatePropertyAll(
            context.textTheme.bodyLarge?.copyWith(fontSize: fontSize),
          ),
        ),
      ),
      child: BlocBuilder<DashboardCubit, int>(
        bloc: getItInstance.get<DashboardCubit>(),
        builder: (BuildContext context, int state) {
          return NavigationBar(
            selectedIndex: state,
            destinations: destinations,
            onDestinationSelected: (int i) {
              return getItInstance
                  .get<DashboardCubit>()
                  .updateBottomNavIndex(i, movePage: true);
            },
          );
        },
      ),
    );
  }
}
