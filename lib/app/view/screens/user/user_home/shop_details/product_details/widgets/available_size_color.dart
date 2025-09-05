import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableSizeColor extends StatelessWidget {
  final List<String> list;
  final bool isColor;
  final controller;
  AvailableSizeColor(
      {super.key, this.controller, required this.list, this.isColor = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [...list]
            .map((s) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  // Only the ChoiceChip needs to be reactive
                  child: Obx(() {
                    // Parse color safely, fallback to grey
                    Color parsedColor;
                    try {
                      parsedColor =
                          Color(int.parse(s.replaceFirst('#', '0xff')));
                    } catch (_) {
                      parsedColor = Colors.grey;
                    }

                    if (isColor) {
                      final bool selected = controller.color.value == s;
                      // choose check icon color for contrast
                      final Color checkColor =
                          parsedColor.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white;

                      return ChoiceChip(
                        // keep the chip itself transparent so our circle shows correctly
                        backgroundColor: Colors.transparent,
                        selectedColor: Colors.transparent,
                        labelPadding: EdgeInsets.zero,
                        padding: const EdgeInsets.all(0),
                        // small rounded tap target around the circle
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        selected: selected,
                        onSelected: (sel) => controller.selectColor(s),
                        label: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: parsedColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              width: selected ? 2.5 : 1.0,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: selected
                                ? Icon(
                                    Icons.check,
                                    size: 18,
                                    color: checkColor,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }

                    // non-color (size) ChoiceChip (unchanged appearance)
                    return ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: isColor ? Text("") : Text(s),
                      selected: controller.size.value == s,
                      onSelected: (selected) => controller.selectSize(s),
                      selectedColor: Colors.teal,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: controller.size.value == s
                            ? Colors.white
                            : Colors.black,
                      ),
                    );
                  }),
                ))
            .toList(),
      ),
    );
  }
}
