// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/content_management/providers/profile_content_provider.dart';
import 'package:stargate/models/profile.dart';
import 'package:stargate/providers/user_info_provider.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/screens/profile/change_password.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:stargate/widgets/inputfields/outlined_dropdown.dart';
import 'package:stargate/widgets/inputfields/textfield.dart';
import 'package:stargate/widgets/loader/loader.dart';
import 'package:stargate/widgets/local_pdf_viewer.dart';
import 'package:path/path.dart' as p;
import 'package:stargate/widgets/screen/screen.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({
    super.key,
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
  bool loading = false;

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
          message: "File already selected",
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
    setState(() {
      loading = true;
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
      showToast(message: save, context: context);
      setState(() {
        loading = false;
      });
      Navigator.pop(context, 'success');
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
      MaterialPageRoute(builder: (context) => ChangePassword()),
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
          )
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          leading: const CustomBackButton(),
        ),
        body: Padding(
          padding: EdgeInsets.only(right: 12.w, left: 12.w, top: 12.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            "change profile",
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
                    )
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
                      const Text(
                        "change password",
                        style: AppStyles.greyText,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 6.w),
                CustomTextField(
                  controller: name,
                  label: "Name",
                  hintText: "Name",
                  inputType: TextInputType.text,
                  verticalSpacing: 3.w,
                  horizontalSpacing: 0,
                ),
                SizedBox(
                  height: 3.w,
                ),
                CustomTextField(
                  controller: address,
                  label: "Address",
                  hintText: "Address",
                  inputType: TextInputType.text,
                  verticalSpacing: 3.w,
                  horizontalSpacing: 0,
                ),
                CountryPickerField(
                  country: country,
                  city: city,
                  state: state,
                ),
                SizedBox(
                  height: 12.w,
                ),
                supportiveText(
                    AppIcons.profession,
                    profileContentProvider
                        .profileContent!.occupationSelectionTagLine,
                    'svg'),
                DropdownButton2Example(
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
                    }
                  },
                  initial: servicesList[0],
                  label: 'Profession',
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
                SizedBox(
                  height: 4.w,
                ),
                // ListView.builder(
                //     itemCount: services.length - 1,
                //     itemBuilder: (context, index) {
                //       return serviceDetails(services[index].details, index);
                //     }),
                ...services.asMap().entries.map((entry) {
                  int index = entry.key;
                  Service item = entry.value;
                  return serviceDetails(item.details, index);
                }),
                SizedBox(height: 6.w),
                const Text(
                  "(optional)",
                  style: AppStyles.supportiveText,
                ),
                SizedBox(
                  height: 4.w,
                ),
                CustomTextField(
                  controller: websiteLink,
                  label: "Website link",
                  hintText: "Website link",
                  inputType: TextInputType.text,
                  horizontalSpacing: 0,
                  verticalSpacing: 0,
                ),
                SizedBox(
                  height: 12.w,
                ),
                Text(
                  profileContentProvider.profileContent!.referencesTagLine,
                  style: AppStyles.heading4,
                ),
                SizedBox(
                  height: 8.w,
                ),
                SizedBox(
                  height: 6.w,
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
                                      builder: (context) => MyPdfViewer(
                                          pdfPath: references[index]),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Text(
                                          style: AppStyles.heading4,
                                          referencesNames[index],
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
                // pdfPath != null
                //     ? PdfPickerAndViewer(pdfPath: pdfPath!)
                //     : SizedBox(),
                SizedBox(height: 12.w),
                GestureDetector(
                  onTap: () {
                    saveData();
                  },
                  child: const CustomButton(
                    text: "Save",
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
        supportiveText(AppIcons.medal,
            "provide ${profession['name']} specialization", 'image'),
        CustomTextField(
          controller: specialization[index],
          label: "${profession['specialization']} specialization",
          hintText: "Specify Specialization",
          inputType: TextInputType.text,
          horizontalSpacing: 0,
          verticalSpacing: 3,
          onChanged: (value) {
            profession['specialization'] = value; // Update the model
          },
        ),
        SizedBox(height: 3.w),
        profession['name'].toLowerCase() != 'investor'
            ? Column(
                children: [
                  CustomTextField(
                    controller: experience[index],
                    label: "Experience",
                    hintText: "Enter Experience years",
                    inputType: TextInputType.number,
                    horizontalSpacing: 0,
                    verticalSpacing: 3,
                    onChanged: (value) {
                      profession['yearsOfExperience'] =
                          int.tryParse(value) ?? 0; // Update the model
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
                      Text(
                        profileContentProvider
                            .profileContent!.investmentTagLine,
                        style: AppStyles.heading4,
                      ),
                      SizedBox(height: 8.w),
                    ],
                  ),
                  invesmentRange(
                      profession), // Pass the profession map to the investment range widget
                  SizedBox(height: 8.w),
                  Row(
                    children: [
                      const Icon(Icons.category_outlined,
                          color: AppColors.blue),
                      SizedBox(width: 12.w),
                      Text(
                        profileContentProvider
                            .profileContent!.investmentCategoryTagLine,
                        style: AppStyles.heading4,
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
                    label: "Category",
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
              label: 'start value',
              hintText: 'start value',
              inputType: TextInputType.number,
              horizontalSpacing: 0,
              verticalSpacing: 3,
              prefixSvgPath: AppIcons.euro,
              onChanged: (value) {
                investment1.text = (value) ?? 0;
                profession['investmentRange']['min'] =
                    int.tryParse(investment1.text);
              },
            ),
          ),
          SizedBox(width: 6.w),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: CustomTextField(
              controller: investment2,
              label: 'end value',
              hintText: 'end value',
              inputType: TextInputType.number,
              horizontalSpacing: 0,
              verticalSpacing: 3,
              prefixSvgPath: AppIcons.euro,
              onChanged: (value) {
                investment2.text = value ?? 0;
                profession['investmentRange']['max'] =
                    int.tryParse(investment2.text);
              },
            ),
          ),
        ],
      ),
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
          Text(
            text,
            style: AppStyles.heading4,
          ),
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
          Text(
            newSelection,
            style: AppStyles.normalText,
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
