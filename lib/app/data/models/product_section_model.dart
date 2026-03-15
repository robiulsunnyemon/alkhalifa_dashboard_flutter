class ProductSectionModel {
  final int id;
  final String name;
  final int orderIndex;
  final bool isActive;
  final List<SectionProductModel>? products;

  ProductSectionModel({
    required this.id,
    required this.name,
    required this.orderIndex,
    required this.isActive,
    this.products,
  });

  factory ProductSectionModel.fromJson(Map<String, dynamic> json) {
    return ProductSectionModel(
      id: json['id'],
      name: json['name'],
      orderIndex: json['order_index'] ?? 0,
      isActive: json['is_active'] ?? true,
      products: json['products'] != null
          ? (json['products'] as List)
              .map((p) => SectionProductModel.fromJson(p))
              .toList()
          : null,
    );
  }
}

class SectionProductModel {
  final int id;
  final int sectionId;
  final int productId;
  final int orderIndex;
  final dynamic product;

  SectionProductModel({
    required this.id,
    required this.sectionId,
    required this.productId,
    required this.orderIndex,
    this.product,
  });

  factory SectionProductModel.fromJson(Map<String, dynamic> json) {
    return SectionProductModel(
      id: json['id'],
      sectionId: json['section_id'],
      productId: json['product_id'],
      orderIndex: json['order_index'] ?? 0,
      product: json['product'],
    );
  }
}
