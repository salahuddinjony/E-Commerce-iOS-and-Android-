import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
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

  static const Map<String, Map<String, List<String>>> _artLibrary = {
    'Emoji': {
      'Smileys': ['😀', '😁', '😂', '🤣', '😊', '😍', '🤩', '🤓', '🥳', '🤠'],
      'Hands': ['👍', '👏', '🙏', '🤘', '👌', '🤙', '✋', '🤝'],
      'Food & Drinks': ['🍔', '🍕', '🌮', '🍩', '🍪', '🍓', '🍉', '🥤', '☕️', '🍹'],
      'Animals': ['🐶', '🐱', '🦊', '🐻', '🐼', '🐨', '🐯', '🐸', '🐵', '🦁'],
    },
    'Shapes & Symbols': {
      'Basics': ['★', '☆', '✦', '✶', '✿', '❀', '❖', '✪', '✳', '✴'],
      'Lines': ['➤', '➢', '➣', '➷', '➺', '➻', '➼'],
      'Badges': ['⬡', '⬢', '⬣', '⬤', '⬟', '⬢', '⬢'],
    },
    'Sports & Games': {
      'Sports': ['⚽️', '🏀', '🏈', '⚾️', '🎾', '🏐', '🥎', '🏉', '🏓', '🥊'],
      'Gaming': ['🎮', '🕹️', '👾', '🎲', '♟️', '🃏', '♠️', '♥️', '♦️', '♣️'],
    },
    'Letters & Numbers': {
      'Letters': ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'],
      'Numbers': ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    },
    'Animals': {
      'Land': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'],
      'Sea': ['🐳', '🐬', '🦈', '🐟', '🐠', '🐙', '🦑'],
      'Birds': ['🦅', '🦉', '🦜', '🦢', '🦩', '🐦'],
    },
    'Mascots': {
      'Mythic': ['🐉', '🐲', '🦄', '👽', '🤖', '🧙‍♂️'],
      'Fun': ['🤠', '🤡', '👻', '🎅', '🦸‍♂️', '🦹‍♀️'],
    },
    'Nature': {
      'Plants': ['🌿', '🍃', '🍁', '🌸', '🌼', '🌻', '🌴', '🌵'],
      'Weather': ['☀️', '🌤', '⛅️', '🌦', '🌧', '⛈', '🌈', '❄️'],
    },
    'America': {
      'Symbols': ['🇺🇸', '🗽', '🦅', '🎆', '🥇', '🏈', '🎖', '🚀'],
    },
  };

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
            backgroundColor: Colors.white,
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
                        final activeBox = c.getActiveTextBox();
                        return ListTile(
                          trailing: activeBox?.fontFamily.value == f
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          title: Text(f, style: _safeGoogleFontStyle(f, fontSize: 18)),
                          subtitle: Text('The quick brown fox', style: _safeGoogleFontStyle(f, fontSize: 14, color: Colors.grey[600])),
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

  Future<void> _showProductColorPicker(BuildContext context, CustomDesignController c) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setState) {
          int previewIndex = c.selectedProductColorIndex.value;
          final options = c.productColors;
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 40,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Product colors', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(builder: (context, constraints) {
                    final maxWidth = constraints.maxWidth;
                    final crossAxisCount = maxWidth > 520 ? 8 : maxWidth > 420 ? 6 : 4;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: options.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (_, index) {
                        final option = options[index];
                        final bool isSelected = previewIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() => previewIndex = index);
                            c.selectProductColor(index);
                            Navigator.of(ctx).pop();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? Colors.blueAccent : Colors.black26,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: option.swatch,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  option.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.blueAccent : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    final option = c.productColors[c.selectedProductColorIndex.value];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sizes available in ${option.name}:',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: option.sizes
                              .map(
                                (size) => Chip(
                                  label: Text(size),
                                  backgroundColor: Colors.grey[200],
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _showArtPicker(BuildContext context, CustomDesignController c) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (ctx) {
        String selectedCategory = _artLibrary.keys.first;
        String selectedSubcategory = _artLibrary[selectedCategory]!.keys.first;
        return StatefulBuilder(builder: (context, setState) {
          final subcategories = _artLibrary[selectedCategory]!;
          final items = subcategories[selectedSubcategory] ?? const [];

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add art',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _artLibrary.length,
                      itemBuilder: (_, index) {
                        final key = _artLibrary.keys.elementAt(index);
                        final isActive = key == selectedCategory;
                        return ChoiceChip(
                          label: Text(key),
                          selected: isActive,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = key;
                              selectedSubcategory = _artLibrary[key]!.keys.first;
                            });
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: subcategories.length,
                      itemBuilder: (_, index) {
                        final key = subcategories.keys.elementAt(index);
                        final isActive = key == selectedSubcategory;
                        return ChoiceChip(
                          label: Text(key),
                          selected: isActive,
                          onSelected: (_) => setState(() => selectedSubcategory = key),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 420 ? 6 : 4;
                        return GridView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (_, index) {
                            final art = items[index];
                            return InkWell(
                              onTap: () => Navigator.of(ctx).pop(art),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Center(
                                  child: Text(
                                    art,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
    if (result != null && result.isNotEmpty) {
      c.addStickerFromEmoji(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CustomDesignController c = Get.find();
    return Card(
      color: AppColors.brightCyan,
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
                Obx(() {
                  final side = c.currentSide.value;
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _SideToggleChip(
                          label: 'Front',
                          icon: Icons.checkroom_outlined,
                          isActive: side == DesignSide.front,
                          onTap: () => c.switchSide(DesignSide.front),
                        ),
                        const SizedBox(width: 4),
                        _SideToggleChip(
                          label: 'Back',
                          icon: Icons.dry_cleaning_outlined,
                          isActive: side == DesignSide.back,
                          onTap: () => c.switchSide(DesignSide.back),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(width: 8),

                Obx(() {
                  final option = c.productColors[c.selectedProductColorIndex.value];
                  return TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _showProductColorPicker(context, c),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: option.swatch,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black26),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  );
                }),

                const SizedBox(width: 8),

                // Add text box button
                IconButton(
                  color: Colors.white,
                  onPressed: () => c.addTextBox(text: ''),
                  icon: const Icon(Icons.add_box_outlined),
                  tooltip: 'Add text box',
                ),

                const SizedBox(width: 6),

                IconButton(
                  color: Colors.white,
                  onPressed: () => _showArtPicker(context, c),
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  tooltip: 'Add art',
                ),

                IconButton(
                  color: Colors.white,
                  onPressed: c.addStickerFromGallery,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  tooltip: 'Add image',
                ),

                const SizedBox(width: 6),

                // When a box is selected show inline editors
                Obx(() {
                  final activeId = c.activeTextId.value;
                  if (activeId == null) return const SizedBox.shrink();

                  final box = c.getActiveTextBox();
                  if (box == null) return const SizedBox.shrink();

                  return Row(
                    children: [
                      // quick inline text edit (small)
                        SizedBox(
                        width: dropdownW,
                        child: TextField(
                          maxLines: 1,
                          style: const TextStyle(color: Colors.white),
                          controller: box.controller,
                          decoration: const InputDecoration(
                          hintText: 'Edit text',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          ),
                          onChanged: (_) => box.controller.text = box.controller.text,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // font picker for active
                      IconButton(
                        color: Colors.white,
                        onPressed: () => _showFontPicker(context, c),
                        icon: const Icon(Icons.font_download_outlined),
                        tooltip: 'Choose font',
                      ),

                      // color plate button
                      IconButton(
                        color: Colors.white,
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
                      IconButton(
                        color: Colors.white,
                        onPressed: c.decreaseFontForActive,
                        icon: const Icon(Icons.remove),
                      ),
                      Obx(() => Text(
                            '${box.fontSize.value.toInt()}',
                            style: const TextStyle(color: Colors.white),
                          )),
                      IconButton(
                        onPressed: c.increaseFontForActive,
                        icon: const Icon(Icons.add),
                        color: Colors.white,),
                      // bold / italic / delete
                      IconButton(
                        color: Colors.white,
                        onPressed: c.toggleBoldForActive,
                        icon: const Icon(Icons.format_bold),
                      ),
                      IconButton(
                        color: Colors.white,
                        onPressed: c.toggleItalicForActive,
                        icon: const Icon(Icons.format_italic),
                      ),
                      IconButton(
                        color: Colors.white,
                        onPressed: () {
                          c.removeTextBox(activeId);
                        },
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                      ),
                    ],
                  );
                }),

                const SizedBox(width: 8),

                Obx(() {
                  final sticker = c.getActiveSticker();
                  if (sticker == null) return const SizedBox.shrink();
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.emoji_emotions, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              sticker.source == StickerSource.art ? 'Art selected' : 'Image selected',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          IconButton(
                            color: Colors.white,
                            tooltip: 'Smaller',
                            onPressed: () => c.nudgeActiveStickerScale(-0.1),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          SizedBox(
                            width: 140,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white54,
                                thumbColor: Colors.white,
                              ),
                              child: Slider(
                                min: 0.3,
                                max: 3.5,
                                value: sticker.scale.value.clamp(0.3, 3.5),
                                onChanged: c.setActiveStickerScale,
                              ),
                            ),
                          ),
                          IconButton(
                            color: Colors.white,
                            tooltip: 'Larger',
                            onPressed: () => c.nudgeActiveStickerScale(0.1),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                      IconButton(
                        color: Colors.white,
                        tooltip: 'Delete sticker',
                        onPressed: () {
                          c.removeSticker(sticker.id);
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                    ],
                  );
                }),

                const SizedBox(width: 8),

                // If nothing selected show general controls (or keep minimal)
                Obx(() {
                  if (c.activeTextId.value == null) {
                    return Row(
                      children: [
                        TextButton.icon(
                          style: TextButton.styleFrom(foregroundColor: Colors.white),
                          onPressed: () => c.addTextBox(text: ''),
                          icon: const Icon(Icons.text_fields),
                          label: const Text('Add text'),
                        ),
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

class _SideToggleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SideToggleChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.brightCyan : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.brightCyan : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}