import 'dart:io';

import 'package:app_masterclass_intermediario/read_file_yaml/infra/datasources/local_assets/read_file_local_assets_datasource.dart';

class ReadFileLocalAssetsDatasourceImpl
    implements ReadFileLocalAssetsDatasource {
  final String pathFile = 'assets/files/pubspec_masterclass.yaml';

  @override
  Future<List<String>> call() async {
    final listLine = await File(pathFile).readAsLines();

    return listLine.where((line) => line.isNotEmpty).toList();
  }
}
