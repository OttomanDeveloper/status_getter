part of 'whatsapp_bloc.dart';

@immutable
final class WhatsappState {
  final bool? isLoading;
  final bool? appNotInstalled;
  final bool? permissionDenied;
  final List<StatusItemModel>? status;

  const WhatsappState({
    this.status,
    this.isLoading,
    this.appNotInstalled,
    this.permissionDenied,
  });
}
