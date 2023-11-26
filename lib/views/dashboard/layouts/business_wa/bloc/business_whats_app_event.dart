part of 'business_whats_app_bloc.dart';

@immutable
sealed class BusinessWhatsAppEvent {}

class BusinessWhatsAppEventFetch extends BusinessWhatsAppEvent {}

class BusinessWhatsAppEventAskPermission extends BusinessWhatsAppEvent {}
