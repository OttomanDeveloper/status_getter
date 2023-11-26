part of 'business_whats_app_bloc.dart';

@immutable
sealed class BusinessWhatsAppState {}

final class BusinessWhatsAppLoading extends BusinessWhatsAppState {}

final class BusinessWhatsAppNotInstalled extends BusinessWhatsAppState {}

final class BusinessWhatsAppStatusNotAvailable extends BusinessWhatsAppState {}

final class BusinessWhatsAppStatusAvailable extends BusinessWhatsAppState {
  final List<FileSystemEntity> status;

  BusinessWhatsAppStatusAvailable({
    required this.status,
  });
}

final class BusinessWhatsAppPermissionDenied extends BusinessWhatsAppState {}
