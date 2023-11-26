import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/initial/cubit/theme_cubit.dart';

class ThemeModeSwitch extends StatelessWidget {
  const ThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final Color bgC = context.bgColor;
    final Color? labelC = context.textTheme.bodyMedium?.color;
    return SizedBox(
      height: 38.0,
      width: 90.0,
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        bloc: getItInstance.get<ThemeCubit>(),
        builder: (BuildContext context, ThemeMode state) {
          return FlutterSwitch(
            width: 90.0,
            height: 38.0,
            padding: 2.0,
            toggleSize: 33.0,
            borderRadius: 28.0,
            activeToggleColor: bgC,
            inactiveToggleColor: bgC,
            value: state == ThemeMode.dark,
            activeSwitchBorder: const Border(),
            inactiveSwitchBorder: const Border(),
            activeColor: (labelC ?? bgC).withOpacity(0.25),
            inactiveColor: (labelC ?? bgC).withOpacity(0.25),
            activeIcon: Icon(color: labelC, Icons.dark_mode),
            inactiveIcon: Icon(
              Icons.light_mode,
              color: Colors.yellow.shade600,
            ),
            onToggle: (bool newValue) {
              return getItInstance
                  .get<ThemeCubit>()
                  .toggleTheme(newValue ? ThemeMode.dark : ThemeMode.light);
            },
          );
        },
      ),
    );
  }
}
