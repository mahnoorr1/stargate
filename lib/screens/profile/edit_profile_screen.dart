// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/features/content_management/providers/profile_content_provider.dart';
import 'package:stargate/models/profile.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/screens/profile/change_password.dart';
import 'package:stargate/screens/profile/request_email_change.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/dialog_box.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:stargate/widgets/inputfields/outlined_dropdown.dart';
import 'package:stargate/widgets/inputfields/services_dropdown.dart';
import 'package:stargate/widgets/inputfields/textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:path/path.dart' as p;
import 'package:stargate/widgets/pdf_viewer.dart';
import 'package:stargate/widgets/screen/screen.dart';
import 'package:stargate/widgets/translationWidget.dart';

import '../../localization/localization.dart';
import '../../localization/translation_strings.dart';
import '../../services/helper_methods.dart';

class EditProfile extends StatefulWidget {
  bool? backButton = true;
  final User user;
  EditProfile({
    super.key,
    this.backButton = true,
    required this.user,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController websiteLink = TextEditingController();

  TextEditingController investment1 = TextEditingController();
  TextEditingController investment2 = TextEditingController();
  List<TextEditingController> specialization = [];
  List<TextEditingController> experience = [];

  List<String> prefferedInvestmentCategorires = [];
  List<String> selectedProfessions = [];
  List<String> selectedExperiences = [];
  List<String> selectedSpecializations = [];
  List<Service> services = [];
  List<dynamic> references = [];
  List<String> referencesNames = [];
  double investmentValue1 = 0;
  double investmentValue2 = 0;
  String? image = '';
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool emptyCountryCityState = false;

  String? pdfPath;
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    log("result: ${result?.files.first.name}");

    if (result != null && result.files.isNotEmpty) {
      if (referencesNames.any((value) => value == result.files.first.name)) {
        showToast(
          message: AppLocalization.of(context)!
              .translate(TranslationString.fileAlreadySelected),
          context: context,
          isAlert: true,
          color: Colors.redAccent,
        );
        return;
      } else {
        setState(() {
          String pdfName = result.files.first.name;
          references.add(result.files.single.path!);
          referencesNames.add(pdfName);
        });
      }
    }
  }

  Future<String> _pickFile(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    }
    return '';
  }

