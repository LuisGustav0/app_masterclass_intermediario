import 'package:app_masterclass_intermediario/read_file_yaml/domain/repositories/file_yaml_repository.dart';
import 'package:app_masterclass_intermediario/read_file_yaml/infra/datasources/local_assets/read_file_local_assets_datasource.dart';
import 'package:app_masterclass_intermediario/read_file_yaml/infra/models/file_yaml_model.dart';
import 'package:app_masterclass_intermediario/read_file_yaml/infra/models/key_value_yaml_model.dart';

class FileYamlRepositoryImpl implements IFileYamlRepository {
  static int LEVEL_01 = 1;

  final ReadFileLocalAssetsDatasource _datasource;

  FileYamlRepositoryImpl({
    required ReadFileLocalAssetsDatasource datasource,
  }) : _datasource = datasource;

  String _getKey(List<String> keyAndValue) {
    if (keyAndValue.isEmpty) return '';

    return keyAndValue[0];
  }

  String _getKeyTrim(List<String> keyAndValue) {
    String key = _getKey(keyAndValue);

    return key.trim();
  }

  bool isKeyAndValueEmpty(List<String> keyAndValue) {
    return keyAndValue[0].isEmpty;
  }

  dynamic _getValue(List<String> keyAndValue) {
    if (isKeyAndValueEmpty(keyAndValue)) return '';

    final keyAndValueAux = [...keyAndValue];

    if (keyAndValueAux.length > 1) {
      keyAndValueAux.removeAt(0);

      return keyAndValueAux.join('').trim();
    }

    return keyAndValue[1].trim();
  }

  int _getLevelSpaceLeft(List<String> keyAndValue) {
    final String key = _getKey(keyAndValue);

    final List listSplit = key.split(' ');
    final int count = listSplit.length;

    return count;
  }

  FileYamlModel _getOldFileYamlModelByIndex(
    KeyValueYamlModel keyValueYaml,
    int index,
    int actualLevel,
  ) {
    final listKeyAndValue = keyValueYaml.listKeyAndValue;
    final size = listKeyAndValue.length;

    if (index < size) {
      return listKeyAndValue.elementAt(index);
    }

    while (index >= size) {
      index = index - 1;
    }

    var fileYamlModel = listKeyAndValue.elementAt(index);

    final listChild = fileYamlModel.getListChildReversed();

    for (var child in listChild) {
      if (child.level == actualLevel) break;

      if (child.level > fileYamlModel.level) {
        fileYamlModel = child;

        for (var child2 in child.getListChildReversed()) {
          if (child2.level == fileYamlModel.level) break;

          if (child2.level > fileYamlModel.level) {
            fileYamlModel = child2;
          }
        }
      }
    }

    return fileYamlModel;
  }

  @override
  Future<String> read() async {
    final keyValueYaml = KeyValueYamlModel();

    final listLine = await _datasource.call();

    for (int actualIndex = 0; actualIndex < listLine.length; actualIndex++) {
      final actualKeyAndValue = listLine[actualIndex].split(':');
      final actualKey = _getKeyTrim(actualKeyAndValue);
      final actualValue = _getValue(actualKeyAndValue);
      final actualLevel = _getLevelSpaceLeft(actualKeyAndValue);

      if (actualIndex == 0) {
        final fileYamlModel = FileYamlModel(
          index: actualIndex,
          key: actualKey,
          value: actualValue,
          level: actualLevel,
        );

        keyValueYaml.add(fileYamlModel);
        continue;
      }

      int oldIndex = actualIndex - 1;

      final oldKeyAndValue = listLine[oldIndex].split(':');
      final oldLevel = _getLevelSpaceLeft(oldKeyAndValue);

      if (actualLevel == LEVEL_01) {
        final fileYamlModel = FileYamlModel(
          index: actualIndex,
          key: actualKey,
          value: actualValue,
          level: actualLevel,
        );

        keyValueYaml.add(fileYamlModel);
      } else if (actualLevel > oldLevel) {
        final oldFileYamlModel =
            _getOldFileYamlModelByIndex(keyValueYaml, oldIndex, actualLevel);

        final fileYamlModel = FileYamlModel(
          index: actualIndex,
          key: actualKey,
          value: actualValue,
          level: actualLevel,
        );

        oldFileYamlModel.addKeyValueChild(fileYamlModel);
      } else if (actualLevel == oldLevel) {
        final oldFileYamlModel =
            _getOldFileYamlModelByIndex(keyValueYaml, oldIndex, actualLevel);

        final fileYamlModel = FileYamlModel(
          index: actualIndex,
          key: actualKey,
          value: actualValue,
          level: actualLevel,
        );

        oldFileYamlModel.addKeyValueChild(fileYamlModel);
      }
    }

    return keyValueYaml.toJson();
  }
}
