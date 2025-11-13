import 'dart:convert';
import 'package:http/http.dart' as http;

class IconService {
  static const String _baseUrl = 'https://api.iconify.design';
  
  /// Popular icon sets to choose from
  static const List<String> popularIconSets = [
    'mdi',           // Material Design Icons
    'carbon',        // Carbon Design System
    'heroicons',     // Heroicons
    'fa6-solid',     // Font Awesome 6 Solid
    'fa6-regular',   // Font Awesome 6 Regular
    'fa6-brands',    // Font Awesome 6 Brands
    'fluent',        // Fluent UI Icons
    'ant-design',    // Ant Design Icons
    'bootstrap',     // Bootstrap Icons
    'feather',       // Feather Icons
    'tabler',        // Tabler Icons
    'simple-icons',  // Simple Icons
  ];

  /// Search for icons by query
  static Future<List<IconResult>> searchIcons(String query, {int limit = 50}) async {
    try {
      final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
        'query': query,
        'limit': limit.toString(),
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final icons = data['icons'] as List?;
        
        if (icons != null) {
          return icons.take(limit).map((icon) {
            final iconStr = icon.toString();
            final parts = iconStr.split(':');
            if (parts.length == 2) {
              return IconResult(
                iconSet: parts[0],
                iconName: parts[1],
                fullName: iconStr,
              );
            }
            return null;
          }).whereType<IconResult>().toList();
        }
      }
      return [];
    } catch (e) {
      print('Error searching icons: $e');
      return [];
    }
  }

  /// Get icons from a specific icon set
  static Future<List<IconResult>> getIconsFromSet(String iconSet, {int limit = 100}) async {
    try {
      final uri = Uri.parse('$_baseUrl/collection').replace(queryParameters: {
        'prefix': iconSet,
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Try different response structures
        List<String> iconNames = [];
        
        // Check for uncategorized icons
        if (data['uncategorized'] != null) {
          final uncategorized = data['uncategorized'] as List?;
          if (uncategorized != null) {
            iconNames.addAll(uncategorized.take(limit).map((e) => e.toString()));
          }
        }
        
        // Check for categorized icons
        if (data['categories'] != null) {
          final categories = data['categories'] as Map?;
          if (categories != null) {
            categories.forEach((key, value) {
              if (value is List && iconNames.length < limit) {
                for (var icon in value) {
                  if (iconNames.length >= limit) break;
                  iconNames.add(icon.toString());
                }
              }
            });
          }
        }
        
        // If still empty, try direct icon list
        if (iconNames.isEmpty && data['icons'] != null) {
          final icons = data['icons'] as List?;
          if (icons != null) {
            iconNames.addAll(icons.take(limit).map((e) => e.toString()));
          }
        }
        
        return iconNames.map((iconName) {
          return IconResult(
            iconSet: iconSet,
            iconName: iconName,
            fullName: '$iconSet:$iconName',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error getting icons from set: $e');
      return [];
    }
  }

  /// Get icon URL (SVG format) - using Iconify CDN
  static String getIconUrl(String iconSet, String iconName, {int width = 48, int height = 48}) {
    // Use Iconify CDN with proper format (no color - will be applied via ColorFilter in Flutter)
    return 'https://api.iconify.design/$iconSet:$iconName.svg?width=$width&height=$height';
  }

  /// Get icon URL from full name (e.g., "mdi:home")
  static String getIconUrlFromFullName(String fullName, {int width = 48, int height = 48}) {
    final parts = fullName.split(':');
    if (parts.length == 2) {
      return getIconUrl(parts[0], parts[1], width: width, height: height);
    }
    return '';
  }
}

class IconResult {
  final String iconSet;
  final String iconName;
  final String fullName;

  IconResult({
    required this.iconSet,
    required this.iconName,
    required this.fullName,
  });

  String get iconUrl => IconService.getIconUrl(iconSet, iconName, width: 48, height: 48);
}

