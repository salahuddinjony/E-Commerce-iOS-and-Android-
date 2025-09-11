import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

mixin class MixinExtendOrder {
  final RxBool expanded = false.obs;
  void toggle() => expanded.value = !expanded.value;
  // --- Local helpers (safe, null-friendly) ---
  dynamic field(dynamic src, String name) {
    if (src == null) return null;
    if (src is Map) return src[name];
    try {
      final dyn = src as dynamic;
      // common property names
      switch (name) {
        case 'lastDate':
          return dyn.lastDate;
        case 'newDate':
          return dyn.newDate;
        case 'reason':
          return dyn.reason;
        case 'status':
          return dyn.status;
        default:
          try {
            return dyn[name];
          } catch (_) {
            return null;
          }
      }
    } catch (_) {
      return null;
    }
  }

  String formatDate(dynamic d) {
    if (d == null) return '-';
    if (d is DateTime) {
      return d.toString();
    }
    if (d is String) {
      // try parse, otherwise return raw string
      try {
        final parsed = DateTime.parse(d);
        return parsed.toString();
      } catch (_) {
        return d;
      }
    }
    return d.toString();
  }

  Map<String, dynamic>statusMeta(String? status) {
    final s = (status ?? '').toLowerCase();
    if (s == 'approved')
      return {'color': Colors.green, 'icon': Icons.check_circle};
    if (s == 'pending')
      return {'color': Colors.orange, 'icon': Icons.hourglass_top};
    if (s == 'reject' || s == 'rejected')
      return {'color': Colors.red, 'icon': Icons.cancel};
    return {'color': AppColors.brightCyan, 'icon': Icons.info};
  }
}
