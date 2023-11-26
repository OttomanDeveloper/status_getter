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
  /// Hold Social Video Text URL's
  final TextEditingController _urlController = TextEditingController();

  /// Hold Social Video Text FocusNode
  final FocusNode _urlFocusNode = FocusNode();

  /// FormState Key is used to perform Input Validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Create an Instance of `TiktokDownloadBloc`
  late final TiktokDownloadBloc _tiktokDownloadBloc =
      getItInstance.get<TiktokDownloadBloc>();

  /// When user click on this button then validate url after that make request to download the video
  void _makeRequest() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_urlFocusNode.hasFocus) {
        _urlFocusNode.unfocus();
      }
      // Now we have a valid url. So we can send request to server.
      return _tiktokDownloadBloc.add(
        TiktokDownloadEventFetch(url: _urlController.text.trim()),
      );
    }
    return;
  }

  @override
  void dispose() {
    _urlFocusNode.dispose();
    _urlController.dispose();
    super.dispose();
  }

  /// Create an Instance of `Size`
  late final Size size = context.sizeApi;

  /// Hold view Padding.
  late final EdgeInsets viewPadding = EdgeInsets.symmetric(
    horizontal: size.width * 0.05,
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16.0),
            Padding(
              padding: viewPadding,
              child: Text(
                "All Video Saver",
                textAlign: TextAlign.center,
                style: context.textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: viewPadding,
              child: Text(
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge,
                "Save as many videos as you need without any limits, restrictions, or watermarks. Choose from multiple qualities and formats.",
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: viewPadding,
              child: Form(
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
                  decoration: InputDecoration(
                    hintText: "Please enter a URL",
                    hintStyle: context.textTheme.bodyMedium,
                    prefixIcon: const Icon(Icons.link_outlined),
                    prefixIconColor: context.theme.colorScheme.primary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: viewPadding,
              child: BlocBuilder<TiktokDownloadBloc, TiktokDownloadState>(
                bloc: _tiktokDownloadBloc,
                builder: (BuildContext context, TiktokDownloadState state) {
                  // Contain Button Size
                  final Size buttonSize = Size(size.width, 60);
                  // Check if the state is loading then show a loading indicator. Otherwise show button.
                  if (state is TiktokDownloadLoading) {
                    return Container(
                      width: buttonSize.width,
                      height: buttonSize.height,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(buttonSize.height * 0.1),
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  }
                  return ElevatedButton.icon(
                    onPressed: _makeRequest,
                    label: const Text("Save Video"),
                    icon: const Icon(Icons.download_outlined),
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(buttonSize),
                      backgroundColor: MaterialStatePropertyAll(
                        context.theme.colorScheme.primary,
                      ),
                      surfaceTintColor: MaterialStatePropertyAll(
                        context.theme.colorScheme.primary,
                      ),
                      foregroundColor: const MaterialStatePropertyAll(
                        AppColors.kWhite,
                      ),
                      iconColor: const MaterialStatePropertyAll(
                        AppColors.kWhite,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0),
            const BannerAdWidget(),
            const SizedBox(height: 10.0),
            Padding(
              padding: viewPadding,
              child: BlocBuilder<TiktokDownloadBloc, TiktokDownloadState>(
                bloc: _tiktokDownloadBloc,
                builder: (BuildContext context, TiktokDownloadState state) {
                  // If the state is initial or loading then show nothing.
                  if (state is TiktokDownloadInitial ||
                      state is TiktokDownloadLoading) {
                    return const SizedBox.shrink();
                  }
                  // If the state is loaded and result links are not empty then show the list view.
                  if (state is TiktokDownloadLoaded &&
                      state.result.links.isNotEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List<Widget>.generate(
                        state.result.links.nullSafe.length,
                        (int index) {
                          return DownloadItemCard(
                            title: state.result.title,
                            duration: state.result.duration,
                            thumbnail: state.result.thumbnail,
                            links: state.result.links.nullSafe[index],
                          );
                        },
                      ),
                    );
                  }
                  // Show no data found.
                  return Text(
                    "Oops, no data found.",
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
