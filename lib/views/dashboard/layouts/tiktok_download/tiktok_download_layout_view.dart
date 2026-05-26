import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:statusgetter/core/ad_flow/widgets/banner_ad/banner_ad_widget.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/list/list_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/views/dashboard/layouts/tiktok_download/bloc/tiktok_download_bloc.dart';
import 'package:statusgetter/views/dashboard/layouts/widgets/download_item_card/download_item_card_widget.dart';

class TiktokDownloadLayoutView extends StatefulWidget {
  const TiktokDownloadLayoutView({super.key});

  @override
  State<TiktokDownloadLayoutView> createState() =>
      _TiktokDownloadLayoutViewState();
}

class _TiktokDownloadLayoutViewState extends State<TiktokDownloadLayoutView>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TiktokDownloadBloc _tiktokDownloadBloc =
      getItInstance.get<TiktokDownloadBloc>();

  void _makeRequest() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_urlFocusNode.hasFocus) _urlFocusNode.unfocus();
      _tiktokDownloadBloc.add(
        TiktokDownloadEventFetch(url: _urlController.text.trim()),
      );
    }
  }

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ColorScheme scheme = context.theme.colorScheme;
    final double hPad = context.width * 0.05;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20.0),

          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  scheme.primary,
                  scheme.primary.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Icon(
                    Icons.download_rounded,
                    color: AppColors.kWhite,
                    size: 24.0,
                  ),
                ),
                const SizedBox(height: 14.0),
                Text(
                  "All Video Saver",
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.kWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  "Save videos without limits, restrictions, or watermarks.",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.kWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0),

          // URL input
          Text(
            "Paste video link",
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Form(
            key: _formKey,
            child: TextFormField(
              focusNode: _urlFocusNode,
              controller: _urlController,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.url,
              style: context.textTheme.bodyMedium,
              textInputAction: TextInputAction.done,
              validator: _tiktokDownloadBloc.validateURL,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) => _makeRequest(),
              decoration: InputDecoration(
                hintText: "https://...",
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.textTheme.bodySmall?.color,
                ),
                prefixIcon: Icon(
                  Icons.link_rounded,
                  color: scheme.primary,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _urlController.clear();
                    _formKey.currentState?.reset();
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20.0,
                    color: context.textTheme.bodySmall?.color,
                  ),
                ),
                filled: true,
                fillColor: scheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(
                    color: scheme.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: scheme.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(color: scheme.error, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14.0),

          // Download button
          BlocBuilder<TiktokDownloadBloc, TiktokDownloadState>(
            bloc: _tiktokDownloadBloc,
            builder: (BuildContext context, TiktokDownloadState state) {
              final bool isLoading = state is TiktokDownloadLoading;
              return SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _makeRequest,
                  style: ButtonStyle(
                    elevation: const WidgetStatePropertyAll(0),
                    backgroundColor: WidgetStatePropertyAll(scheme.primary),
                    foregroundColor: const WidgetStatePropertyAll(
                      AppColors.kWhite,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22.0,
                          height: 22.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.kWhite,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.download_rounded, size: 20.0),
                            SizedBox(width: 8.0),
                            Text("Download"),
                          ],
                        ),
                ),
              );
            },
          ),

          const SizedBox(height: 16.0),
          const BannerAdWidget(),
          const SizedBox(height: 16.0),

          // Results
          BlocBuilder<TiktokDownloadBloc, TiktokDownloadState>(
            bloc: _tiktokDownloadBloc,
            builder: (BuildContext context, TiktokDownloadState state) {
              if (state is TiktokDownloadInitial ||
                  state is TiktokDownloadLoading) {
                return const SizedBox.shrink();
              }

              if (state is TiktokDownloadLoaded &&
                  state.result.links.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Available formats",
                          style: context.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "${state.result.links.nullSafe.length}",
                            style: context.textTheme.labelSmall?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    ...List<Widget>.generate(
                      state.result.links.nullSafe.length,
                      (int index) => DownloadItemCard(
                        title: state.result.title,
                        duration: state.result.duration,
                        thumbnail: state.result.thumbnail,
                        links: state.result.links.nullSafe[index],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.search_off_rounded,
                        size: 40.0,
                        color: context.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(height: 10.0),
                      AutoSizeText(
                        "No results found",
                        maxLines: 1,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
