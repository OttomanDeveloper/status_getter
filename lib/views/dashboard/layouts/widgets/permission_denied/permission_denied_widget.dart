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
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Storage permission denied. Please grant storage permission to proceed.",
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14.0),
          ElevatedButton.icon(
            onPressed: onTap,
            label: const Text("Allow Permission"),
            icon: const Icon(Icons.folder_outlined),
            style: ButtonStyle(
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
          ),
        ],
      ),
    );
  }
}
