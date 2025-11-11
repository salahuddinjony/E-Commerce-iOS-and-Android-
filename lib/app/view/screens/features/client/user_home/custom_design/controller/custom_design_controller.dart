import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
// permission_handler removed because not used in current export flow
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:gal/gal.dart';

enum DesignSide { front, back }

enum StickerSource { art, image }

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
    double initialSize = 32,
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

class StickerModel {
  final String id;
  final StickerSource source;
  final String data; // emoji for art, file path for image
  final Rx<Offset> position;
  final RxDouble scale;
  final RxDouble rotation;

  StickerModel({
    required this.id,
    required this.source,
    required this.data,
    Offset initialPos = const Offset(0.5, 0.5),
    double initialScale = 1.0,
    double initialRotation = 0.0,
  })  : position = Rx<Offset>(initialPos),
        scale = RxDouble(initialScale),
        rotation = RxDouble(initialRotation);
}

class MockupAssets {
  final String front;
  final String back;

  const MockupAssets({
    required this.front,
    required this.back,
  });
}

class SideDesignState {
  final imagePath = RxnString();
  final RxList<TextBoxModel> textBoxes = <TextBoxModel>[].obs;
  final RxList<StickerModel> stickers = <StickerModel>[].obs;

  void dispose() {
    for (final b in textBoxes) {
      b.dispose();
    }
  }
}

class ProductColorOption {
  final String name;
  final Color swatch;
  final List<String> sizes;

  const ProductColorOption({
    required this.name,
    required this.swatch,
    required this.sizes,
  });
}

