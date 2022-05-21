import 'package:flutter/material.dart';

Future<void> customDialog(BuildContext context, {Widget? child}) async {
  await showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) {
      return child ?? const SizedBox();
    },
  );
}
