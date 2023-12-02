/// Provide extra extension on int nullable type
extension DoubleExtendedExtensions on double? {
  /// `nullSafe`
  /// check if the value is null then return a `0`
  double get nullSafe => (this ?? 0.0);
}

/// Provide extra extension on int nullable type
extension IntExtendedExtensions on int? {
  /// `nullSafe`
  /// check if the value is null then return a `0`
  int get nullSafe => (this ?? 0);

  /// `isEmpty`
  ///
  /// If given `int` is null then return `true` otherwise `false`
  bool get isEmpty => (this == null);

  /// `isNotEmpty`
  ///
  /// If given `int` is null then return `false` otherwise `true`
  bool get isNotEmpty => (this != null);

  /// `isSame()` function
  ///
  /// This extension method checks if the provided value [v] is the same as the
  /// value this method is called on. Returns `true` if they are the same,
  /// otherwise returns `false`.
  ///
  /// Usage:
  ///
  /// ```dart
  /// int a = 5;
  /// int b = 5;
  /// bool result = a.isSame(b); // Returns true
  /// ```
  bool isSame(int? v) {
    // Check if either of the values is null
    // If any of them is null, they are not the same
    if (this == null || v == null) {
      return false;
    } else {
      // Values are not null, compare them
      return (this == v);
    }
  }
}
