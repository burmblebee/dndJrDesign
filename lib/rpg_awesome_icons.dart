import 'package:flutter/widgets.dart';

/// A class containing mappings for your RPG Awesome icons.
/// 
/// These mappings come from the CSS code points:
///  - .ra-crossed-swords:before = U+E97D
///  - .ra-battered-axe:before   = U+E91C
///  - .ra-arrow-cluster:before  = U+E911
///  - .ra-knife:before          = U+EA19
class RpgAwesomeIcons {
  RpgAwesomeIcons._(); // Private constructor to prevent instantiation.

  /// Crossed Swords icon (U+E97D => 0xe97d).
  static const IconData crossedSwords = IconData(
    0xe97d,
    fontFamily: 'RpgAwesome', // Must match pubspec.yaml
  );

  /// Battered Axe icon (U+E91C => 0xe91c).
  static const IconData batteredAxe = IconData(
    0xe91c,
    fontFamily: 'RpgAwesome',
  );

  /// Arrow Cluster icon (U+E911 => 0xe911).
  static const IconData arrowCluster = IconData(
    0xe911,
    fontFamily: 'RpgAwesome',
  );

  /// Knife icon (U+EA19 => 0xea19).
  static const IconData knife = IconData(
    0xea19,
    fontFamily: 'RpgAwesome',
  );
}
