// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/models/user.dart';
import 'package:stargate/screens/listings/widgets/dropdown_button2.dart';
import 'package:stargate/utils/app_data.dart';
import 'package:stargate/utils/app_images.dart';
import 'package:stargate/widgets/buttons/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stargate/widgets/buttons/custom_button.dart';
import 'package:stargate/widgets/inputfields/country_textfield.dart';
import 'package:stargate/widgets/inputfields/outlined_dropdown.dart';
import 'package:stargate/widgets/inputfields/textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User user = users[0];
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController websiteLink = TextEditingController();

  TextEditingController investment1 = TextEditingController();
  TextEditingController investment2 = TextEditingController();

  List<Service> userServices = users[0].services;
  List<String> prefferedInvestmentCategorires = [];
  List<String> selectedProfessions = [];
  List<String> selectedExperiences = [];
  double investmentValue1 = 0;
  double investmentValue2 = 0;

  void saveData() {}

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
                      image: DecorationImage(
                        image: NetworkImage(
                          user.image,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(50.w),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Column(
                    children: [
                      Text(
                        "change profile",
                        style: AppStyles.heading4.copyWith(
                          color: AppColors.blue,
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
                    user.email,
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
              ...selectedProfessions.map(
                (item) => serviceDetails(item),
              ),
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
              CustomButton(
                text: "Save",
                onPressed: () => saveData(),
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

  Widget serviceDetails(String profession) {
    TextEditingController specialization = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.w,
        ),
        supportiveText(
            AppIcons.medal, "provide $profession specialization", 'image'),
        CustomTextField(
          controller: specialization,
          label: "$profession specialization",
          hintText: "Specify Specialization",
          inputType: TextInputType.text,
          horizontalSpacing: 0,
          verticalSpacing: 3,
        ),
        SizedBox(
          height: 3.w,
        ),
        profession != 'Investor'
            ? Column(
                children: [
                  DropdownButton2Example(
                    list: experiencesList,
                    onSelected: (value) {
                      if (selectedExperiences.contains(value)) {
                      } else {
                        selectedExperiences.add(value);
                        setState(() {});
                      }
                    },
                    initial: experiencesList[0],
                    label: "Select Experience",
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AppIcons.cash,
                        width: 32,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      const Text(
                        "your investment range",
                        style: AppStyles.heading4,
                      ),
                      SizedBox(
                        height: 8.w,
                      ),
                    ],
                  ),
                  invesmentRange(),
                  SizedBox(
                    height: 8.w,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        color: AppColors.blue,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      const Text(
                        "your preferred investment categories",
                        style: AppStyles.heading4,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.w,
                  ),
                  OutlinedDropdownButtonExample(
                    list: propertyTypes,
                    onSelected: (value) {
                      if (prefferedInvestmentCategorires.contains(value)) {
                      } else {
                        prefferedInvestmentCategorires.add(value);
                        setState(() {});
                      }
                    },
                    initial: propertyTypes[0],
                    label: "Category",
                  ),
                  SizedBox(
                    height: 6.w,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...prefferedInvestmentCategorires.map(
                          (item) => selectedBubbleOption(
                              item, prefferedInvestmentCategorires),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget invesmentRange() {
    TextEditingController investment1 = TextEditingController();
    TextEditingController investment2 = TextEditingController();
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
            ),
          ),
          SizedBox(
            width: 6.w,
          ),
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
            ),
          ),
        ],
      ),
    );
  }
}
