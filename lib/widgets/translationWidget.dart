import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/services/helper_methods.dart';

import '../localization/locale_notifier.dart';

// Cache translations
final Map<String, String> _translationCache = {};

Future<String> translatedText(String text, BuildContext context) async {
  final localeNotifier = Provider.of<LocaleNotifier>(context, listen: false);
  final locale = localeNotifier.locale.languageCode;
  final cacheKey = "$text-$locale";

  if (_translationCache.containsKey(cacheKey)) {
    return _translationCache[cacheKey]!;
  }

  String translated = await translateData(text, locale);
  _translationCache[cacheKey] = translated; // Store in cache
  return translated;
}

Widget translationWidget(
  String text,
  BuildContext context,
  String? fallbackText,
  TextStyle style,
) {
  return FutureBuilder<String>(
    future: translatedText(text, context), // Now uses cache
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      } else if (snapshot.hasError || !snapshot.hasData) {
        return Text(
          fallbackText ?? '',
          style: style,
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              snapshot.data!,
              style: style,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        );
      }
    },
  );
}
