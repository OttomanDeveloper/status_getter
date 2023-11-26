part of 'whatsapp_bloc.dart';

@immutable
sealed class WhatsappEvent {}

class WhatsappEventFetch extends WhatsappEvent {}

class WhatsappEventAskPermission extends WhatsappEvent {}
