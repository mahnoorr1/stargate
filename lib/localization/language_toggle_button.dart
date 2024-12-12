import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/core.dart';
import 'locale_notifier.dart';

class LanguageToggleButton extends StatelessWidget {
  final bool isHorizontal;
  const LanguageToggleButton({
    super.key,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final locale = localeNotifier.locale;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: !isHorizontal
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // English Button
                _buildLanguageButton(
                  context: context,
                  localeNotifier: localeNotifier,
                  languageCode: 'en',
                  isSelected: locale.languageCode == 'en',
                  label: 'English',
                ),
                const SizedBox(height: 10),
                // Spanish Button
                _buildLanguageButton(
                  context: context,
                  localeNotifier: localeNotifier,
                  languageCode: 'es',
                  isSelected: locale.languageCode == 'es',
                  label: 'Español',
                ),
                const SizedBox(height: 10),
                // German Button
                _buildLanguageButton(
                  context: context,
                  localeNotifier: localeNotifier,
                  languageCode: 'de',
                  isSelected: locale.languageCode == 'de',
                  label: 'Deutsch',
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // English Button
                _buildLanguageButton(
                  context: context,
                  localeNotifier: localeNotifier,
                  languageCode: 'en',
                  isSelected: locale.languageCode == 'en',
                  label: 'English',
                ),
                const SizedBox(width: 2),
                // Spanish Button
                _buildLanguageButton(
                  context: context,
                  localeNotifier: localeNotifier,
                  languageCode: 'es',
                  isSelected: locale.languageCode == 'es',
                  label: 'Español',
                ),
                const SizedBox(width: 2),
                // German Button
                _buildLanguageButton(
                  context: context,
                  localeNotifier: localeNotifier,
                  languageCode: 'de',
                  isSelected: locale.languageCode == 'de',
                  label: 'Deutsch',
                ),
              ],
            ),
    );
  }

  Widget _buildLanguageButton({
    required BuildContext context,
    required LocaleNotifier localeNotifier,
    required String languageCode,
    required bool isSelected,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        localeNotifier.setLocale(Locale(languageCode));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
