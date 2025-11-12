import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4;

import '../controller/custom_design_controller.dart';

class DesignPreview extends StatelessWidget {
  const DesignPreview({super.key});

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

  @override
  Widget build(BuildContext context) {
    final CustomDesignController c = Get.find();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final availW = constraints.maxWidth;
        final availH = constraints.maxHeight;
        final cardHeight = (availH > 0 ? availH * 0.9 : 360).clamp(220.0, 820.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            Flexible(
              fit: FlexFit.loose,
              child: Center(
                child: SizedBox(
                  width: availW,
                  height: cardHeight.toDouble(),
                  child: Obx(() {
                    final side = c.currentSide.value;
                    final color = c.productColors[c.selectedProductColorIndex.value].swatch;
                    final boxes = c.textBoxes.toList();
                    final stickers = c.stickers.toList();
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: RepaintBoundary(
                          key: c.previewKey,
                          child: GestureDetector(
                            onTap: () {
                              c.stopAllEditing();
                              c.setActiveSticker(null);
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(color: Colors.grey[100]),
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                                    child: LayoutBuilder(
                                      builder: (context, boxConstraints) {
                                        final maxW = boxConstraints.maxWidth;
                                        final maxH = boxConstraints.maxHeight;
                                        if (maxW <= 0 || maxH <= 0) {
                                          return const SizedBox.shrink();
                                        }

                                        final double canvasW = maxW * 0.92;
                                        final double canvasH = maxH * 0.92;
                                        final Size canvasSize = Size(canvasW, canvasH);

                                        return Align(
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(18),
                                            child: SizedBox(
                                              width: canvasW,
                                              height: canvasH,
                                              child: LayoutBuilder(
                                                builder: (context, canvasConstraints) {
                                                  final innerW = canvasConstraints.maxWidth;
                                                  final innerH = canvasConstraints.maxHeight;
                                                  if (innerW <= 0 || innerH <= 0) {
                                                    return const SizedBox.shrink();
                                                  }

                                                  final String? mockupPath = c.mockupAssetForSide(side);
                                                  final Widget? rawMockupWidget = (mockupPath != null && mockupPath.isNotEmpty)
                                                      ? Image.asset(
                                                          mockupPath,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                                        )
                                                      : null;
                                                  final Widget backgroundLayer = rawMockupWidget == null
                                                      ? Container(color: Colors.white)
                                                      : ColorFiltered(
                                                          colorFilter: ColorFilter.mode(
                                                            color.withOpacity(0.9),
                                                            BlendMode.modulate,
                                                          ),
                                                          child: rawMockupWidget,
                                                        );

                                                  final List<Widget> stickerWidgets = stickers.map<Widget>((sticker) {
                                                    return Obx(() {
                                                      final position = sticker.position.value;
                                                      final currentScale = sticker.scale.value;
                                                      final scaledSize = (90.0 * currentScale).clamp(36.0, 315.0);
                                                      final half = scaledSize / 2;
                                                      double left = position.dx * innerW - half;
                                                      double top = position.dy * innerH - half;
                                                      final maxLeft = math.max(0.0, innerW - scaledSize);
                                                      final maxTop = math.max(0.0, innerH - scaledSize);
                                                      left = left.clamp(0.0, maxLeft);
                                                      top = top.clamp(0.0, maxTop);
                                                      final isActive = c.activeStickerId.value == sticker.id;
                                                      final rotation = sticker.rotation.value;

                                                      Widget content;
                                                      if (sticker.source == StickerSource.art) {
                                                        content = Text(
                                                          sticker.data,
                                                          style: const TextStyle(fontSize: 48),
                                                        );
                                                      } else {
                                                        final file = File(sticker.data);
                                                        content = file.existsSync()
                                                            ? Image.file(file)
                                                            : const Icon(Icons.broken_image_outlined, size: 48);
                                                      }

                                                      return Positioned(
                                                        left: left,
                                                        top: top,
                                                        child: MatrixGestureDetector(
                                                          shouldTranslate: true,
                                                          shouldScale: true,
                                                          shouldRotate: true,
                                                          onMatrixUpdate: (m, tm, sm, rm) {
                                                            final translation = _matrixTranslation(tm);
                                                            final scaleDelta = _matrixScale(sm);
                                                            final rotationDelta = _matrixRotation(rm);
                                                            c.applyStickerGesture(
                                                              sticker.id,
                                                              translationDelta: translation,
                                                              scaleDelta: scaleDelta,
                                                              rotationDelta: rotationDelta,
                                                              canvasSize: canvasSize,
                                                            );
                                                          },
                                                          child: GestureDetector(
                                                            behavior: HitTestBehavior.translucent,
                                                            onTap: () {
                                                              c.setActiveSticker(sticker.id);
                                                              c.stopAllEditing();
                                                            },
                                                            child: Transform.rotate(
                                                              angle: rotation,
                                                              child: Container(
                                                                width: scaledSize,
                                                                height: scaledSize,
                                                                padding: const EdgeInsets.all(4),
                                                                decoration: isActive
                                                                    ? BoxDecoration(
                                                                        border: Border.all(
                                                                          color: Colors.blueAccent,
                                                                          width: 1.5,
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        color: Colors.white.withOpacity(0.08),
                                                                      )
                                                                    : null,
                                                                child: FittedBox(
                                                                  fit: BoxFit.contain,
                                                                  child: content,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  }).toList();

                                                  final List<Widget> textWidgets = boxes.map<Widget>((b) {
                                                    return Obx(() {
                                                      final rel = b.position.value;
                                                      final text = b.controller.text;
                                                      final fontFamily = b.fontFamily.value;
                                                      final fontSize = b.fontSize.value;
                                                      final isBold = b.isBold.value;
                                                      final isItalic = b.isItalic.value;
                                                      final textAlign = b.alignment.value;
                                                      final color = b.fontColor.value;
                                                      final isEditing = b.isEditing.value;

                                                      final style = _safeGoogleFontStyle(
                                                        fontFamily,
                                                        fontSize: fontSize,
                                                        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                                                        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                                                        color: color,
                                                      );

                                                      final tp = TextPainter(
                                                        text: TextSpan(text: text.isEmpty ? ' ' : text, style: style),
                                                        textDirection: TextDirection.ltr,
                                                        textAlign: textAlign,
                                                        maxLines: 100,
                                                      );
                                                      tp.layout(minWidth: 0, maxWidth: innerW * 0.9);
                                                      final textSize = tp.size;
                                                      const buffer = 8.0;
                                                      final boxWidth = (textSize.width + buffer).clamp(0.0, innerW);
                                                      final boxHeight = (textSize.height + buffer).clamp(0.0, innerH);

                                                      double left = rel.dx * innerW - boxWidth / 2;
                                                      double top = rel.dy * innerH - boxHeight / 2;
                                                      final maxLeft = math.max(0.0, innerW - boxWidth);
                                                      final maxTop = math.max(0.0, innerH - boxHeight);
                                                      left = left.clamp(0.0, maxLeft);
                                                      top = top.clamp(0.0, maxTop);

                                                      final isActive = c.activeTextId.value == b.id;

                                                      return Positioned(
                                                        left: left,
                                                        top: top,
                                                        child: GestureDetector(
                                                          behavior: HitTestBehavior.translucent,
                                                          onTap: () {
                                                            c.setActiveText(b.id);
                                                            c.setActiveSticker(null);
                                                          },
                                                          onDoubleTap: () => c.startEditing(b.id),
                                                          onPanUpdate: (details) {
                                                            if (!isEditing) {
                                                              c.moveTextBoxByDeltaPx(b.id, details.delta, canvasSize);
                                                            }
                                                          },
                                                          child: Container(
                                                            width: boxWidth,
                                                            height: boxHeight,
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: (!c.isExporting.value && isActive && !isEditing)
                                                                ? BoxDecoration(
                                                                    border: Border.all(color: Colors.blueAccent, width: 1.5),
                                                                    color: Colors.transparent,
                                                                  )
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
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                                                        border: InputBorder.none,
                                                                      ),
                                                                      onSubmitted: (_) => c.stopEditing(b.id),
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
                                                                        textAlign: textAlign,
                                                                        softWrap: false,
                                                                        style: style,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                  }).toList();

                                                  return Stack(
                                                    children: [
                                                      backgroundLayer,
                                                      ...stickerWidgets,
                                                      ...textWidgets,
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

Offset _matrixTranslation(Matrix4 matrix) {
  final dx = matrix.storage[12];
  final dy = matrix.storage[13];
  return Offset(
    dx.isFinite ? dx : 0.0,
    dy.isFinite ? dy : 0.0,
  );
}

double _matrixScale(Matrix4 matrix) {
  final sx = matrix.storage[0];
  if (!sx.isFinite || sx == 0) return 1.0;
  return sx;
}

double _matrixRotation(Matrix4 matrix) {
  final angle = math.atan2(matrix.storage[1], matrix.storage[0]);
  if (!angle.isFinite) return 0.0;
  return angle;
}