import 'package:app_masterclass_intermediario/read_file_yaml/external/datasources/read_file_local_assets_datasource_impl.dart';
import 'package:app_masterclass_intermediario/read_file_yaml/infra/repositories/file_yaml_repository_impl.dart';
import 'package:test/test.dart';

void main() {
  test('Testar a leitura do arquivo yaml com sucesso', () async {
    final _repository =
        FileYamlRepositoryImpl(datasource: ReadFileLocalAssetsDatasourceImpl());

    final String json = await _repository.read();

    expect(json, isNotEmpty);
  });
}
