import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DesignSide { front, back }

enum StickerSource { art, image }


// Model for a text box in the design
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
  final Rx<Color> fontColor;

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


// Model for a sticker in the design
class StickerModel {
  final String id;
  final StickerSource source;
  final String data; // emoji for art, file path for image
  final Rx<Offset> position;
  final RxDouble scale;
  final RxDouble rotation;
  final Rx<Color> color; // Color for icons/graphics

  StickerModel({
    required this.id,
    required this.source,
    required this.data,
    Offset initialPos = const Offset(0.5, 0.5),
    double initialScale = 1.0,
    double initialRotation = 0.0,
    Color initialColor = Colors.black,
  })  : position = Rx<Offset>(initialPos),
        scale = RxDouble(initialScale),
        rotation = RxDouble(initialRotation),
        color = Rx<Color>(initialColor);
}


// Model for product mockup assets
class MockupAssets {
  final String front;
  final String back;

  const MockupAssets({
    required this.front,
    required this.back,
  });
}


// State model for a design side (front or back)
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
