class EnumUtil {
  static T enumFromString<T>(Iterable<T> values, String stringType) {
    return values.firstWhere(
            (f)=> "${f.toString().substring(f.toString().indexOf('.')+1)}".toString()
            == stringType, orElse: () => null);
  }
}