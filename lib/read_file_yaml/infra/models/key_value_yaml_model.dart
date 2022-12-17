import 'dart:collection';
import 'dart:convert';

import 'package:app_masterclass_intermediario/read_file_yaml/infra/models/file_yaml_model.dart';

class KeyValueYamlModel {
  final List<FileYamlModel> listKeyAndValue = [];

  void add(FileYamlModel fileYamlModel) {
    listKeyAndValue.add(fileYamlModel);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    for (var keyAndValue in listKeyAndValue) {
      final String key = keyAndValue.key;
      final value = keyAndValue.value;
      final listChild = keyAndValue.getListChild();

      map.putIfAbsent(key, () => value);

      for (var child in listChild) {
        final String childKey = child.key;
        final childValue = child.value;
        map[key] = map[key] is! LinkedHashMap ? {} : map[key];
        map[key].putIfAbsent(childKey, () => childValue);

        for (var child2 in child.getListChild()) {
          final String childKey2 = child2.key;
          final childValue2 = child2.value;
          map[key][childKey] =
              map[key][childKey] is! LinkedHashMap ? {} : map[key][childKey];
          map[key][childKey].putIfAbsent(childKey2, () => childValue2);

          for (var child3 in child2.getListChild()) {
            final String childKey3 = child3.key;
            final childValue3 = child3.value;
            map[key][childKey][childKey2] =
                map[key][childKey][childKey2] is! LinkedHashMap
                    ? {}
                    : map[key][childKey][childKey2];
            map[key][childKey][childKey2]
                .putIfAbsent(childKey3, () => childValue3);
          }
        }
      }
    }

    return map;
  }

  String toJson() {
    final map = toMap();

    return jsonEncode(map);
  }
}
