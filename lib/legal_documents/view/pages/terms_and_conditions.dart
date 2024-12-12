import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stargate/legal_documents/providers/legal_document_provider.dart';

import '../../../config/core.dart';
import '../../../drawer/widgets/widgets.dart';
import '../../../localization/localization.dart';
import '../../../localization/translation_strings.dart';
import '../../../widgets/loader/loader.dart';
import '../widgets/legal_document_main_widget.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  void initState() {
    Provider.of<LegalDocumentProvider>(context, listen: false)
        .getLegalDocument(type: "terms");

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
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
                      .translate(TranslationString.termsAndConditions)),
              Consumer<LegalDocumentProvider>(
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
                            .translate(TranslationString.somethingWentWrong)));
                  }
                },
              ),
            ],
          ),
        ));
  }
}
