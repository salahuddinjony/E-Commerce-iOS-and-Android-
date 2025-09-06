mixin class ProductColorMixin {
  final Map<String, String> colors = {
    "Black": "#000000",
    "White": "#FFFFFF",
    "Red": "#FF0000",
    "Green": "#00FF00",
    "Blue": "#0000FF",
    "Yellow": "#FFFF00",
    "Pink": "#FFC0CB",
    "Purple": "#800080",
    "Orange": "#FFA500",
    "Gray": "#808080",
    "Brown": "#A52A2A",
    "Cyan": "#00FFFF",
    "Magenta": "#FF00FF",
    "Lime": "#00FF00",
    "Maroon": "#800000",
    "Navy": "#000080",
    "Olive": "#808000",
    "Teal": "#008080",
    "Silver": "#C0C0C0",
  };

  String getColorName({required String hexCode}) {
    try {
      return colors.entries
          .firstWhere((entry) => entry.value.toLowerCase() == hexCode.toLowerCase())
          .key;
    } catch (e) {
      return hexCode; // fallback if color not found
    }
  }
}
