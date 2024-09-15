// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/profile.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/services/user_profiling.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/custom_toast.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:stargate/widgets/inputfields/outlined_dropdown.dart';
import 'package:stargate/widgets/inputfields/textfield.dart';

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
  double investmentValue1 = 0;
  double investmentValue2 = 0;

  void saveData() async {
    print("save");
    String save = await updateProfile(
      name: name.text,
      address: address.text,
      city: city.text,
      country: country.text,
      professions: services,
      references: [],
      websiteLink: websiteLink.text,
      profile: '',
    );
    if (save == 'Success') {
      showToast(message: save, context: context);
    } else {
      showToast(message: save, context: context, isAlert: true);
    }
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
    );
    prefferedInvestmentCategorires = List<String>.from(
      investorService.details['preferredInvestmentCategories'] ?? [],
    );
    investment1.text =
        investorService.details['investmentRange']['min'].toString();
    investment2.text =
        investorService.details['investmentRange']['max'].toString();
  }

  void changeProfile() {}

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
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
                      image: widget.user.image != null
                          ? DecorationImage(
                              image: NetworkImage(
                                widget.user.image!,
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
              Row(
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
                  AppIcons.profession, "provide multiple services", 'svg'),
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
              const Text(
                "Add references",
                style: AppStyles.heading4,
              ),
              SizedBox(
                height: 8.w,
              ),
              SizedBox(
                height: 6.w,
              ),
              Container(
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
              SizedBox(height: 12.w),
              GestureDetector(
                onTap: saveData,
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
    );
  }

  Widget serviceDetails(Map<String, dynamic> profession, int index) {
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

    // Investment range text fields
    investment1.text = profession['investmentRange']?['min']?.toString() ?? '';
    investment2.text = profession['investmentRange']?['max']?.toString() ?? '';

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
                      const Text(
                        "Your Investment Range",
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
                      const Text(
                        "Your Preferred Investment Categories",
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
                print(profession['investmentRange']['min']);
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
