import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local/app/view/screens/features/client/user_home/custom_design/tools_model.dart/tools_models.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:vector_math/vector_math_64.dart' show Matrix4;

import 'package:local/app/utils/app_colors/app_colors.dart';
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
                                // Front and Back thumbnail previews in top left
                                Obx(() {
                                  final currentSide = c.currentSide.value;
                                  final frontPath = c.mockupAssetForSide(DesignSide.front);
                                  final backPath = c.mockupAssetForSide(DesignSide.back);
                                  final productColor = c.productColors[c.selectedProductColorIndex.value].swatch;
                                  
                                  return Positioned(
                                    left: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Front thumbnail
                                          GestureDetector(
                                            onTap: () => c.switchSide(DesignSide.front),
                                            child: Container(
                                              width: 38,
                                              height: 38,
                                              margin: const EdgeInsets.only(right: 3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: currentSide == DesignSide.front
                                                      ? AppColors.brightCyan
                                                      : Colors.grey[300]!,
                                                  width: currentSide == DesignSide.front ? 2 : 1,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: frontPath != null && frontPath.isNotEmpty
                                                    ? ColorFiltered(
                                                        colorFilter: ColorFilter.mode(
                                                          productColor.withOpacity(0.9),
                                                          BlendMode.modulate,
                                                        ),
                                                        child: Image.asset(
                                                          frontPath,
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                                        ),
                                                      )
                                                    : Container(color: Colors.grey[200]),
                                              ),
                                            ),
                                          ),
                                          // Back thumbnail
                                          GestureDetector(
                                            onTap: () => c.switchSide(DesignSide.back),
                                            child: Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: currentSide == DesignSide.back
                                                      ? AppColors.brightCyan
                                                      : Colors.grey[300]!,
                                                  width: currentSide == DesignSide.back ? 2 : 1,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                child: backPath != null && backPath.isNotEmpty
                                                    ? ColorFiltered(
                                                        colorFilter: ColorFilter.mode(
                                                          productColor.withOpacity(0.9),
                                                          BlendMode.modulate,
                                                        ),
                                                        child: Image.asset(
                                                          backPath,
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                                        ),
                                                      )
                                                    : Container(color: Colors.grey[200]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                    child: LayoutBuilder(
                                      builder: (context, boxConstraints) {
                                        final maxW = boxConstraints.maxWidth;
                                        final maxH = boxConstraints.maxHeight;
                                        if (maxW <= 0 || maxH <= 0) {
                                          return const SizedBox.shrink();
                                        }

                                        final double canvasW = maxW;
                                        final double canvasH = maxH;
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
                                                          fit: BoxFit.contain,
                                                          width: innerW * 1.2,
                                                          height: innerH * 1.2,
                                                          alignment: Alignment.center,
                                                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                                        )
                                                      : null;
                                                  final Widget backgroundLayer = rawMockupWidget == null
                                                      ? Container(color: Colors.white)
                                                      : Center(
                                                          child: ColorFiltered(
                                                            colorFilter: ColorFilter.mode(
                                                              color.withOpacity(0.9),
                                                              BlendMode.modulate,
                                                            ),
                                                            child: rawMockupWidget,
                                                          ),
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
                                                        // Check if data is a URL (starts with http)
                                                        if (sticker.data.startsWith('http://') || 
                                                            sticker.data.startsWith('https://')) {
                                                          // Network image (icon from API) - check if SVG
                                                          if (sticker.data.endsWith('.svg') || sticker.data.contains('.svg?')) {
                                                            // SVG icon with color filter
                                                            content = Obx(() => ColorFiltered(
                                                              colorFilter: ColorFilter.mode(
                                                                sticker.color.value,
                                                                BlendMode.srcIn,
                                                              ),
                                                              child: SvgPicture.network(
                                                                sticker.data,
                                                                width: scaledSize * 0.8,
                                                                height: scaledSize * 0.8,
                                                                placeholderBuilder: (context) => const SizedBox(
                                                                  width: 48,
                                                                  height: 48,
                                                                  child: Center(
                                                                    child: CircularProgressIndicator(strokeWidth: 2),
                                                                  ),
                                                                ),
                                                              ),
                                                            ));
                                                          } else {
                                                            // Regular image (PNG, JPG, etc.) with color filter
                                                            content = Obx(() => ColorFiltered(
                                                              colorFilter: ColorFilter.mode(
                                                                sticker.color.value,
                                                                BlendMode.modulate,
                                                              ),
                                                              child: CachedNetworkImage(
                                                                imageUrl: sticker.data,
                                                                placeholder: (context, url) => const SizedBox(
                                                                  width: 48,
                                                                  height: 48,
                                                                  child: Center(
                                                                    child: CircularProgressIndicator(strokeWidth: 2),
                                                                  ),
                                                                ),
                                                                errorWidget: (context, url, error) => const Icon(
                                                                  Icons.broken_image_outlined,
                                                                  size: 48,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                            ));
                                                          }
                                                        } else {
                                                          // Local file (uploaded image) - no color filter
                                                          final file = File(sticker.data);
                                                          if (file.existsSync()) {
                                                            if (sticker.data.endsWith('.svg')) {
                                                              // SVG file without color filter (user uploaded)
                                                              content = SvgPicture.file(
                                                                file,
                                                                width: scaledSize * 0.8,
                                                                height: scaledSize * 0.8,
                                                              );
                                                            } else {
                                                              // Regular image file without color filter (user uploaded)
                                                              content = Image.file(file);
                                                            }
                                                          } else {
                                                            content = const Icon(Icons.broken_image_outlined, size: 48);
                                                          }
                                                        }
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