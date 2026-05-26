import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';

class PermissionDeniedWidget extends StatelessWidget {
  final VoidCallback onTap;
  const PermissionDeniedWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Size size = context.sizeApi;
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.theme.colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.folder_off_rounded,
              size: 48.0,
              color: context.theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            "Storage Access Required",
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "Grant access to the WhatsApp status folder to view and save statuses.",
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton.icon(
            onPressed: onTap,
            label: const Text("Grant Access"),
            icon: const Icon(Icons.folder_open_rounded),
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(
                Size(size.width * 0.6, 48.0),
              ),
              backgroundColor: WidgetStatePropertyAll(
                context.theme.colorScheme.primary,
              ),
              surfaceTintColor: WidgetStatePropertyAll(
                context.theme.colorScheme.primary,
              ),
              foregroundColor: const WidgetStatePropertyAll(
                AppColors.kWhite,
              ),
              iconColor: const WidgetStatePropertyAll(
                AppColors.kWhite,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
