import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:stargate/config/core.dart';
import 'package:stargate/widgets/translationWidget.dart';

class DropdownButton2Example extends StatefulWidget {
  final List<String> list;
  final String initial;
  final String label;
  final void Function(String) onSelected;

  const DropdownButton2Example({
    required this.list,
    required this.onSelected,
    required this.initial,
    required this.label,
    super.key,
  });

  @override
  State<DropdownButton2Example> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButton2Example> {
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue =
        widget.list.contains(widget.initial) ? widget.initial : widget.list[0];
  }

  @override
  void didUpdateWidget(DropdownButton2Example oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initial != oldWidget.initial || widget.list != oldWidget.list) {
      setState(() {
        dropdownValue = widget.list.contains(widget.initial)
            ? widget.initial
            : (widget.list.isNotEmpty ? widget.list[0] : null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("📌 Received List in Dropdown: ${widget.list}"); // Debugging line
    var seen = <String>{};
    List<String> uniquelist =
        widget.list.where((item) => seen.add(item)).toList();
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
                value, context, value, const TextStyle(fontSize: 14)),
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
                  '',
                  const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                  ),
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
