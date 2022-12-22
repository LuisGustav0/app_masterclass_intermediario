import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:app_masterclass_intermediario/read_file/utils/file_utils.dart';
import 'package:app_masterclass_intermediario/read_yaml/model/node.dart';

class ReadYamlService {
  final String pathFile = 'assets/files/pubspec_masterclass.yaml';

  Future<List<String>> openReadFile() async {
    final listLine = await File(pathFile).readAsLines();

    return listLine.where((line) => line.isNotEmpty).toList();
  }

  Node _getNode(String line) {
    final keyAndValue = line.split(':');
    final key = FileUtils.getKeyTrim(keyAndValue);
    final value = FileUtils.getValue(keyAndValue);
    final level = FileUtils.getLevelSpaceLeft(keyAndValue);

    final isObject = value.isEmpty;

    return Node(
      key: key,
      value: value,
      level: level,
      isObject: isObject,
    );
  }

  Node _findHeaderNode(Node headerNode, int currentLevel) {
    if (headerNode.listChild.isEmpty) return headerNode;

    final Node? lastHeaderNodeInChild = headerNode.listChild
        .lastWhereOrNull((node) => node.isObject && currentLevel > node.level);

    if (lastHeaderNodeInChild == null) return headerNode;

    if (lastHeaderNodeInChild.level == currentLevel - 1) {
      return lastHeaderNodeInChild;
    }

    return _findHeaderNode(lastHeaderNodeInChild, currentLevel);
  }

  Map<String, dynamic> toMap(List<Node> listNode) {
    final Map<String, dynamic> map = {};

    return map;
  }

  Future<String> read() async {
    const int LEVEL_INITIAL = 0;

    final listLine = await openReadFile();
    final List<Node> listNode = [];

    for (final line in listLine) {
      Node node = _getNode(line);

      if (node.level == LEVEL_INITIAL) {
        listNode.add(node);
        continue;
      }

      final lastHeaderNode = listNode.last;
      Node headerNode = _findHeaderNode(lastHeaderNode, node.level);
      headerNode.listChild.add(node);
    }

    Map<String, dynamic> map = toMap(listNode);

    return jsonEncode(map);
  }
}
