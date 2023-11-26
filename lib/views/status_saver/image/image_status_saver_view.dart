import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statusgetter/core/ad_flow/ad_manager/ad_manager.dart';
import 'package:statusgetter/core/ad_flow/widgets/banner_ad/banner_ad_widget.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/object/object_extension_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';
import 'package:statusgetter/views/widgets/scaffold/scaffold_widgets.dart';

class ImageStatusSaverView extends StatefulWidget {
  final String path;
  const ImageStatusSaverView({super.key, required this.path});

  @override
  State<ImageStatusSaverView> createState() => _ImageStatusSaverViewState();
}

class _ImageStatusSaverViewState extends State<ImageStatusSaverView> {
  /// Create an Instance of `Size`
  late final Size size = context.sizeApi;

  /// Create a List of Floating Action Buttons
  final List<Widget> floatingButtons = const <Widget>[
    Icon(Icons.download),
    Icon(Icons.share),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBody: true,
      useSafeArea: false,
      isScrollable: false,
      uiOverlay: AppThemes()
          .normalGB(context)
          .copyWith(statusBarColor: AppColors.noColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List<Widget>.generate(
          floatingButtons.length,
          (int index) {
            return FloatingActionButton(
              heroTag: "$index",
              clipBehavior: Clip.antiAliasWithSaveLayer,
              onPressed: () async {
                switch (index) {
                  case 0:
                    "download image".print();
                    ImageGallerySaver.saveFile(widget.path).then<void>((_) {
                      AdManagerFunctions.instance.loadInterstitialAD();
                      "Status Saved".showSnackbar(context);
                    });
                    break;
                  case 1:
                    "Share".print();
                    Share.shareXFiles([XFile(widget.path)]);
                    break;
                }
              },
              child: floatingButtons.elementAt(index),
            );
          },
        ),
      ),
      children: <Widget>[
        Expanded(
          child: Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: FileImage(File(widget.path)),
              ),
            ),
          ),
        ),
        const BannerAdWidget(),
      ],
    );
  }
}