  void saveData() async {
    if (!_formKey.currentState!.validate() ||
        selectedProfessions.isEmpty ||
        referencesNames.isEmpty ||
        country.text.isEmpty) {
      setState(() {
        emptyCountryCityState = true;
      });
      return;
    }
    setState(() {
      loading = true;
      emptyCountryCityState = false;
    });
    String save = await UserProfileProvider.c(context).updateUserProfile(
      name: name.text,
      address: address.text,
      city: city.text,
      country: country.text,
      professions: services,
      references: references,
      websiteLink: websiteLink.text,
      profileImage: image!.contains('https') ? null : image,
    );

    if (save == 'Success') {
      if (widget.backButton == false) {
        showCustomDialog(
          context: context,
          circleBackgroundColor: const Color.fromRGBO(0, 0, 0, 0),
          titleText: AppLocalization.of(context)!
              .translate(TranslationString.informationUpdated),
          titleColor: AppColors.black,
          descriptionText: AppLocalization.of(context)!
              .translate(TranslationString.dataValidationFromAdminDescription),
          buttonText:
              AppLocalization.of(context)!.translate(TranslationString.ok),
          onButtonPressed: () {
            Navigator.pop(context);
          },
        );
      }
      showToast(
          message:
              AppLocalization.of(context)!.translate(TranslationString.success),
          context: context);
      setState(() {
        loading = false;
      });
      if (widget.backButton != false) {
        Navigator.pop(context, 'success');
      }
    } else {
      showToast(message: save, context: context, isAlert: true);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.user.name;
    country.text = widget.user.country ?? '';
    city.text = widget.user.city ?? '';
    address.text = widget.user.address ?? '';
    websiteLink.text = widget.user.websiteLink ?? '';
    services = widget.user.services.toList();
    selectedProfessions = widget.user.services
        .map((service) => service.details['name'] as String)
        .toList();
    selectedSpecializations = widget.user.services
        .map((service) => service.details['specialization'] as String)
        .toList();
    selectedExperiences = widget.user.services
        .map((service) => service.details['name'].toLowerCase() == 'investor'
            ? '0'
            : service.details['experience'].toString())
        .toList();
    references = widget.user.references ?? [];

    experience = List.generate(
      selectedExperiences.length,
      (index) => TextEditingController(text: selectedExperiences[index]),
    );
    specialization = List.generate(
      selectedSpecializations.length,
      (index) => TextEditingController(text: selectedSpecializations[index]),
    );

    var investorService = widget.user.services.firstWhere(
      (service) => service.details['name'].toLowerCase() == 'investor',
      orElse: () => Service(details: {}),
    );
    prefferedInvestmentCategorires = investorService.details.isNotEmpty
        ? List<String>.from(
            investorService.details['preferredInvestmentCategories'] ?? [])
        : [];
    investment1.text = investorService.details.isNotEmpty
        ? investorService.details['investmentRange']['min'].toString()
        : 0.toString();
    investment2.text = investorService.details.isNotEmpty
        ? investorService.details['investmentRange']['max'].toString()
        : 0.toString();
    for (int i = 0; i <= references.length - 1; i++) {
      referencesNames.add(p.basename(references[i]));
    }
    image = widget.user.image ?? '';
  }

  void changeProfile() async {
    String imageFile = await _pickFile(context);
    setState(() {
      image = imageFile;
    });
    setState(() {});
  }

  void changePass() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ChangePassword()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileContentProvider =
        Provider.of<ProfileContentProvider>(context, listen: false);
    MediaQuery.of(context).viewInsets.bottom;

    return Screen(
      overlayWidgets: [
        if (loading)
          const FullScreenLoader(
            loading: true,
          ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.backButton == false
            ? null
            : AppBar(
                surfaceTintColor: Colors.transparent,
                leading: const CustomBackButton(),
              ),
        body: Padding(
          padding: EdgeInsets.only(right: 12.w, left: 12.w, top: 12.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 36,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 6.w),
                        decoration: BoxDecoration(
                          color: UserProfileProvider.c(context).status ==
                                  'approved'
                              ? AppColors.blue
                              : UserProfileProvider.c(context).status ==
                                      'rejected'
                                  ? Colors.redAccent
                                  : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                            style: AppStyles.heading4
                                .copyWith(color: Colors.white),
                            "${AppLocalization.of(context)!.translate(TranslationString.profile)} ${AppLocalization.of(context)!.translate(UserProfileProvider.c(context).status)}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 100.w,
                        width: 100.w,
                        decoration: BoxDecoration(
                          image: image != null && image != ''
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: image!.contains('https')
                                      ? NetworkImage(image!)
                                      : FileImage(
                                          File(image!),
                                        ),
                                )
                              : null,
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(50.w),
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: changeProfile,
                            child: Text(
                              AppLocalization.of(context)!
                                  .translate(TranslationString.changeProfile),
                              style: AppStyles.heading4.copyWith(
                                color: AppColors.blue,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.w,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: AppColors.blue,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(
                        widget.user.email,
                        style: AppStyles.greyText,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EmailChangeScreen()));
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 20,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                  GestureDetector(
                    onTap: changePass,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: SvgPicture.asset(
                            AppIcons.lock,
                            color: AppColors.blue,
                            width: 18,
                          ),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.changePass),
                          style: AppStyles.greyText,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 6.w),
                  CustomTextField(
                    controller: name,
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.name),
                    hintText: AppLocalization.of(context)!
                        .translate(TranslationString.name),
                    inputType: TextInputType.text,
                    verticalSpacing: 3.w,
                    horizontalSpacing: 0,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalization.of(context)!.translate(
                            TranslationString.enterNameError); // Error message
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 3.w,
                  ),
                  CustomTextField(
                    controller: address,
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.address),
                    hintText: AppLocalization.of(context)!
                        .translate(TranslationString.address),
                    inputType: TextInputType.text,
                    verticalSpacing: 3.w,
                    horizontalSpacing: 0,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalization.of(context)!.translate(
                            TranslationString
                                .enterAddressError); // Error message
                      }
                      return null;
                    },
                  ),
                  CountryPickerField(
                    initalCountry: widget.user.country,
                    initialCity: widget.user.city,
                    country: country,
                    city: city,
                    state: state,
                  ),
                  emptyCountryCityState
                      ? Text(
                          AppLocalization.of(context)!
                              .translate(TranslationString.selectCountryError),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                          ))
                      : const SizedBox(),
                  SizedBox(
                    height: 12.w,
                  ),
                  supportiveText(
                      AppIcons.profession,
                      profileContentProvider
                          .profileContent!.occupationSelectionTagLine,
                      'svg'),
                  ServicesDropdown(
                    list: servicesList,
                    onSelected: (value) {
                      if (selectedProfessions.contains(value)) {
                      } else {
                        selectedProfessions.add(value);
                        if (value.toLowerCase() != 'investor') {
                          Service newService = Service(details: {
                            "name": value,
                            "specialization": "",
                            "yearsOfExperience": 0,
                          });
                          services.add(newService);
                        } else {
                          Service newService = Service(details: {
                            "name": value,
                            "specialization": "",
                            "investmentRange": {
                              "min": 0,
                              "max": 0,
                            },
                            "preferredInvestmentCategories": [],
                          });
                          services.add(newService);
                          experience.add(TextEditingController());
                          specialization.add(TextEditingController());
                        }
                        setState(() {});
                        print(selectedProfessions);
                      }
                    },
                    initial: servicesList[0],
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.profession),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...selectedProfessions.map(
                          (item) => selectedBubbleOption(
                            item,
                            selectedProfessions,
                          ),
                        ),
                      ],
                    ),
                  ),
                  selectedProfessions.isEmpty
                      ? Text(
                          AppLocalization.of(context)!.translate(
                              TranslationString.selectProfessionError),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                          ))
                      : const SizedBox(),
                  SizedBox(
                    height: 4.w,
                  ),
                  ...services.asMap().entries.map((entry) {
                    int index = entry.key;
                    Service item = entry.value;
                    return serviceDetails(item.details, index);
                  }),
                  SizedBox(height: 6.w),
                  Text(
                    AppLocalization.of(context)!
                        .translate(TranslationString.optional),
                    style: AppStyles.supportiveText,
                  ),
                  SizedBox(
                    height: 4.w,
                  ),
                  CustomTextField(
                    controller: websiteLink,
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.websiteLink),
                    hintText: AppLocalization.of(context)!
                        .translate(TranslationString.websiteLink),
                    inputType: TextInputType.text,
                    horizontalSpacing: 0,
                    verticalSpacing: 0,
                  ),
                  SizedBox(
                    height: 12.w,
                  ),
                  translationWidget(
                    profileContentProvider.profileContent!.referencesTagLine,
                    context,
                    '',
                    AppStyles.heading4,
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                  GestureDetector(
                    onTap: pickPdf,
                    child: Container(
                      height: 100.w,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        border: Border.all(
                          width: 1,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.w),
                  referencesNames.isNotEmpty
                      ? SizedBox(
                          height: 200.w,
                          child: ListView.builder(
                              itemCount: referencesNames.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PDFViewerScreen(
                                            filePath: references[index]),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 65.w,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8.w),
                                    margin: EdgeInsets.only(bottom: 4.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Text(
                                            style: AppStyles.heading4,
                                            getFileName(referencesNames[index]),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              references.removeAt(index);
                                              referencesNames.removeAt(index);
                                            });
                                          },
                                          child: const Icon(
                                            Icons.close,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : const SizedBox(),
                  referencesNames.isEmpty
                      ? Text(
                          AppLocalization.of(context)!.translate(
                              TranslationString.upload1ReferenceError),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                          ))
                      : const SizedBox(),
                  SizedBox(height: 12.w),
                  GestureDetector(
                    onTap: saveData,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CustomButton(
                        text: widget.backButton == false
                            ? AppLocalization.of(context)!
                                .translate(TranslationString.update)
                            : AppLocalization.of(context)!
                                .translate(TranslationString.save),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.w,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget invesmentRange(Map<String, dynamic> profession) {
    // Investment range text fields
    investment1.text = profession['investmentRange']?['min']?.toString() ?? '';
    investment2.text = profession['investmentRange']?['max']?.toString() ?? '';

    return SizedBox(
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: CustomTextField(
              controller: investment1,
              label: AppLocalization.of(context)!
                  .translate(TranslationString.startValue),
              hintText: AppLocalization.of(context)!
                  .translate(TranslationString.startValue),
              inputType: TextInputType.number,
              horizontalSpacing: 0,
              verticalSpacing: 3,
              prefixSvgPath: AppIcons.euro,
              onChanged: (value) {
                investment1.text = (value) ?? 0;
                profession['investmentRange']['min'] =
                    int.tryParse(investment1.text);
              },
              validator: (value) {
                if (value == null || value.isEmpty || value == '0') {
                  return AppLocalization.of(context)!
                      .translate(TranslationString.enterRangeError);
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 6.w),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: CustomTextField(
              controller: investment2,
              label: AppLocalization.of(context)!
                  .translate(TranslationString.endValue),
              hintText: AppLocalization.of(context)!
                  .translate(TranslationString.endValue),
              inputType: TextInputType.number,
              horizontalSpacing: 0,
              verticalSpacing: 3,
              prefixSvgPath: AppIcons.euro,
              onChanged: (value) {
                investment2.text = value ?? 0;
                profession['investmentRange']['max'] =
                    int.tryParse(investment2.text);
              },
              validator: (value) {
                if (value == null || value.isEmpty || value == '0') {
                  return AppLocalization.of(context)!
                      .translate(TranslationString.enterMaxRangeError);
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceDetails(Map<String, dynamic> profession, int index) {
    final profileContentProvider =
        Provider.of<ProfileContentProvider>(context, listen: false);
    // Ensure the index is within bounds
    if (index >= experience.length) {
      // If not, add a new controller
      experience.add(TextEditingController());
    }
    if (index >= specialization.length) {
      // If not, add a new controller
      specialization.add(TextEditingController());
    }

    // Set the values for controllers
    experience[index].text = profession['yearsOfExperience']?.toString() ?? '0';
    specialization[index].text = profession['specialization'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.w),
        SizedBox(
          child: supportiveText(
              AppIcons.medal,
              "${AppLocalization.of(context)!.translate(TranslationString.provide)} ${profession['name']} ${AppLocalization.of(context)!.translate(TranslationString.specialization)}",
              'image'),
        ),
        CustomTextField(
          controller: specialization[index],
          label:
              "${profession['specialization']} ${AppLocalization.of(context)!.translate(TranslationString.specialization)}",
          hintText: AppLocalization.of(context)!
              .translate(TranslationString.specifySpecialization),
          inputType: TextInputType.text,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          onChanged: (value) {
            profession['specialization'] = value; // Update the model
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalization.of(context)!.translate(
                  TranslationString.enterSpecialization); // Error message
            }
            return null;
          },
        ),
        SizedBox(height: 3.w),
        profession['name'].toLowerCase() != 'investor'
            ? Column(
                children: [
                  CustomTextField(
                    controller: experience[index],
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.experience),
                    hintText: AppLocalization.of(context)!
                        .translate(TranslationString.enterExperience),
                    inputType: TextInputType.number,
                    horizontalSpacing: 0,
                    verticalSpacing: 3,
                    onChanged: (value) {
                      profession['yearsOfExperience'] =
                          int.tryParse(value) ?? 0; // Update the model
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '0') {
                        return AppLocalization.of(context)!.translate(
                            TranslationString
                                .enterValidYearsOfExperience); // Error message
                      }
                      return null;
                    },
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(AppIcons.cash, width: 32),
                      SizedBox(width: 12.w),
                      translationWidget(
                        profileContentProvider
                            .profileContent!.investmentTagLine,
                        context,
                        profileContentProvider
                            .profileContent!.investmentTagLine,
                        AppStyles.heading4,
                      ),
                      SizedBox(height: 8.w),
                    ],
                  ),
                  invesmentRange(profession),
                  SizedBox(height: 8.w),
                  Row(
                    children: [
                      const Icon(Icons.category_outlined,
                          color: AppColors.blue),
                      SizedBox(width: 12.w),
                      translationWidget(
                        profileContentProvider
                            .profileContent!.investmentCategoryTagLine,
                        context,
                        profileContentProvider
                            .profileContent!.investmentCategoryTagLine,
                        AppStyles.heading4,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.w),
                  OutlinedDropdownButtonExample(
                    list: propertyTypes,
                    onSelected: (value) {
                      if (!prefferedInvestmentCategorires.contains(value)) {
                        prefferedInvestmentCategorires.add(value);
                        setState(() {});
                      }
                    },
                    initial: propertyTypes[0],
                    label: AppLocalization.of(context)!
                        .translate(TranslationString.category),
                  ),
                  SizedBox(height: 6.w),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: prefferedInvestmentCategorires.map((item) {
                        return selectedBubbleOption(
                            item, prefferedInvestmentCategorires);
                      }).toList(),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget supportiveText(
    String icon,
    String text,
    String type,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Row(
        children: [
          type == 'image'
              ? SvgPicture.asset(
                  icon,
                )
              : SvgPicture.asset(
                  icon,
                  color: AppColors.blue,
                ),
          SizedBox(
            width: 12.w,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child:
                  translationWidget(text, context, text, AppStyles.heading4)),
        ],
      ),
    );
  }

  Widget selectedBubbleOption(String newSelection, List<String> list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
      margin: EdgeInsets.only(right: 6.w, top: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          20.w,
        ),
        color: AppColors.lightBlue,
      ),
      child: Row(
        children: [
          FutureBuilder<String>(
            future: translatedText(newSelection, context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 10,
                    height: 10,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(
                  newSelection,
                  style: AppStyles.heading4,
                );
              } else if (snapshot.hasData) {
                return Text(
                  snapshot.data!,
                  style: AppStyles.normalText,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                );
              } else {
                return Text(
                  newSelection,
                  style: AppStyles.heading4,
                );
              }
            },
          ),
          SizedBox(
            width: 8.w,
          ),
          GestureDetector(
            onTap: () {
              list.removeWhere((item) => item == newSelection);
              services
                  .removeWhere((item) => item.details['name'] == newSelection);
              setState(() {});
            },
            child: const Icon(
              Icons.close,
              color: AppColors.primaryGrey,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}
