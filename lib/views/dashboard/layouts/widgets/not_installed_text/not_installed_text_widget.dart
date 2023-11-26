import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';

class NotInstalledTextWidget extends StatelessWidget {
  final String text;
  const NotInstalledTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final Size size = context.sizeApi;
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.textTheme.bodyLarge,
      ),
    );
  }
}
