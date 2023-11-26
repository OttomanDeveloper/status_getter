part of 'tiktok_download_bloc.dart';

@immutable
sealed class TiktokDownloadState {}

/// When user request is pending then this state will be emitted.
final class TiktokDownloadInitial extends TiktokDownloadState {}

/// When user request is pending then this state will be emitted.
final class TiktokDownloadLoading extends TiktokDownloadState {}

/// When user request return result then this state will be emitted.
final class TiktokDownloadLoaded extends TiktokDownloadState {
  final SiteModel result;
  TiktokDownloadLoaded({required this.result});
}

/// When user request return no response then this state will be emitted.
final class TiktokDownloadNoResult extends TiktokDownloadState {}
