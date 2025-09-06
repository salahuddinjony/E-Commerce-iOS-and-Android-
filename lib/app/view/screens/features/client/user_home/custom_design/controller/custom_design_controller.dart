import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class TextBoxModel {
  final String id;
  final TextEditingController controller;
  final Rx<Offset> position; // relative 0..1
  final RxString fontFamily;
  final RxDouble fontSize;
  final RxBool isBold;
  final RxBool isItalic;
  final Rx<TextAlign> alignment;
  final RxBool isEditing;
  final Rx<Color> fontColor; // new

  TextBoxModel({
    required this.id,
    required String text,
    Offset initialPos = const Offset(0.5, 0.5),
    String initialFont = 'Poppins',
    double initialSize = 48,
    Color initialColor = Colors.white,
  })  : controller = TextEditingController(text: text),
        position = Rx<Offset>(initialPos),
        fontFamily = RxString(initialFont),
        fontSize = RxDouble(initialSize),
        isBold = RxBool(false),
        isItalic = RxBool(false),
        alignment = Rx<TextAlign>(TextAlign.center),
        isEditing = RxBool(false),
        fontColor = Rx<Color>(initialColor);

  void dispose() => controller.dispose();
}

class CustomDesignController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // image path
  final imagePath = RxnString();

  // key to capture preview
  final GlobalKey previewKey = GlobalKey();

  // export in progress flag
  final isExporting = false.obs;

  // list of text boxes
  final textBoxes = <TextBoxModel>[].obs;

  // id of active/selected text box
  final activeId = RxnString();

  Future<void> pickImageFromGallery() async {
    try {
      final xfile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (xfile != null) imagePath.value = xfile.path;
    } catch (_) {
      // ignore
    }
  }

  void clearImage() => imagePath.value = null;

  // Add a new text box in center with initial text
  void addTextBox({String text = 'Text'}) {
    stopAllEditing();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final box = TextBoxModel(id: id, text: text);
    textBoxes.add(box);
    activeId.value = id;
    startEditing(id);
  }

  // Remove selected or specified box
  void removeTextBox(String id) {
    final idx = textBoxes.indexWhere((b) => b.id == id);
    if (idx != -1) {
      textBoxes[idx].dispose();
      textBoxes.removeAt(idx);
      if (activeId.value == id) activeId.value = null;
    }
  }

  // set active selection
  void setActive(String? id) {
    if (id != activeId.value) stopAllEditing();
    activeId.value = id;
  }

  // start editing a specific box (double-tap)
  void startEditing(String id) {
    stopAllEditing();
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) {
      b.isEditing.value = true;
      activeId.value = id;
      b.controller.selection = TextSelection.fromPosition(TextPosition(offset: b.controller.text.length));
    }
  }

  // stop editing a specific box
  void stopEditing(String id) {
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.isEditing.value = false;
  }

  // stop editing all boxes
  void stopAllEditing() {
    for (final b in textBoxes) {
      if (b.isEditing.value) b.isEditing.value = false;
    }
  }

  // Move a specific box by delta pixels, using cardSize to convert
  void moveTextBoxByDeltaPx(String id, Offset deltaPx, Size cardSize) {
    final box = textBoxes.firstWhereOrNull((b) => b.id == id);
    if (box == null) return;
    if (box.isEditing.value) return; // don't move while editing
    if (cardSize.width <= 0 || cardSize.height <= 0) return;
    final dx = deltaPx.dx / cardSize.width;
    final dy = deltaPx.dy / cardSize.height;
    box.position.value = Offset(
      (box.position.value.dx + dx).clamp(0.0, 1.0),
      (box.position.value.dy + dy).clamp(0.0, 1.0),
    );
  }

  // set absolute relative position 0..1
  void setTextPositionRelative(String id, Offset rel) {
    final box = textBoxes.firstWhereOrNull((b) => b.id == id);
    if (box == null) return;
    box.position.value = Offset(rel.dx.clamp(0.0, 1.0), rel.dy.clamp(0.0, 1.0));
  }

  // update style for active box (helpers)
  void increaseFontForActive() {
    final id = activeId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontSize.value = (b.fontSize.value + 2).clamp(8.0, 180.0);
  }

  void decreaseFontForActive() {
    final id = activeId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontSize.value = (b.fontSize.value - 2).clamp(8.0, 180.0);
  }

  void toggleBoldForActive() {
    final id = activeId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.isBold.value = !b.isBold.value;
  }

  void toggleItalicForActive() {
    final id = activeId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.isItalic.value = !b.isItalic.value;
  }

  void setFontFamilyForActive(String f) {
    final id = activeId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontFamily.value = f;
  }

  void setAlignmentForActive(TextAlign a) {
    final id = activeId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.alignment.value = a;
  }

  // new: set color for active text box
  void setColorForActive(Color color) {
    final id = activeId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontColor.value = color;
  }

  // capture the preview RepaintBoundary and write PNG to gallery, returns saved path or null
  Future<String?> exportPreviewAsPng() async {
    if (isExporting.value) return null;
    isExporting.value = true;
    try {
      final ctx = previewKey.currentContext;
      if (ctx == null) return null;
      final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final Uint8List bytes = byteData.buffer.asUint8List();

      // On Android/iOS request storage/media permission if needed
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) return null;
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        if (!status.isGranted) return null;
      }
      
      final result = await ImageGallerySaver.saveImage(bytes, quality: 100, name: 'design_${DateTime.now().millisecondsSinceEpoch}');
      if (result == null) return null;

      // ImageGallerySaver returns a Map on many platforms
      String? savedPath;
      if (result is Map) {
        savedPath = result['filePath']?.toString() ?? result['path']?.toString() ?? result['result']?.toString();
      } else if (result is String) {
        savedPath = result;
      }
      return savedPath;
    } catch (_) {
      return null;
    } finally {
      isExporting.value = false;
    }
  }

  @override
  void onClose() {
    for (final b in textBoxes) b.dispose();
    super.onClose();
  }
}

// small extension to avoid import
extension FirstWhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}