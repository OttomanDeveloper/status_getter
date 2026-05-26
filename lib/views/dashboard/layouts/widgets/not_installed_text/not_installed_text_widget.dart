import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';

class NotInstalledTextWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  const NotInstalledTextWidget({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = context.sizeApi;
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.colorScheme.surfaceContainerHighest,
            ),
            child: Icon(
              icon,
              size: 40.0,
              color: context.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            text,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
