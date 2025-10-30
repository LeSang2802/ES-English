/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// Directory path: assets/audio/animals
  $AssetsAudioAnimalsGen get animals => const $AssetsAudioAnimalsGen();
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/app_icon.jpg
  AssetGenImage get appIcon => const AssetGenImage('assets/icons/app_icon.jpg');

  /// File path: assets/icons/challenge.svg
  String get challenge => 'assets/icons/challenge.svg';

  /// File path: assets/icons/chatbot.svg
  String get chatbot => 'assets/icons/chatbot.svg';

  /// File path: assets/icons/flashcard.svg
  String get flashcard => 'assets/icons/flashcard.svg';

  /// List of all assets
  List<dynamic> get values => [appIcon, challenge, chatbot, flashcard];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/animals
  $AssetsImagesAnimalsGen get animals => const $AssetsImagesAnimalsGen();

  /// File path: assets/images/app_icon.jpg
  AssetGenImage get appIcon =>
      const AssetGenImage('assets/images/app_icon.jpg');

  /// File path: assets/images/congra.png
  AssetGenImage get congra => const AssetGenImage('assets/images/congra.png');

  /// List of all assets
  List<AssetGenImage> get values => [appIcon, congra];
}

class $AssetsAudioAnimalsGen {
  const $AssetsAudioAnimalsGen();

  /// File path: assets/audio/animals/bear.mp3
  String get bear => 'assets/audio/animals/bear.mp3';

  /// File path: assets/audio/animals/cat.mp3
  String get cat => 'assets/audio/animals/cat.mp3';

  /// File path: assets/audio/animals/dog.mp3
  String get dog => 'assets/audio/animals/dog.mp3';

  /// File path: assets/audio/animals/elephant.mp3
  String get elephant => 'assets/audio/animals/elephant.mp3';

  /// File path: assets/audio/animals/fox.mp3
  String get fox => 'assets/audio/animals/fox.mp3';

  /// File path: assets/audio/animals/giraffe.mp3
  String get giraffe => 'assets/audio/animals/giraffe.mp3';

  /// File path: assets/audio/animals/horse.mp3
  String get horse => 'assets/audio/animals/horse.mp3';

  /// File path: assets/audio/animals/lion.mp3
  String get lion => 'assets/audio/animals/lion.mp3';

  /// File path: assets/audio/animals/monkey.mp3
  String get monkey => 'assets/audio/animals/monkey.mp3';

  /// File path: assets/audio/animals/rabbit.mp3
  String get rabbit => 'assets/audio/animals/rabbit.mp3';

  /// List of all assets
  List<String> get values =>
      [bear, cat, dog, elephant, fox, giraffe, horse, lion, monkey, rabbit];
}

class $AssetsImagesAnimalsGen {
  const $AssetsImagesAnimalsGen();

  /// File path: assets/images/animals/bear.jpg
  AssetGenImage get bear =>
      const AssetGenImage('assets/images/animals/bear.jpg');

  /// File path: assets/images/animals/cat.jpg
  AssetGenImage get cat => const AssetGenImage('assets/images/animals/cat.jpg');

  /// File path: assets/images/animals/dog.jpg
  AssetGenImage get dog => const AssetGenImage('assets/images/animals/dog.jpg');

  /// File path: assets/images/animals/elephant.jpg
  AssetGenImage get elephant =>
      const AssetGenImage('assets/images/animals/elephant.jpg');

  /// File path: assets/images/animals/fox.jpg
  AssetGenImage get fox => const AssetGenImage('assets/images/animals/fox.jpg');

  /// File path: assets/images/animals/giraffe.jpg
  AssetGenImage get giraffe =>
      const AssetGenImage('assets/images/animals/giraffe.jpg');

  /// File path: assets/images/animals/horse.jpg
  AssetGenImage get horse =>
      const AssetGenImage('assets/images/animals/horse.jpg');

  /// File path: assets/images/animals/monkey.jpg
  AssetGenImage get monkey =>
      const AssetGenImage('assets/images/animals/monkey.jpg');

  /// File path: assets/images/animals/rabbit.jpg
  AssetGenImage get rabbit =>
      const AssetGenImage('assets/images/animals/rabbit.jpg');

  /// File path: assets/images/animals/tiger.jpg
  AssetGenImage get tiger =>
      const AssetGenImage('assets/images/animals/tiger.jpg');

  /// List of all assets
  List<AssetGenImage> get values =>
      [bear, cat, dog, elephant, fox, giraffe, horse, monkey, rabbit, tiger];
}

class Assets {
  Assets._();

  static const $AssetsAudioGen audio = $AssetsAudioGen();
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
    FilterQuality filterQuality = FilterQuality.low,
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
