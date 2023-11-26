/// Add Extra Functions and Methods on `List`
extension CustomListExtension<T> on List<T>? {
  /// `isNotEmpty`
  ///
  /// Check if given `List` contains `data`
  ///
  /// then return `true` otherwise `false`
  bool get isNotEmpty => nullSafe.isNotEmpty;

  /// `isEmpty`
  ///
  /// Check if given `List` contains `data`
  ///
  /// then return `false` otherwise `true`
  bool get isEmpty => nullSafe.isEmpty;

  /// `nullSafe`
  ///
  /// If `List` is `null` then return a empty `List` otherwise return given data
  List<T> get nullSafe => (this ?? <T>[]);
}
