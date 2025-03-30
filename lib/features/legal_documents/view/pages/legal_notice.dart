import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/drawer/widgets/widgets.dart';
import 'package:stargate/features/legal_documents/providers/legal_document_provider.dart';
import 'package:stargate/localization/locale_notifier.dart';
import 'package:stargate/localization/localization.dart';
import 'package:stargate/localization/translation_strings.dart';
import 'package:stargate/services/helper_methods.dart';

import '../../../../config/core.dart';
import '../../../../widgets/loader/loader.dart';
import '../widgets/legal_document_main_widget.dart';

class LegalNoticeScreen extends StatefulWidget {
  const LegalNoticeScreen({super.key});

  @override
  State<LegalNoticeScreen> createState() => _LegalNoticeScreenState();
}

class _LegalNoticeScreenState extends State<LegalNoticeScreen> {
  @override
  void initState() {
    Provider.of<LegalDocumentProvider>(context, listen: false)
        .getLegalDocument(type: "legal");

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final legalDocProvider = Provider.of<LegalDocumentProvider>(context);
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final locale = localeNotifier.locale;
    final targetLang = locale.languageCode;
    final translationStrings = Future.wait([
      translateData(legalDocProvider.legalDocument!.content, targetLang),
    ]);
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const CustomAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(
                  heading: AppLocalization.of(context)!
                      .translate(TranslationString.legalNotice)),
              targetLang == 'en'
                  ? Consumer<LegalDocumentProvider>(
                      builder: (context, provider, child) {
                        if (provider.isLoading) {
                          return const Expanded(child: Center(child: Loader()));
                        } else if (provider.legalDocument != null) {
                          return LegalDocumentDataWidget(
                            text: provider.legalDocument!.content,
                            fileUrl: provider.legalDocument!.file,
                          );
                        } else {
                          return Center(
                              child: Text(AppLocalization.of(context)!
                                  .translate(
                                      TranslationString.somethingWentWrong)));
                        }
                      },
                    )
                  : FutureBuilder<List<String>>(
                      future: translationStrings,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.w),
                            margin: EdgeInsets.only(bottom: 12.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.w),
                              color: Colors.white,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Consumer<LegalDocumentProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return const Expanded(
                                  child: Center(child: Loader()));
                            } else if (provider.legalDocument != null) {
                              return LegalDocumentDataWidget(
                                text: snapshot.data![0],
                                fileUrl: provider.legalDocument!.file,
                              );
                            } else {
                              return Center(
                                  child: Text(AppLocalization.of(context)!
                                      .translate(TranslationString
                                          .somethingWentWrong)));
                            }
                          },
                        );
                      }),
            ],
          ),
        ));
  }
}
