import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/custom_design_controller.dart';

class DesignPreview extends StatelessWidget {
  const DesignPreview({super.key});

  TextStyle _safeGoogleFontStyle(String family,
      {double fontSize = 14, FontWeight fontWeight = FontWeight.normal, FontStyle fontStyle = FontStyle.normal, Color? color}) {
    try {
      return GoogleFonts.getFont(family, fontSize: fontSize, fontWeight: fontWeight, fontStyle: fontStyle, color: color);
    } catch (_) {
      return GoogleFonts.poppins(fontSize: fontSize, fontWeight: fontWeight, fontStyle: fontStyle, color: color);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomDesignController c = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final availW = constraints.maxWidth;
        final availH = constraints.maxHeight;
        final cardHeight = (availH > 0 ? availH * 0.9 : 360).clamp(180.0, 800.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 8.0),
            //     child: Text("Art page+", style: TextStyle(color: Colors.grey[700])),
            //   ),
            // ),
            Flexible(
              fit: FlexFit.loose,
              child: Center(
                child: SizedBox(
                  width: availW,
                  height: cardHeight.toDouble(),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: RepaintBoundary(
                        key: c.previewKey,
                        child: GestureDetector(
                          // tap outside text boxes stops any editing
                          onTap: () => c.stopAllEditing(),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // show picked image if exists, otherwise show upload placeholder
                              Obx(() {
                                final path = c.imagePath.value;
                                if (path != null && File(path).existsSync()) {
                                  return Image.file(File(path), fit: BoxFit.cover);
                                }
                                // placeholder encouraging user to upload
                                return Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(Icons.image_not_supported_outlined, size: 32, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('No image selected', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                );
                              }),                 

                              // Each text box rendered and draggable / editable
                              Obx(() {
                                final boxes = c.textBoxes.toList();
                                return Stack(
                                  children: boxes.map((b) {
                                    final rel = b.position.value;
                                    final text = b.controller.text;
                                    final style = _safeGoogleFontStyle(
                                      b.fontFamily.value,
                                      fontSize: b.fontSize.value,
                                      fontWeight: b.isBold.value ? FontWeight.bold : FontWeight.normal,
                                      fontStyle: b.isItalic.value ? FontStyle.italic : FontStyle.normal,
                                      color: b.fontColor.value, // use box color
                                    );

                                    // measure
                                    final tp = TextPainter(
                                      text: TextSpan(text: text.isEmpty ? ' ' : text, style: style),
                                      textDirection: TextDirection.ltr,
                                      textAlign: b.alignment.value,
                                      maxLines: 100,
                                    );
                                    tp.layout(minWidth: 0, maxWidth: availW * 0.9);
                                    final textSize = tp.size;
                                    const buffer = 6.0;
                                    final boxWidth = (textSize.width + buffer).clamp(0.0, availW);
                                    final boxHeight = (textSize.height + buffer).clamp(0.0, cardHeight);

                                    double left = rel.dx * availW - boxWidth / 2;
                                    double top = rel.dy * cardHeight - boxHeight / 2;
                                    left = left.clamp(0.0, (availW - boxWidth).clamp(0.0, double.infinity));
                                    top = top.clamp(0.0, (cardHeight - boxHeight).clamp(0.0, double.infinity)) as double;

                                    final isActive = c.activeId.value == b.id;
                                    final isEditing = (b as dynamic).isEditing?.value ?? false;

                                    return Positioned(
                                      left: left,
                                      top: top,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          // select
                                          c.setActive(b.id);
                                        },
                                        onDoubleTap: () {
                                          if ((c as dynamic).startEditing != null) {
                                            (c as dynamic).startEditing(b.id);
                                          }
                                        },
                                        onPanUpdate: (details) {
                                          if (!isEditing) {
                                            c.moveTextBoxByDeltaPx(b.id, details.delta, Size(availW, cardHeight.toDouble()));
                                          }
                                        },
                                        child: Container(
                                          width: boxWidth,
                                          height: boxHeight.toDouble(),
                                          padding: const EdgeInsets.all(2),
                                          decoration: (!c.isExporting.value && isActive && !isEditing)
                                              ? BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 1.5), color: Colors.transparent)
                                              : null,
                                          child: isEditing
                                              ? Material(
                                                  color: Colors.transparent,
                                                  child: TextField(
                                                    controller: b.controller,
                                                    autofocus: true,
                                                    maxLines: null,
                                                    style: style,
                                                    decoration: const InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                                      border: InputBorder.none,
                                                    ),
                                                    onSubmitted: (_) {
                                                      if ((c as dynamic).stopEditing != null) {
                                                        (c as dynamic).stopEditing(b.id);
                                                      }
                                                    },
                                                  ),
                                                )
                                              : FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: SizedBox(
                                                    width: textSize.width,
                                                    height: textSize.height,
                                                    child: Text(
                                                      text,
                                                      textAlign: b.alignment.value,
                                                      softWrap: false,
                                                      style: style,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}