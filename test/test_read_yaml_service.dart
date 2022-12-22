import 'package:app_masterclass_intermediario/read_yaml/read_yaml_service.dart';
import 'package:test/test.dart';

void main() {
  test('Testar a leitura do arquivo yaml com sucesso', () async {
    final _service = ReadYamlService();

    final String json = await _service.read();

    expect(json, isNotEmpty);
  });
}