class CustomDesignController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  final currentSide = DesignSide.front.obs;

  final SideDesignState frontState = SideDesignState();
  final SideDesignState backState = SideDesignState();

  final MockupAssets? mockupAssets = const MockupAssets(
    front: 'assets/custom_image/front.png',
    back: 'assets/custom_image/back.png',
  );

  SideDesignState get _currentState =>
      currentSide.value == DesignSide.front ? frontState : backState;

  // key to capture preview
  final GlobalKey previewKey = GlobalKey();

  // export in progress flag
  final isExporting = false.obs;

  // exported image bytes (for API posting) and base64 string
  final exportedImageBytes = Rxn<Uint8List>();
  final exportedImageBase64 = RxnString();

  // list of text boxes
  RxList<TextBoxModel> get textBoxes => _currentState.textBoxes;

  final textActiveIds = {
    DesignSide.front: RxnString(),
    DesignSide.back: RxnString(),
  };

  final stickerActiveIds = {
    DesignSide.front: RxnString(),
    DesignSide.back: RxnString(),
  };

  // id of active/selected elements
  RxnString get activeTextId => textActiveIds[currentSide.value]!;

  RxnString get activeStickerId => stickerActiveIds[currentSide.value]!;

  final List<ProductColorOption> productColors = const [
    ProductColorOption(
        name: 'Classic White',
        swatch: Colors.white,
        sizes: ['XS', 'S', 'M', 'L', 'XL', '2XL']),
    ProductColorOption(
        name: 'Heather Heliconia',
        swatch: Color(0xFFF06292),
        sizes: ['S', 'M', 'L', 'XL', '2XL', '3XL']),
    ProductColorOption(
        name: 'Steel Grey',
        swatch: Color(0xFF9E9E9E),
        sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Ocean Blue',
        swatch: Color(0xFF42A5F5),
        sizes: ['S', 'M', 'L', 'XL', 'XXL']),
    ProductColorOption(
        name: 'Sunset Orange',
        swatch: Color(0xFFFFA726),
        sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Forest Green',
        swatch: Color(0xFF66BB6A),
        sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Jet Black',
        swatch: Colors.black,
        sizes: ['S', 'M', 'L', 'XL', '2XL']),
    ProductColorOption(
        name: 'Ivory', swatch: Color(0xFFF5F5DC), sizes: ['XS', 'S', 'M', 'L']),
    ProductColorOption(
        name: 'Royal Blue',
        swatch: Color(0xFF1565C0),
        sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Cardinal Red',
        swatch: Color(0xFFB71C1C),
        sizes: ['S', 'M', 'L', 'XL', '2XL']),
    ProductColorOption(
        name: 'Charcoal',
        swatch: Color(0xFF424242),
        sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Mint', swatch: Color(0xFFB2DFDB), sizes: ['XS', 'S', 'M', 'L']),
    ProductColorOption(
        name: 'Banana', swatch: Color(0xFFFFF59D), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Lavender',
        swatch: Color(0xFFB39DDB),
        sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Deep Purple',
        swatch: Color(0xFF512DA8),
        sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Brick', swatch: Color(0xFF8D4A43), sizes: ['M', 'L', 'XL']),
    ProductColorOption(
        name: 'Sage', swatch: Color(0xFFA5B69C), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Sky', swatch: Color(0xFF90CAF9), sizes: ['XS', 'S', 'M', 'L']),
    ProductColorOption(
        name: 'Coral', swatch: Color(0xFFFF8A80), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Sand', swatch: Color(0xFFE0C097), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Chocolate', swatch: Color(0xFF6D4C41), sizes: ['M', 'L', 'XL']),
    ProductColorOption(
        name: 'Maroon',
        swatch: Color(0xFF500000),
        sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Teal', swatch: Color(0xFF00897B), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Navy',
        swatch: Color(0xFF0D47A1),
        sizes: ['S', 'M', 'L', 'XL', 'XXL']),
    ProductColorOption(
        name: 'Peach', swatch: Color(0xFFFFCCBC), sizes: ['XS', 'S', 'M']),
    ProductColorOption(
        name: 'Mustard', swatch: Color(0xFFE1AD01), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Lime', swatch: Color(0xFFCDDC39), sizes: ['XS', 'S', 'M']),
    ProductColorOption(
        name: 'Olive', swatch: Color(0xFF6B8E23), sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Berry', swatch: Color(0xFFAD1457), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Slate', swatch: Color(0xFF607D8B), sizes: ['S', 'M', 'L', 'XL']),
    ProductColorOption(
        name: 'Copper', swatch: Color(0xFFB87333), sizes: ['M', 'L', 'XL']),
    ProductColorOption(
        name: 'Blush', swatch: Color(0xFFF8BBD0), sizes: ['XS', 'S', 'M']),
    ProductColorOption(
        name: 'Denim', swatch: Color(0xFF5479A7), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Aqua', swatch: Color(0xFF4DD0E1), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Plum', swatch: Color(0xFF6A1B9A), sizes: ['S', 'M', 'L']),
    ProductColorOption(
        name: 'Canary', swatch: Color(0xFFFFF176), sizes: ['XS', 'S', 'M']),
    ProductColorOption(
        name: 'Ash', swatch: Color(0xFFD7CCC8), sizes: ['S', 'M', 'L']),
  ];

  final selectedProductColorIndex = 0.obs;

  SideDesignState stateForSide(DesignSide side) =>
      side == DesignSide.front ? frontState : backState;

  RxnString get imagePath => _currentState.imagePath;

  RxList<StickerModel> get stickers => _currentState.stickers;
  String? _transformingStickerId;
  double? _transformBaseScale;
  double? _transformBaseRotation;

  TextBoxModel? getActiveTextBox() {
    final id = activeTextId.value;
    if (id == null) return null;
    return textBoxes.firstWhereOrNull((t) => t.id == id);
  }

  StickerModel? getActiveSticker() {
    final id = activeStickerId.value;
    if (id == null) return null;
    return stickers.firstWhereOrNull((s) => s.id == id);
  }

  String? mockupAssetForSide(DesignSide side) {
    final assets = mockupAssets;
    if (assets == null) return null;
    return side == DesignSide.front ? assets.front : assets.back;
  }

  Future<void> pickImageFromGallery() async {
    try {
      final xfile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 85);
      if (xfile != null) imagePath.value = xfile.path;
    } catch (_) {
      // ignore
    }
  }

  void clearImage() => imagePath.value = null;

  void switchSide(DesignSide side) {
    if (currentSide.value == side) return;
    stopAllEditing();
    currentSide.value = side;
    activeTextId.value = null;
    activeStickerId.value = null;
  }

  // Add a new text box in center with initial text
  void addTextBox({String text = ''}) {
    stopAllEditing();
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final box = TextBoxModel(id: id, text: text);
    textBoxes.add(box);
    activeTextId.value = id;
    startEditing(id);
  }

  // Remove selected or specified box
  void removeTextBox(String id) {
    final idx = textBoxes.indexWhere((b) => b.id == id);
    if (idx != -1) {
      textBoxes[idx].dispose();
      textBoxes.removeAt(idx);
      if (activeTextId.value == id) activeTextId.value = null;
    }
  }

  // set active selection
  void setActiveText(String? id) {
    if (id != activeTextId.value) stopAllEditing();
    activeTextId.value = id;
  }

  // start editing a specific box (double-tap)
  void startEditing(String id) {
    stopAllEditing();
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) {
      b.isEditing.value = true;
      activeTextId.value = id;
      b.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: b.controller.text.length));
    }
  }

  // stop editing a specific box
  void stopEditing(String id) {
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.isEditing.value = false;
  }

  // stop editing all boxes
  void stopAllEditing() {
    for (final side in DesignSide.values) {
      final list = stateForSide(side).textBoxes;
      for (final b in list) {
        if (b.isEditing.value) b.isEditing.value = false;
      }
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
    final id = activeTextId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontSize.value = (b.fontSize.value + 2).clamp(8.0, 180.0);
  }

  void decreaseFontForActive() {
    final id = activeTextId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontSize.value = (b.fontSize.value - 2).clamp(8.0, 180.0);
  }

  void toggleBoldForActive() {
    final id = activeTextId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.isBold.value = !b.isBold.value;
  }

  void toggleItalicForActive() {
    final id = activeTextId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.isItalic.value = !b.isItalic.value;
  }

  void setFontFamilyForActive(String f) {
    final id = activeTextId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontFamily.value = f;
  }

  void setAlignmentForActive(TextAlign a) {
    final id = activeTextId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.alignment.value = a;
  }

  // new: set color for active text box
  void setColorForActive(Color color) {
    final id = activeTextId.value;
    final b = textBoxes.firstWhereOrNull((t) => t.id == id);
    if (b != null) b.fontColor.value = color;
  }

  void selectProductColor(int index) {
    if (index < 0 || index >= productColors.length) return;
    selectedProductColorIndex.value = index;
  }

  void addStickerFromEmoji(String emoji) {
    final id = 'st_${DateTime.now().microsecondsSinceEpoch}';
    final sticker = StickerModel(
      id: id,
      source: StickerSource.art,
      data: emoji,
    );
    stickers.add(sticker);
    stickerActiveIds[currentSide.value]?.value = id;
  }

  void addStickerFromImagePath(String path) {
    final id = 'img_${DateTime.now().microsecondsSinceEpoch}';
    final sticker = StickerModel(
      id: id,
      source: StickerSource.image,
      data: path,
      initialScale: 0.8,
    );
    stickers.add(sticker);
    stickerActiveIds[currentSide.value]?.value = id;
  }

  Future<void> addStickerFromGallery() async {
    try {
      final xfile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 85);
      if (xfile != null) addStickerFromImagePath(xfile.path);
    } catch (_) {
      // ignore
    }
  }

  void removeSticker(String id) {
    final list = stickers;
    final idx = list.indexWhere((s) => s.id == id);
    if (idx != -1) {
      list.removeAt(idx);
      if (activeStickerId.value == id) {
        activeStickerId.value = null;
      }
    }
  }

  void moveStickerByDelta(String id, Offset deltaPx, Size canvasSize) {
    final sticker = stickers.firstWhereOrNull((s) => s.id == id);
    if (sticker == null) return;
    if (canvasSize.width <= 0 || canvasSize.height <= 0) return;
    final dx = deltaPx.dx / canvasSize.width;
    final dy = deltaPx.dy / canvasSize.height;
    sticker.position.value = Offset(
      (sticker.position.value.dx + dx).clamp(0.0, 1.0),
      (sticker.position.value.dy + dy).clamp(0.0, 1.0),
    );
  }

  void scaleRotateSticker(String id, double scaleDelta, double rotationDelta) {
    final sticker = stickers.firstWhereOrNull((s) => s.id == id);
    if (sticker == null) return;
    final nextScale = (sticker.scale.value * scaleDelta).clamp(0.4, 3.0);
    sticker.scale.value = nextScale;
    sticker.rotation.value =
        (sticker.rotation.value + rotationDelta) % (2 * 3.141592653589793);
  }

  void setActiveSticker(String? id) {
    stickerActiveIds[currentSide.value]?.value = id;
  }

  void beginStickerTransform(String id) {
    final sticker = stickers.firstWhereOrNull((s) => s.id == id);
    if (sticker == null) return;
    _transformingStickerId = id;
    _transformBaseScale = sticker.scale.value;
    _transformBaseRotation = sticker.rotation.value;
  }

  void updateStickerTransform(
      String id, double scaleFactor, double rotationDelta) {
    final sticker = stickers.firstWhereOrNull((s) => s.id == id);
    if (sticker == null) return;
    final baseScale = (_transformingStickerId == id
            ? _transformBaseScale
            : sticker.scale.value) ??
        sticker.scale.value;
    final baseRotation = (_transformingStickerId == id
            ? _transformBaseRotation
            : sticker.rotation.value) ??
        sticker.rotation.value;
    sticker.scale.value = (baseScale * scaleFactor).clamp(0.4, 3.5);
    sticker.rotation.value = baseRotation + rotationDelta;
  }

  void endStickerTransform() {
    _transformingStickerId = null;
    _transformBaseScale = null;
    _transformBaseRotation = null;
  }

  void setActiveStickerScale(double scale) {
    final sticker = getActiveSticker();
    if (sticker == null) return;
    sticker.scale.value = scale.clamp(0.3, 3.5);
  }

  void nudgeActiveStickerScale(double delta) {
    final sticker = getActiveSticker();
    if (sticker == null) return;
    setActiveStickerScale(sticker.scale.value + delta);
  }

  void applyStickerGesture(
    String id, {
    Offset translationDelta = Offset.zero,
    double scaleDelta = 1.0,
    double rotationDelta = 0.0,
    required Size canvasSize,
  }) {
    if (translationDelta != Offset.zero) {
      moveStickerByDelta(id, translationDelta, canvasSize);
    }
    if ((scaleDelta - 1.0).abs() > 1e-4 || rotationDelta.abs() > 1e-4) {
      scaleRotateSticker(id, scaleDelta, rotationDelta);
    }
  }

  // capture the preview RepaintBoundary and write PNG to gallery, returns saved path or null
  /// Capture the preview RepaintBoundary and return PNG bytes.
  /// Also stores the bytes into [exportedImageBytes] and [exportedImageBase64].
  Future<Uint8List?> exportPreviewAsPngBytes() async {
    if (isExporting.value) return null;
    isExporting.value = true;
    // allow one frame for UI to rebuild (hide selection borders, etc.)
    try {
      await Future.delayed(const Duration(milliseconds: 80));
    } catch (_) {}
    try {
      final ctx = previewKey.currentContext;
      if (ctx == null) return null;
      final boundary = ctx.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;
      final Uint8List bytes = byteData.buffer.asUint8List();

      exportedImageBytes.value = bytes;
      exportedImageBase64.value = base64Encode(bytes);

      return bytes;
    } catch (_) {
      return null;
    } finally {
      isExporting.value = false;
    }
  }

  /// Save bytes to a temporary file and return the file path.
  Future<String?> saveBytesToTempFile(Uint8List bytes,
      {String? filename}) async {
    try {
      final dir = await getTemporaryDirectory();
      final name =
          filename ?? 'design_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  /// Export preview, save to temp and open the file with the platform default app.
  /// Returns the saved file path on success, otherwise null.
  Future<String?> exportAndSaveToTempAndOpen() async {
    final bytes = await exportPreviewAsPngBytes();
    if (bytes == null) return null;
    final path = await saveBytesToTempFile(bytes);
    if (path == null) return null;
    try {
      await OpenFilex.open(path);
    } catch (_) {
      // ignore open errors
    }
    return path;
  }

  /// Request required permission and save the exported image to the device gallery.
  /// Returns a map: { 'ok': bool, 'path': String?, 'error': String? }
  Future<Map<String, dynamic>> savePreviewToGallery() async {
    debugPrint('savePreviewToGallery: starting');
    final bytes = await exportPreviewAsPngBytes();
    if (bytes == null) {
      debugPrint('savePreviewToGallery: export failed (no bytes)');
      return {'ok': false, 'error': 'export_failed'};
    }
    debugPrint(
        'savePreviewToGallery: exported bytes size=${bytes.lengthInBytes}');

    bool hasAccess = true;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          hasAccess = await Gal.requestAccess();
        }
      }
    } catch (e) {
      debugPrint('savePreviewToGallery: access check error $e');
      hasAccess = false;
    }

    if (!hasAccess) {
      debugPrint('savePreviewToGallery: permission denied - will attempt temp fallback');
      final tempPath = await saveBytesToTempFile(bytes);
      if (tempPath != null) {
        try {
          await OpenFilex.open(tempPath);
        } catch (_) {}
        return {'ok': true, 'path': tempPath, 'warning': 'permission_denied'};
      }
      return {'ok': false, 'error': 'permission_denied'};
    }

    try {
      await Gal.putImageBytes(
        bytes,
        name: 'design_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      debugPrint('savePreviewToGallery: saved via Gal');
      return {'ok': true, 'path': 'gallery'};
    } catch (e) {
      debugPrint('savePreviewToGallery Gal error: $e');
      final tempPath = await saveBytesToTempFile(bytes);
      if (tempPath != null) {
        try {
          await OpenFilex.open(tempPath);
        } catch (_) {}
        debugPrint(
            'savePreviewToGallery: exception fallback saved to temp: $tempPath');
        return {'ok': true, 'path': tempPath};
      }
      debugPrint('savePreviewToGallery: exception and no fallback path');
      return {'ok': false, 'error': e.toString()};
    }
  }

  /// Prepare the edited image for API posting: exports and stores bytes/base64 in Rx vars.
  /// Returns true on success.
  Future<bool> prepareOrderPayload() async {
    final bytes = await exportPreviewAsPngBytes();
    return bytes != null;
  }

  @override
  void onClose() {
    frontState.dispose();
    backState.dispose();
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
