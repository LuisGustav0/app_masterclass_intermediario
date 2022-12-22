class Node {
  final String key;
  final dynamic value;
  final int level;
  final bool isObject;

  final List<Node> listChild = [];

  Node({
    required this.key,
    required this.value,
    required this.level,
    required this.isObject,
  });
}
