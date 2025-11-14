import 'package:flutter/material.dart';

const List<String> productSizes = [
  'XS',
  'S',
  'M',
  'L',
  'XL',
  '2XL',
  '3XL',
];

class ProductColorOption {
  final String name;
  final Color swatch;
  final List<String> sizes;

  const ProductColorOption({
    required this.name,
    required this.swatch,
    this.sizes = productSizes,
  });
}

class ColorLibrary {
  static const productColors = [
    ProductColorOption(name: 'Classic White', swatch: Colors.white),
    ProductColorOption(name: 'Heather Heliconia', swatch: Color(0xFFF06292)),
    ProductColorOption(name: 'Steel Grey', swatch: Color(0xFF9E9E9E)),
    ProductColorOption(name: 'Ocean Blue', swatch: Color(0xFF42A5F5)),
    ProductColorOption(name: 'Sunset Orange', swatch: Color(0xFFFFA726)),
    ProductColorOption(name: 'Forest Green', swatch: Color(0xFF66BB6A)),
    ProductColorOption(name: 'Jet Black', swatch: Colors.black),
    ProductColorOption(name: 'Ivory', swatch: Color(0xFFF5F5DC)),
    ProductColorOption(name: 'Royal Blue', swatch: Color(0xFF1565C0)),
    ProductColorOption(name: 'Cardinal Red', swatch: Color(0xFFB71C1C)),
    ProductColorOption(name: 'Charcoal', swatch: Color(0xFF424242)),
    ProductColorOption(name: 'Mint', swatch: Color(0xFFB2DFDB)),
    ProductColorOption(name: 'Banana', swatch: Color(0xFFFFF59D)),
    ProductColorOption(name: 'Lavender', swatch: Color(0xFFB39DDB)),
    ProductColorOption(name: 'Deep Purple', swatch: Color(0xFF512DA8)),
    ProductColorOption(name: 'Brick', swatch: Color(0xFF8D4A43)),
    ProductColorOption(name: 'Sage', swatch: Color(0xFFA5B69C)),
    ProductColorOption(name: 'Sky', swatch: Color(0xFF90CAF9)),
    ProductColorOption(name: 'Coral', swatch: Color(0xFFFF8A80)),
    ProductColorOption(name: 'Sand', swatch: Color(0xFFE0C097)),
    ProductColorOption(name: 'Chocolate', swatch: Color(0xFF6D4C41)),
    ProductColorOption(name: 'Maroon', swatch: Color(0xFF500000)),
    ProductColorOption(name: 'Teal', swatch: Color(0xFF00897B)),
    ProductColorOption(name: 'Navy', swatch: Color(0xFF0D47A1)),
    ProductColorOption(name: 'Peach', swatch: Color(0xFFFFCCBC)),
    ProductColorOption(name: 'Mustard', swatch: Color(0xFFE1AD01)),
    ProductColorOption(name: 'Lime', swatch: Color(0xFFCDDC39)),
    ProductColorOption(name: 'Olive', swatch: Color(0xFF6B8E23)),
    ProductColorOption(name: 'Berry', swatch: Color(0xFFAD1457)),
    ProductColorOption(name: 'Slate', swatch: Color(0xFF607D8B)),
    ProductColorOption(name: 'Copper', swatch: Color(0xFFB87333)),
    ProductColorOption(name: 'Blush', swatch: Color(0xFFF8BBD0)),
    ProductColorOption(name: 'Denim', swatch: Color(0xFF5479A7)),
    ProductColorOption(name: 'Aqua', swatch: Color(0xFF4DD0E1)),
    ProductColorOption(name: 'Plum', swatch: Color(0xFF6A1B9A)),
    ProductColorOption(name: 'Canary', swatch: Color(0xFFFFF176)),
    ProductColorOption(name: 'Ash', swatch: Color(0xFFD7CCC8)),
  ];
}
