part of 'business_whats_app_bloc.dart';

@immutable
final class BusinessWhatsAppState {
  final bool? isLoading;
  final bool? appNotInstalled;
  final bool? permissionDenied;
  final List<StatusItemModel>? status;

  const BusinessWhatsAppState({
    this.status,
    this.isLoading,
    this.appNotInstalled,
    this.permissionDenied,
  });
}
