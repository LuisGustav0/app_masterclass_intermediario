class FileYamlModel {
  final int index;
  final String key;
  final dynamic value;
  final int level;

  final List<FileYamlModel> _listChild = [];

  FileYamlModel({
    required this.index,
    required this.key,
    required this.value,
    required this.level,
  });

  List<FileYamlModel> getListChild() {
    return _listChild;
  }

  List<FileYamlModel> getListChildReversed() {
    return _listChild.reversed.toList();
  }

  void addKeyValueChild(FileYamlModel fileYamlModel) {
    _listChild.add(fileYamlModel);
  }
}
