import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/widgets/translationWidget.dart';

class OutlinedDropdownButtonExample extends StatefulWidget {
  final List<String> list;
  final String initial;
  final String label;
  final void Function(String) onSelected;

  const OutlinedDropdownButtonExample({
    required this.list,
    required this.onSelected,
    required this.initial,
    required this.label,
    super.key,
  });

  @override
  State<OutlinedDropdownButtonExample> createState() =>
      _OutlinedDropdownButtonExampleState();
}

class _OutlinedDropdownButtonExampleState
    extends State<OutlinedDropdownButtonExample> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        widget.list.contains(widget.initial) ? widget.initial : widget.list[0];
  }

  @override
  void didUpdateWidget(OutlinedDropdownButtonExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initial != oldWidget.initial) {
      setState(() {
        dropdownValue = widget.list.contains(widget.initial)
            ? widget.initial
            : widget.list[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var seen = <String>{};
    List<String> uniquelist =
        widget.list.where((item) => seen.add(item)).toList();

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: dropdownValue, // Use dropdownValue here
        isDense: true,
        isExpanded: false,
        buttonStyleData: ButtonStyleData(
          height: 55,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.lightGrey,
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
        items: uniquelist.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: translationWidget(
              value,
              context,
              value,
              AppStyles.normalText,
            ),
          );
        }).toList(),
        customButton: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.lightGrey,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: translationWidget(
                  dropdownValue ?? widget.label,
                  context,
                  dropdownValue ?? widget.label,
                  AppStyles.normalText,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
