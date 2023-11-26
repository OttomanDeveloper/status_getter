import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/core/router/router_core.dart';
import 'package:statusgetter/meta/settings/settings_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/initial/cubit/theme_cubit.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    final RouterNavigator navigator = RouterNavigator();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        bloc: getItInstance.get<ThemeCubit>(),
        builder: (BuildContext context, ThemeMode state) {
          return MaterialApp.router(
            themeMode: state,
            title: AppSettings.appName,
            theme: AppThemes().lightMode(),
            darkTheme: AppThemes().darkMode(),
            debugShowCheckedModeBanner: false,
            routerDelegate: navigator.router.routerDelegate,
            routeInformationParser: navigator.router.routeInformationParser,
            routeInformationProvider: navigator.router.routeInformationProvider,
          );
        },
      ),
    );
  }
}
