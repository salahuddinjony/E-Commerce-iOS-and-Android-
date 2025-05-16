/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/arrow.svg
  SvgGenImage get arrow => const SvgGenImage('assets/icons/arrow.svg');

  /// File path: assets/icons/arrow_back.svg
  SvgGenImage get arrowBack => const SvgGenImage('assets/icons/arrow_back.svg');

  /// File path: assets/icons/edit.svg
  SvgGenImage get edit => const SvgGenImage('assets/icons/edit.svg');

  /// File path: assets/icons/eye.svg
  SvgGenImage get eye => const SvgGenImage('assets/icons/eye.svg');

  /// File path: assets/icons/eye_off.svg
  SvgGenImage get eyeOff => const SvgGenImage('assets/icons/eye_off.svg');

  /// File path: assets/icons/lock.svg
  SvgGenImage get lock => const SvgGenImage('assets/icons/lock.svg');

  /// File path: assets/icons/logout.svg
  SvgGenImage get logout => const SvgGenImage('assets/icons/logout.svg');

  /// File path: assets/icons/mail.svg
  SvgGenImage get mail => const SvgGenImage('assets/icons/mail.svg');

  /// File path: assets/icons/user.svg
  SvgGenImage get user => const SvgGenImage('assets/icons/user.svg');

  /// List of all assets
  List<SvgGenImage> get values =>
      [arrow, arrowBack, edit, eye, eyeOff, lock, logout, mail, user];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Simplification.png
  AssetGenImage get simplification =>
      const AssetGenImage('assets/images/Simplification.png');

  /// File path: assets/images/add.png
  AssetGenImage get add => const AssetGenImage('assets/images/add.png');

  /// File path: assets/images/apple.png
  AssetGenImage get apple => const AssetGenImage('assets/images/apple.png');

  /// File path: assets/images/chat_unselected.png
  AssetGenImage get chatUnselected =>
      const AssetGenImage('assets/images/chat_unselected.png');

  /// File path: assets/images/checkOut.png
  AssetGenImage get checkOut =>
      const AssetGenImage('assets/images/checkOut.png');

  /// File path: assets/images/google.png
  AssetGenImage get google => const AssetGenImage('assets/images/google.png');

  /// File path: assets/images/home_selected.png
  AssetGenImage get homeSelected =>
      const AssetGenImage('assets/images/home_selected.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/notification.png
  AssetGenImage get notification =>
      const AssetGenImage('assets/images/notification.png');

  /// File path: assets/images/onboard1.png
  AssetGenImage get onboard1 =>
      const AssetGenImage('assets/images/onboard1.png');

  /// File path: assets/images/onboard2.png
  AssetGenImage get onboard2 =>
      const AssetGenImage('assets/images/onboard2.png');

  /// File path: assets/images/onboard3.png
  AssetGenImage get onboard3 =>
      const AssetGenImage('assets/images/onboard3.png');

  /// File path: assets/images/order_unselected.png
  AssetGenImage get orderUnselected =>
      const AssetGenImage('assets/images/order_unselected.png');

  /// File path: assets/images/owner_home_selected.png
  AssetGenImage get ownerHomeSelected =>
      const AssetGenImage('assets/images/owner_home_selected.png');

  /// File path: assets/images/profile.png
  AssetGenImage get profile => const AssetGenImage('assets/images/profile.png');

  /// File path: assets/images/support_unselected.png
  AssetGenImage get supportUnselected =>
      const AssetGenImage('assets/images/support_unselected.png');

  /// File path: assets/images/u_tee.png
  AssetGenImage get uTee => const AssetGenImage('assets/images/u_tee.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        simplification,
        add,
        apple,
        chatUnselected,
        checkOut,
        google,
        homeSelected,
        logo,
        notification,
        onboard1,
        onboard2,
        onboard3,
        orderUnselected,
        ownerHomeSelected,
        profile,
        supportUnselected,
        uTee
      ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
