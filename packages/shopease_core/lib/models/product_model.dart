import 'package:equatable/equatable.dart';

// Product entity
class ProductModel extends Equatable {
  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    this.imageUrl = '',
    this.sizes = const [],
    this.isAvailable = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;
  final List<String> sizes;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Stock availability check
  bool get isInStock => isAvailable && stock > 0;

  // Parses comma-separated size text into trimmed non-empty tokens
  static List<String> parseSizes(String text) {
    return text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  // Original price before discount (mocked at 25% markup)
  double get originalPrice => price * 1.25;

  // Percentage discount
  int get discountPercentage => originalPrice > price
      ? (((originalPrice - price) / originalPrice) * 100).round()
      : 0;

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? imageUrl,
    List<String>? sizes,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      sizes: sizes ?? this.sizes,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'imageUrl': imageUrl,
      'sizes': sizes,
      'isAvailable': isAvailable,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      if (date is DateTime) return date;
      if (date is String) return DateTime.tryParse(date);
      try {
        final dynamic ts = date;
        return ts.toDate() as DateTime;
      } catch (_) {
        return null;
      }
    }

    return ProductModel(
      id: documentId ?? (map['id'] as String? ?? ''),
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      category: map['category'] as String? ?? 'General',
      imageUrl: map['imageUrl'] as String? ?? '',
      sizes:
          (map['sizes'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
      isAvailable: map['isAvailable'] as bool? ?? true,
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    stock,
    category,
    imageUrl,
    sizes,
    isAvailable,
    createdAt,
    updatedAt,
  ];
}
