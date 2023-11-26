import 'package:flutter/material.dart';
import 'package:statusgetter/core/domain/model/site_model.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';
import 'package:statusgetter/core/functions/get_it/get_it_functions_core.dart';
import 'package:statusgetter/views/dashboard/layouts/tiktok_download/bloc/tiktok_download_bloc.dart';

class DownloadItemCard extends StatelessWidget {
  final String? title;
  final LinkModel links;
  final String? duration;
  final String? thumbnail;

  const DownloadItemCard({
    super.key,
    this.title,
    this.duration,
    this.thumbnail,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = context.sizeApi;
    return Container(
      width: size.width,
      height: size.height * 0.17,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 4.0,
            spreadRadius: 2.0,
            offset: const Offset(0.5, 1.0),
            color: context.textTheme.bodySmall!.color!.withOpacity(0.15),
          ),
        ],
      ),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Row(
                children: <Widget>[
                  if (thumbnail.isNotEmpty) ...[
                    Image.network(
                      fit: BoxFit.fill,
                      thumbnail.nullSafe,
                      height: size.height,
                      width: size.width * 0.28,
                    ),
                    const SizedBox(width: 6.0),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (title.isNotEmpty) ...[
                          Text(
                            maxLines: 2,
                            title.nullSafe,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                        ],
                        if (duration.isNotEmpty) ...[
                          Text(
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                            "Duration: ${duration.nullSafe}",
                          ),
                          const SizedBox(height: 4.0),
                        ],
                        if (links.quality.isNotEmpty) ...[
                          Text(
                            maxLines: 1,
                            "Quality: ${links.quality}",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4.0),
                        ],
                        if (links.type.isNotEmpty) ...[
                          Text(
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            "Type: ${links.type.nullSafe}",
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: constraints.maxWidth * 0.01,
              bottom: constraints.maxHeight * 0.03,
              child: IconButton.filled(
                onPressed: () {
                  return getItInstance
                      .get<TiktokDownloadBloc>()
                      .add(TiktokDownloadEventDownloadFile(
                        context: context,
                        title: title.nullSafe,
                        url: links.link.nullSafe,
                      ));
                },
                icon: const Icon(Icons.download_outlined),
              ),
            ),
          ],
        );
      }),
    );
  }
}
