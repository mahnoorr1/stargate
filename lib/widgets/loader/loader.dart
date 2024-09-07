import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  final bool loading;
  const FullScreenLoader({
    super.key,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!loading) {
      return const SizedBox();
    }
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
