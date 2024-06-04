// model/product.dart
class CategoryProduct {
  final int id;
  final String name;

  CategoryProduct({
    required this.id,
    required this.name,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'],
      name: json['name'],
    );
  }
}
