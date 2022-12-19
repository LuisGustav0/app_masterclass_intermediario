import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:app_masterclass_intermediario/read_file/enums/type_level_enum.dart';
import 'package:app_masterclass_intermediario/read_file/models/component.dart';
import 'package:app_masterclass_intermediario/read_file/models/level_01.dart';
import 'package:app_masterclass_intermediario/read_file/models/level_02.dart';
import 'package:app_masterclass_intermediario/read_file/models/level_03.dart';
import 'package:app_masterclass_intermediario/read_file/models/level_04.dart';
import 'package:app_masterclass_intermediario/read_file/utils/file_utils.dart';

class TreeNodeService {
  final String pathFile = 'assets/files/pubspec_masterclass.yaml';

  Future<List<String>> openReadFile() async {
    final listLine = await File(pathFile).readAsLines();

    return listLine.where((line) => line.isNotEmpty).toList();
  }

  Map<String, dynamic> getKeyByLevel(Map<String, dynamic> map, String key) {
    return map[key] is! LinkedHashMap ? {} : map[key];
  }

  Map<String, dynamic> toMap(List<IComponent> listComponent) {
    Map<String, dynamic> map = {};

    for (IComponent level01 in listComponent) {
      map.putIfAbsent(level01.key, () => level01.value);

      for (IComponent level02 in level01.listChild) {
        Map<String, dynamic> mapLevel01 = getKeyByLevel(map, level01.key);

        mapLevel01.putIfAbsent(level02.key, () => level02.value);
        map.update(level01.key, (value) => mapLevel01);

        for (IComponent level03 in level02.listChild) {
          Map<String, dynamic> mapLevel02 =
              getKeyByLevel(mapLevel01, level02.key);

          mapLevel02.putIfAbsent(level03.key, () => level03.value);
          mapLevel01.update(level02.key, (value) => mapLevel02);

          for (IComponent level04 in level03.listChild) {
            Map<String, dynamic> mapLevel03 =
                getKeyByLevel(mapLevel02, level03.key);

            mapLevel03.putIfAbsent(level04.key, () => level04.value);
            mapLevel02.update(level03.key, (value) => mapLevel03);
          }
        }
      }
    }

    return map;
  }

  Future<String> read() async {
    final listLine = await openReadFile();

    List<IComponent> listComponent = [];

    for (int index = 0; index < listLine.length; index++) {
      final keyAndValue = listLine[index].split(':');
      final key = FileUtils.getKeyTrim(keyAndValue);
      final value = FileUtils.getValue(keyAndValue);
      final levelSpaceLeft = FileUtils.getLevelSpaceLeft(keyAndValue);

      if (levelSpaceLeft == TypeLevelE.LEVEL_01.value) {
        final level01 = Level01(key: key, value: value, level: levelSpaceLeft);

        listComponent.add(level01);
      }

      if (levelSpaceLeft == TypeLevelE.LEVEL_02.value) {
        final level01 = listComponent.reversed.first;
        final level02 = Level02(key: key, value: value, level: levelSpaceLeft);

        level01.addChild(level02);
      }

      if (levelSpaceLeft == TypeLevelE.LEVEL_03.value) {
        final level01 = listComponent.reversed.first;
        final level02 = level01.listChild.reversed.first;
        final level03 = Level03(key: key, value: value, level: levelSpaceLeft);

        level02.addChild(level03);
      }

      if (levelSpaceLeft == TypeLevelE.LEVEL_04.value) {
        final level01 = listComponent.reversed.first;
        final level02 = level01.listChild.reversed.first;
        final level03 = level02.listChild.reversed.first;
        final level04 = Level04(key: key, value: value, level: levelSpaceLeft);

        level03.addChild(level04);
      }
    }

    final Map<String, dynamic> map = toMap(listComponent);

    return jsonEncode(map);
  }
}
