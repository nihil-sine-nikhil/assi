mixin Assets {
  static AssetImages get images => AssetImages();
  static AssetIcons get icons => AssetIcons();
}

class AssetImages {
  /// Location Path
  String location = 'assets/images';
}

class AssetIcons {
  /// Location Path
  String location = 'assets/icons';
  String get india => '$location/india.png';
}
