class FileUtils {
  static const int _SPACE_UNICODE = 32;

  static String getKey(List<String> keyAndValue) {
    if (keyAndValue.isEmpty) return '';

    return keyAndValue[0];
  }

  static String getKeyTrim(List<String> keyAndValue) {
    String key = getKey(keyAndValue);

    return key.trim();
  }

  static bool isKeyAndValueEmpty(List<String> keyAndValue) {
    return keyAndValue[0].isEmpty;
  }

  static dynamic getValue(List<String> keyAndValue) {
    if (isKeyAndValueEmpty(keyAndValue)) return '';

    final keyAndValueAux = [...keyAndValue];

    if (keyAndValueAux.length > 2) {
      keyAndValueAux.removeAt(0);

      return keyAndValueAux.join('').trim();
    }

    final value = keyAndValue[1];

    return value.isEmpty ? <String, dynamic>{} : value.trim();
  }

  static int getLevelSpaceLeft(List<String> keyAndValue) {
    final String key = getKey(keyAndValue);

    final listUnicode32 =
        key.runes.where((value) => value == _SPACE_UNICODE).toList();

    final int count = listUnicode32.length;

    return count;
  }
}
