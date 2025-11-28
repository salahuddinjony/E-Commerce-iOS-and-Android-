import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local/app/services/icon_service.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/user_home/custom_design/tools_model.dart/tools_models.dart';
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

  // Extended color palette
  static const List<Color> _colorOptions = [
    // Basic colors
    Colors.white,
    Colors.black,
    Colors.grey,
    // Reds & Pinks
    Colors.red,
    Color(0xFFB71C1C), // Dark red
    Color(0xFFE91E63), // Pink
    Colors.pink,
    Color(0xFFF06292), // Light pink
    Color(0xFFEC407A), // Medium pink
    // Oranges & Yellows
    Colors.orange,
    Color(0xFFFF6F00), // Dark orange
    Color(0xFFFFA726), // Light orange
    Colors.amber,
    Colors.yellow,
    Color(0xFFFFD54F), // Light yellow
    Color(0xFFFFEB3B), // Bright yellow
    // Greens
    Colors.green,
    Color(0xFF1B5E20), // Dark green
    Color(0xFF4CAF50), // Medium green
    Color(0xFF66BB6A), // Light green
    Color(0xFF81C784), // Lighter green
    Color(0xFF8BC34A), // Lime green
    // Blues
    Colors.blue,
    Color(0xFF0D47A1), // Dark blue
    Color(0xFF1976D2), // Medium blue
    Color(0xFF2196F3), // Light blue
    Color(0xFF42A5F5), // Lighter blue
    Color(0xFF64B5F6), // Sky blue
    Color(0xFF03A9F4), // Cyan blue
    // Teals & Cyans
    Colors.teal,
    Color(0xFF00695C), // Dark teal
    Color(0xFF00897B), // Medium teal
    Color(0xFF26A69A), // Light teal
    Color(0xFF00BCD4), // Cyan
    // Purples & Violets
    Colors.purple,
    Color(0xFF4A148C), // Dark purple
    Color(0xFF6A1B9A), // Medium purple
    Color(0xFF7B1FA2), // Purple
    Color(0xFF9C27B0), // Light purple
    Color(0xFFBA68C8), // Lighter purple
    Colors.indigo,
    Color(0xFF1A237E), // Dark indigo
    Color(0xFF3F51B5), // Medium indigo
    Color(0xFF5C6BC0), // Light indigo
    // Browns
    Colors.brown,
    Color(0xFF3E2723), // Dark brown
    Color(0xFF5D4037), // Medium brown
    Color(0xFF8D6E63), // Light brown
    // Special colors
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue grey
    Color(0xFF37474F), // Dark blue grey
    Color(0xFF263238), // Almost black
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

  Future<void> _showColorPicker(BuildContext context, CustomDesignController c, Color initial, {bool isForSticker = false}) async {
    Color pickerColor = initial;
    Color currentColor = initial;
    
    final picked = await showDialog<Color>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(isForSticker ? 'Icon color' : 'Text color'),
              content: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Preset colors grid
                      const Text(
                        'Preset Colors',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _colorOptions.length,
                        itemBuilder: (context, index) {
                          final col = _colorOptions[index];
                          final isSelected = col.value == pickerColor.value;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                pickerColor = col;
                                currentColor = col;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: col,
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.black26,
                                  width: isSelected ? 3 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: Colors.blue.withValues(alpha: 0.3),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Custom color picker using HSV sliders
                      const Text(
                        'Custom Color',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      // Hue slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hue', style: TextStyle(fontSize: 12)),
                          Slider(
                            value: HSVColor.fromColor(pickerColor).hue,
                            min: 0,
                            max: 360,
                            divisions: 360,
                            onChanged: (value) {
                              final hsv = HSVColor.fromColor(pickerColor);
                              setState(() {
                                pickerColor = HSVColor.fromAHSV(1.0, value, hsv.saturation, hsv.value).toColor();
                                currentColor = pickerColor;
                              });
                            },
                            activeColor: pickerColor,
                          ),
                        ],
                      ),
                      // Saturation slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Saturation', style: TextStyle(fontSize: 12)),
                          Slider(
                            value: HSVColor.fromColor(pickerColor).saturation,
                            min: 0,
                            max: 1,
                            divisions: 100,
                            onChanged: (value) {
                              final hsv = HSVColor.fromColor(pickerColor);
                              setState(() {
                                pickerColor = HSVColor.fromAHSV(1.0, hsv.hue, value, hsv.value).toColor();
                                currentColor = pickerColor;
                              });
                            },
                            activeColor: pickerColor,
                          ),
                        ],
                      ),
                      // Value/Brightness slider
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Brightness', style: TextStyle(fontSize: 12)),
                          Slider(
                            value: HSVColor.fromColor(pickerColor).value,
                            min: 0,
                            max: 1,
                            divisions: 100,
                            onChanged: (value) {
                              final hsv = HSVColor.fromColor(pickerColor);
                              setState(() {
                                pickerColor = HSVColor.fromAHSV(1.0, hsv.hue, hsv.saturation, value).toColor();
                                currentColor = pickerColor;
                              });
                            },
                            activeColor: pickerColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Color preview
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: pickerColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Center(
                          child: Text(
                            '#${pickerColor.value.toRadixString(16).substring(2).toUpperCase()}',
                            style: TextStyle(
                              color: pickerColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(currentColor),
                  child: const Text('Select'),
                ),
              ],
            );
          },
        );
      },
    );
    if (picked != null) {
      if (isForSticker) {
        c.setColorForActiveSticker(picked);
      } else {
        c.setColorForActive(picked);
      }
    }
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
                              mainAxisSize: MainAxisSize.min,
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
                                const SizedBox(height: 4),
                                Flexible(
                                  child: Text(
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
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) {
        String selectedCategory = 'Icons'; // Start with Icons category
        String selectedSubcategory = '';
        String searchQuery = '';
        final searchController = TextEditingController();
        List<IconResult> iconResults = [];
        bool isLoadingIcons = false;
        String? selectedIconSet;

        return StatefulBuilder(builder: (context, setState) {
          final isIconsCategory = selectedCategory == 'Icons';
          final subcategories = isIconsCategory 
              ? <String, List<String>>{} 
              : _artLibrary[selectedCategory] ?? {};
          final items = isIconsCategory 
              ? <String>[] 
              : (subcategories[selectedSubcategory] ?? const []);

          // Load icons when Icons category is selected
          void loadIcons() async {
            if (isIconsCategory && !isLoadingIcons) {
              setState(() => isLoadingIcons = true);
              List<IconResult> results = [];
              
              if (searchQuery.isNotEmpty) {
                results = await IconService.searchIcons(searchQuery, limit: 50);
              } else if (selectedIconSet != null) {
                results = await IconService.getIconsFromSet(selectedIconSet!, limit: 50);
              } else {
                // Load popular icons from multiple sets
                for (final iconSet in IconService.popularIconSets.take(3)) {
                  final icons = await IconService.getIconsFromSet(iconSet, limit: 20);
                  results.addAll(icons);
                  if (results.length >= 50) break;
                }
              }
              
              setState(() {
                iconResults = results;
                isLoadingIcons = false;
              });
            }
          }

          // Auto-load icons when category changes to Icons
          if (isIconsCategory && iconResults.isEmpty && !isLoadingIcons) {
            Future.microtask(loadIcons);
          }

          return SafeArea(
            top: true,
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: MediaQuery.of(ctx).padding.top > 0 ? 16 : 24,
                bottom: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add art & icons',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Category selector
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _artLibrary.length + 1, // +1 for Icons
                      itemBuilder: (_, index) {
                        final key = index == 0 
                            ? 'Icons' 
                            : _artLibrary.keys.elementAt(index - 1);
                        final isActive = key == selectedCategory;
                        return ChoiceChip(
                          label: Text(key),
                          selected: isActive,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = key;
                              if (key != 'Icons') {
                                selectedSubcategory = _artLibrary[key]!.keys.first;
                                iconResults = [];
                                selectedIconSet = null;
                                searchQuery = '';
                                searchController.clear();
                              }
                            });
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                    ),
                  ),
                  // Search bar for Icons
                  if (isIconsCategory) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search icons (e.g., home, heart, star)',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    searchQuery = '';
                                    searchController.clear();
                                    selectedIconSet = null;
                                    iconResults = [];
                                  });
                                  loadIcons();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => searchQuery = value);
                      },
                      onSubmitted: (_) => loadIcons(),
                    ),
                    const SizedBox(height: 8),
                    // Icon set selector
                    if (searchQuery.isEmpty)
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: IconService.popularIconSets.length,
                          itemBuilder: (_, index) {
                            final iconSet = IconService.popularIconSets[index];
                            final isActive = selectedIconSet == iconSet;
                            return ChoiceChip(
                              label: Text(iconSet),
                              selected: isActive,
                              onSelected: (_) {
                                setState(() {
                                  selectedIconSet = isActive ? null : iconSet;
                                  iconResults = [];
                                });
                                loadIcons();
                              },
                            );
                          },
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                        ),
                      ),
                  ] else ...[
                    // Subcategory selector for emojis
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
                  ],
                  const SizedBox(height: 16),
                  Flexible(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 420 ? 6 : 4;
                        
                        if (isIconsCategory) {
                          if (isLoadingIcons) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          
                          if (iconResults.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Text(
                                  searchQuery.isEmpty 
                                      ? 'Select an icon set or search for icons'
                                      : 'No icons found. Try a different search.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            );
                          }
                          
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: iconResults.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (_, index) {
                              final icon = iconResults[index];
                              return InkWell(
                                onTap: () => Navigator.of(ctx).pop({
                                  'type': 'icon',
                                  'url': icon.iconUrl,
                                  'fullName': icon.fullName,
                                }),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.network(
                                      icon.iconUrl,
                                      width: 32,
                                      height: 32,
                                      placeholderBuilder: (context) => const Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                      ),
                                      semanticsLabel: icon.iconName,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        
                        // Emoji grid
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
                              onTap: () => Navigator.of(ctx).pop({
                                'type': 'emoji',
                                'data': art,
                              }),
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
    
    if (result != null) {
      if (result['type'] == 'icon') {
        // Add icon as image sticker
        final iconUrl = result['url'] as String;
        c.addStickerFromImageUrl(iconUrl);
      } else if (result['type'] == 'emoji') {
        // Add emoji as before
        final emoji = result['data'] as String;
        c.addStickerFromEmoji(emoji);
      }
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
                      color: Colors.white.withValues(alpha: .12),
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
                      backgroundColor: Colors.white.withValues(alpha: .12),
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
                  icon: const Icon(Icons.auto_awesome_outlined),
                  tooltip: 'Add graphics & icons',
                ),

                IconButton(
                  color: Colors.white,
                  onPressed: c.addStickerFromGallery,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  tooltip: 'Add image',
                ),

                const SizedBox(width: 6),

                // Reset button
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Reset Design'),
                        content: const Text(
                          'Are you sure you want to reset everything? This will remove all text, graphics, and icons from both front and back sides.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              c.resetAll();
                              Navigator.of(ctx).pop();
                            },
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_outlined),
                  tooltip: 'Reset all',
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
                        onPressed: () => _showColorPicker(context, c, box.fontColor.value, isForSticker: false),
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
                          color: Colors.white.withValues(alpha: .15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              sticker.source == StickerSource.art 
                                  ? Icons.emoji_emotions 
                                  : Icons.auto_awesome,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              sticker.source == StickerSource.art ? 'Art selected' : 'Graphics selected',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Color picker for icons (only show for API icons, not uploaded images)
                      if (sticker.source == StickerSource.image && 
                          (sticker.data.startsWith('http://') || sticker.data.startsWith('https://')))
                        Obx(() => IconButton(
                          color: Colors.white,
                          onPressed: () => _showColorPicker(context, c, sticker.color.value, isForSticker: true),
                          icon: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: sticker.color.value,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black26),
                            ),
                          ),
                          tooltip: 'Icon color',
                        )),
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
                    color: Colors.black.withValues(alpha: 0.08),
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