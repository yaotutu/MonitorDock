/// App metrics configuration
class AppMetrics {
  /// Block border radius - iOS style rounded corners
  static const blockRadius = 16.0;

  /// Container border radius - iOS style rounded corners
  static const containerRadius = 10.0;

  /// Tag border radius - iOS style pill shape
  static const tagRadius = 8.0;

  /// Block padding - iOS style spacing
  static const blockPadding = 16.0;

  /// Container padding horizontal - iOS style spacing
  static const containerPaddingH = 16.0;

  /// Container padding vertical - iOS style spacing
  static const containerPaddingV = 12.0;

  /// Icon sizes
  static const iconSizes = IconSizes();

  /// Spacing sizes
  static const spacing = Spacing();

  /// Blur effect - iOS style blur
  static const blurRadius = 20.0;

  /// Border width - iOS style thin borders
  static const borderWidth = 0.5;

  /// Min block height
  static const minBlockHeight = 100.0;

  /// Default block width
  static const defaultBlockWidth = 320.0;
}

/// Icon size configuration
class IconSizes {
  const IconSizes();

  /// Large icon size - iOS style
  final double large = 24.0;

  /// Medium icon size - iOS style
  final double medium = 20.0;

  /// Small icon size - iOS style
  final double small = 16.0;
}

/// Spacing configuration
class Spacing {
  const Spacing();

  /// Extra large spacing - iOS style
  final double xl = 24.0;

  /// Large spacing - iOS style
  final double large = 16.0;

  /// Medium spacing - iOS style
  final double medium = 12.0;

  /// Small spacing - iOS style
  final double small = 8.0;

  /// Extra small spacing - iOS style
  final double xs = 6.0;

  /// Tiny spacing - iOS style
  final double tiny = 4.0;

  /// Extra tiny spacing - iOS style
  final double xtiny = 2.0;
}
