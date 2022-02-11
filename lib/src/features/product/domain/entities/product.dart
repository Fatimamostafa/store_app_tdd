class ProductEntity {
  final int id;
  final String image;
  final String title;
  final String description;
  final String category;

  const ProductEntity({
    required this.image,
    required this.description,
    required this.category,
    required this.id,
    required this.title,
  });
}
