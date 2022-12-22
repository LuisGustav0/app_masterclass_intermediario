enum TypeLevelE {
  LEVEL_01(0),
  LEVEL_02(2),
  LEVEL_03(4),
  LEVEL_04(6);

  final int value;

  const TypeLevelE(this.value);

  static TypeLevelE toTypeLevelE(int level) {
    return TypeLevelE.values
        .where((typeLevelE) => typeLevelE.value == level)
        .first;
  }
}
