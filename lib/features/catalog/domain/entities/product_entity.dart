class ProductEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final List<String> images;
  final String category;
  final int stock;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.category,
    required this.stock,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.price == price &&
        other.thumbnail == thumbnail &&
        other.images == images &&
        other.category == category &&
        other.stock == stock;
  }

  ProductEntity copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? thumbnail,
    List<String>? images,
    String? category,
    int? stock,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      images: images ?? this.images,
      category: category ?? this.category,
      stock: stock ?? this.stock,
    );
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        price.hashCode ^
        thumbnail.hashCode ^
        images.hashCode ^
        category.hashCode ^
        stock.hashCode;
  }
}
