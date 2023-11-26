/// Provide extra extension on Map nullable type
extension MapExtendedExtensions<K, V> on Map<K, V>? {
  /// `nullSafe`
  ///
  /// If `Map` contains null then return a empty `Map`
  /// otherwise return given `Map`
  Map<K, V> get nullSafe => (this ?? <K, V>{});

  /// `isEmpty`
  ///
  /// If given `Map` is null then return `true` otherwise `false`
  bool get isEmpty => nullSafe.isEmpty;

  /// `isNotEmpty`
  ///
  /// If given `Map` is null then return `false` otherwise `true`
  bool get isNotEmpty => nullSafe.isNotEmpty;
}
