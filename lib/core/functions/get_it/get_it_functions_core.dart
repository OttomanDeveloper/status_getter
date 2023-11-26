import 'package:get_it/get_it.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_manager/ad_manager_cubit.dart';
import 'package:statusgetter/core/ad_flow/cubit/ad_server/ad_server_cubit.dart';
import 'package:statusgetter/core/domain/repo/social_repo_domain_core.dart';
import 'package:statusgetter/views/dashboard/cubit/dashboard_cubit.dart';
import 'package:statusgetter/views/dashboard/layouts/business_wa/bloc/business_whats_app_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/tiktok_download/bloc/tiktok_download_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/whatsapp/bloc/whatsapp_bloc.dart';
import 'package:statusgetter/views/initial/cubit/theme_cubit.dart';

/// Create an Instance of `GetIt`
final GetIt getItInstance = GetIt.I;

/// Initialize Instances using `GetIt`
Future<void> initializeGetIt() {
  // Initialize `Bloc and Cubit` Instances
  getItInstance.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  getItInstance.registerLazySingleton<AdServerCubit>(() => AdServerCubit());
  getItInstance.registerLazySingleton<DashboardCubit>(() => DashboardCubit());
  getItInstance.registerLazySingleton<AdManagerCubit>(() => AdManagerCubit());
  getItInstance.registerLazySingleton<TiktokDownloadBloc>(
    () => TiktokDownloadBloc(const SocialDownloadRepo()),
  );
  getItInstance.registerLazySingleton<WhatsappBloc>(() => WhatsappBloc());
  getItInstance.registerLazySingleton<BusinessWhatsAppBloc>(
    () => BusinessWhatsAppBloc(),
  );
  return Future<void>.value();
}
