part of 'ad_manager_cubit.dart';

@immutable
sealed class AdManagerState {}

final class AdManagerInitial extends AdManagerState {}

final class AdManagerGoogle extends AdManagerState {
  final String banner;
  final String native;
  final String interstitial;

  AdManagerGoogle({
    required this.banner,
    required this.native,
    required this.interstitial,
  });
}
