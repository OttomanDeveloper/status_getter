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
  /// will check if provided and attached values
  ///
  /// are same then return `true` otherwise `false`
  bool isSame(int? v) {
    // Check if given and provided values are null
    // then return false
    if (this == null || v == null) {
      return false;
    } else {
      return (this == v);
    }
  }
}
