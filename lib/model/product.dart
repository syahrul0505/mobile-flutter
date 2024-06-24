// model/product.dart
class MenuItem {
  final int id;
  final String name;
  final int categoryId;
  final String purchasePrice;
  final String sellingPrice;
  final String status;
  final int? currentStock;
  final String image;
  final String? description;
  final String? slug;

  MenuItem({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.status,
    this.currentStock,
    required this.image,
    this.description,
    this.slug,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      categoryId: json['category'],
      purchasePrice: json['purchase_price'],
      sellingPrice: json['selling_price'],
      status: json['status'],
      currentStock: json['current_stock'],
      image: json['image'],
      description: json['description'],
      slug: json['slug'],
    );
  }
}
