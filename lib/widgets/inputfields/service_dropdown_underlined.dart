// ignore_for_file: deprecated_member_use

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stargate/config/core.dart';

import '../../localization/localization.dart';
import '../../utils/app_data.dart';

class ServicesDropdownUnderlined extends StatefulWidget {
  final List<String> list;
  final String initial;
  final String label;
  final void Function(String) onSelected;
  final IconData? leadingIcon;
  final String? svgIcon;

  const ServicesDropdownUnderlined({
    required this.list,
    required this.onSelected,
    required this.initial,
    required this.label,
    this.leadingIcon,
    this.svgIcon,
    super.key,
  });

  @override
  State<ServicesDropdownUnderlined> createState() =>
      _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<ServicesDropdownUnderlined> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        widget.list.contains(widget.initial) ? widget.initial : widget.list[0];
  }

  @override
  Widget build(BuildContext context) {
    String localValueTranslated(String value) {
      return userMappingSimple.firstWhere((u) => u['type'] == value,
          orElse: () => {'label': value})['label']!;
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: dropdownValue,
        isDense: true,
        isExpanded: false,
        buttonStyleData: ButtonStyleData(
          height: 55,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              bottom: BorderSide(
                color: AppColors.lightGrey,
              ),
            ),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          offset: const Offset(0, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 10),
        ),
        onChanged: (String? value) {
          if (value != null) {
            setState(() {
              dropdownValue = value;
            });
            widget.onSelected(value);
          }
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              AppLocalization.of(context)!
                  .translate(localValueTranslated(value)),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        customButton: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.lightGrey,
              ),
            ),
          ),
          child: Row(
            children: [
              if (widget.leadingIcon != null)
                Icon(
                  widget.leadingIcon,
                  color: AppColors.white,
                ),
              if (widget.svgIcon != null)
                SvgPicture.asset(
                  widget.svgIcon!,
                  color: Colors.white,
                  width: 20,
                ),
              if (widget.leadingIcon != null || widget.svgIcon != null)
                const SizedBox(width: 13),
              Expanded(
                child: Text(
                  AppLocalization.of(context)!.translate(localValueTranslated(
                    dropdownValue ?? widget.label,
                  )),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
