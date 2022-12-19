import 'package:app_masterclass_intermediario/read_file/tree_node_service.dart';
import 'package:test/test.dart';

void main() {
  test('Testar a leitura do arquivo yaml com sucesso', () async {
    final _service = TreeNodeService();

    final String json = await _service.read();

    expect(json, isNotEmpty);
  });
}
