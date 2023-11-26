part of 'whatsapp_bloc.dart';

@immutable
sealed class WhatsappState {}

final class WhatsappLoading extends WhatsappState {}

final class WhatsAppNotInstalled extends WhatsappState {}

final class WhatsAppStatusNotAvailable extends WhatsappState {}

final class WhatsAppStatusAvailable extends WhatsappState {
  final List<FileSystemEntity> status;

  WhatsAppStatusAvailable({
    required this.status,
  });
}

final class WhatsAppPermissionDenied extends WhatsappState {}
