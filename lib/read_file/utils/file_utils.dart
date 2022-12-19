class FileUtils {
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

    if (keyAndValueAux.length > 1) {
      keyAndValueAux.removeAt(0);

      return keyAndValueAux.join('').trim();
    }

    return keyAndValue[1].trim();
  }

  static int getLevelSpaceLeft(List<String> keyAndValue) {
    final String key = getKey(keyAndValue);

    final List listSplit = key.split(' ');
    final int count = listSplit.length;

    return count;
  }
}
