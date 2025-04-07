class Campaign {
  final String id;
  final String? imageUrl;
  final String title;
  final bool isDM;

  Campaign({
    required this.id,
    this.imageUrl, 
    required this.title,
    required this.isDM,
  });
}