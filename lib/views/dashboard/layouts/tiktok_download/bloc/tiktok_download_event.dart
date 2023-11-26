part of 'tiktok_download_bloc.dart';

@immutable
sealed class TiktokDownloadEvent {}

/// When user request to fetch details of the url. Then we will get the url from here
final class TiktokDownloadEventFetch extends TiktokDownloadEvent {
  final String url;
  TiktokDownloadEventFetch({required this.url});
}

/// When user request to download video. Then we will get validate the info from here.
final class TiktokDownloadEventDownloadFile extends TiktokDownloadEvent {
  final String url;
  final String title;
  final BuildContext context;

  TiktokDownloadEventDownloadFile({
    required this.url,
    required this.title,
    required this.context,
  });
}
