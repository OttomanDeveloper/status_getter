import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/meta/colors/colors_meta.dart';

Future<void> snackbar(
  BuildContext context, {
  required String msg,
  required IconData icon,
  Color? bgColor,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: <Widget>[
          Icon(
            icon,
            color: AppColors.kWhite.withOpacity(0.8),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: AutoSizeText(
              msg,
              maxLines: 2,
              textAlign: TextAlign.start,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.kWhite,
                fontSize: 14.0,
              ),
            ),
          ),
          const SizedBox(width: 6.0),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      duration: const Duration(milliseconds: 1300),
      backgroundColor: bgColor ?? Theme.of(context).primaryColor,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
  // Close the functions
  return Future<void>.value();
}
