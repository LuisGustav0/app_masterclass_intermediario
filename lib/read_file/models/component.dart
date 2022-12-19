abstract class IComponent {
  String key;
  dynamic value;
  int level;
  final List<IComponent> listChild = [];

  IComponent({
    required this.key,
    required this.value,
    required this.level,
  });

  void addChild(IComponent component) {
    listChild.add(component);
  }
}
