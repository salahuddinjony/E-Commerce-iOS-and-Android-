import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/custom_design_controller.dart';

class DesignToolbar extends StatelessWidget {
  const DesignToolbar({super.key});

  static const List<String> _fontFamilies = [
    'Poppins',
    'Roboto',
    'Montserrat',
    'Lato',
    'Oswald',
    'Raleway',
    'Open Sans',
    'Merriweather',
    'Playfair Display',
    'Nunito',
    'Source Sans Pro',
    'Roboto Condensed',
    'Archivo',
    'Cabin',
    'Fira Sans',
  ];

  // simple palette
  static const List<Color> _colorOptions = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.pink,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
    Colors.grey,
  ];

  TextStyle _safeGoogleFontStyle(
    String family, {
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    Color? color,
  }) {
    try {
      return GoogleFonts.getFont(
        family,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: color,
      );
    } catch (_) {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: color,
      );
    }
  }

  Future<void> _showFontPicker(BuildContext context, CustomDesignController c) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) {
        String query = '';
        final ctl = TextEditingController();
        return StatefulBuilder(builder: (ctx, setState) {
          final list = query.isEmpty ? _fontFamilies : _fontFamilies.where((f) => f.toLowerCase().contains(query.toLowerCase())).toList();
          return AlertDialog(
            title: const Text('Choose font'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: ctl,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search fonts'),
                    onChanged: (v) => setState(() => query = v),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final f = list[i];
                        return ListTile(
                          title: Text(f, style: _safeGoogleFontStyle(f, fontSize: 16)),
                          subtitle: Text('The quick brown fox', style: _safeGoogleFontStyle(f, fontSize: 12, color: Colors.grey[600])),
                          onTap: () => Navigator.of(ctx).pop(f),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
          );
        });
      },
    );
    if (selected != null) c.setFontFamilyForActive(selected);
  }

  Future<void> _showColorPicker(BuildContext context, CustomDesignController c, Color initial) async {
    final picked = await showDialog<Color>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Text color'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 6,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: _colorOptions.map((col) {
                return GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: col,
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: 36,
                    height: 36,
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))],
        );
      },
    );
    if (picked != null) c.setColorForActive(picked);
  }

  @override
  Widget build(BuildContext context) {
    final CustomDesignController c = Get.find();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: LayoutBuilder(builder: (context, constraints) {
          final maxW = constraints.maxWidth;
          final dropdownW = (maxW * 0.38).clamp(120.0, 220.0);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // Add text box button
                IconButton(
                  onPressed: () => c.addTextBox(text: 'New text'),
                  icon: const Icon(Icons.add_box_outlined),
                  tooltip: 'Add text box',
                ),

                const SizedBox(width: 6),

                // When a box is selected show inline editors
                Obx(() {
                  final activeId = c.activeId.value;
                  if (activeId == null) return const SizedBox.shrink();

                  final box = c.textBoxes.firstWhereOrNull((t) => t.id == activeId);
                  if (box == null) return const SizedBox.shrink();

                  return Row(
                    children: [
                      // quick inline text edit (small)
                      SizedBox(
                        width: dropdownW,
                        child: TextField(
                          controller: box.controller,
                          decoration: const InputDecoration(hintText: 'Edit text', isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
                          onChanged: (_) => box.controller.text = box.controller.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // font picker for active
                      IconButton(
                        onPressed: () => _showFontPicker(context, c),
                        icon: const Icon(Icons.font_download_outlined),
                        tooltip: 'Choose font',
                      ),

                      // color plate button
                      IconButton(
                        onPressed: () => _showColorPicker(context, c, box.fontColor.value),
                        icon: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: box.fontColor.value,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        tooltip: 'Text color',
                      ),

                      // size
                      IconButton(onPressed: c.decreaseFontForActive, icon: const Icon(Icons.remove)),
                      Obx(() => Text("${c.textBoxes.firstWhereOrNull((t) => t.id == activeId)?.fontSize.value.toInt() ?? 0}")),
                      IconButton(onPressed: c.increaseFontForActive, icon: const Icon(Icons.add)),
                      // bold / italic / delete
                      IconButton(onPressed: c.toggleBoldForActive, icon: const Icon(Icons.format_bold)),
                      IconButton(onPressed: c.toggleItalicForActive, icon: const Icon(Icons.format_italic)),
                      IconButton(
                        onPressed: () {
                          c.removeTextBox(activeId);
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                    ],
                  );
                }),

                const SizedBox(width: 8),

                // If nothing selected show general controls (or keep minimal)
                Obx(() {
                  if (c.activeId.value == null) {
                    return Row(
                      children: [
                        TextButton.icon(onPressed: () => c.addTextBox(text: 'New text'), icon: const Icon(Icons.text_fields), label: const Text('Add text')),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}