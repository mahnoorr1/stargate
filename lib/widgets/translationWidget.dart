import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/services/helper_methods.dart';

import '../localization/locale_notifier.dart';

Future<String> translatedText(String text, BuildContext context) async {
  final localeNotifier = Provider.of<LocaleNotifier>(context);
  final locale = localeNotifier.locale;
  String translatedText = await translateData(text, locale.languageCode);
  return translatedText;
}

translationWidget(
  String text,
  BuildContext context,
  String? fallbackText,
  TextStyle style,
) {
  return FutureBuilder<String>(
    future: translatedText(text, context),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Text(
          fallbackText ?? '',
          style: AppStyles.heading4,
        );
      } else if (snapshot.hasData) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            snapshot.data!,
            style: style,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        );
      } else {
        return Text(
          fallbackText ?? '',
          style: AppStyles.heading4,
        );
      }
    },
  );
}
