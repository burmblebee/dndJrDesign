class Character{
  String name;
  int health;
  int maxHealth;
  int armorClass;

  Character({
    required this.name,
    this.health = 100,
    this.maxHealth = 100,
    this.armorClass = 10,
  });
}