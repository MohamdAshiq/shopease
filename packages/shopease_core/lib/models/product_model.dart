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
    this.imageUrls = const [],
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
  final List<String> imageUrls;
  final List<String> sizes;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Stock availability check
  bool get isInStock => isAvailable && stock > 0;

  // Main thumbnail image
  String get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    int? stock,
    String? category,
    List<String>? imageUrls,
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
      imageUrls: imageUrls ?? this.imageUrls,
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
      'imageUrls': imageUrls,
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
      imageUrls:
          (map['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
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
    imageUrls,
    sizes,
    isAvailable,
    createdAt,
    updatedAt,
  ];
}

// Mock Products List
final List<ProductModel> mockProducts = [
  ProductModel(
    id: 'prod_001',
    title: 'Sony WH-1000XM5 Wireless Headphones',
    description: 'Industry-leading noise canceling with two processors and 8 microphones. Up to 30-hour battery life with quick charging.',
    price: 349.99,
    stock: 25,
    category: 'Electronics',
    imageUrls: const [
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
    ],
    sizes: const [],
    isAvailable: true,
    createdAt: DateTime(2026, 1, 15),
  ),
  ProductModel(
    id: 'prod_002',
    title: 'Nike Air Max Pulse Sneakers',
    description: 'Point-loaded cushioning with vacuum-sealed plastic accent for responsive bounce. Breathable textile upper with leather overlays.',
    price: 149.99,
    stock: 18,
    category: 'Footwear',
    imageUrls: const [
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&q=80',
    ],
    sizes: const ['7', '8', '9', '10', '11'],
    isAvailable: true,
    createdAt: DateTime(2026, 1, 20),
  ),
  ProductModel(
    id: 'prod_003',
    title: 'Minimalist Chronograph Leather Watch',
    description: 'Sleek matte stainless steel case with genuine Italian leather strap. Water-resistant up to 50 meters with sapphire crystal glass.',
    price: 189.50,
    stock: 12,
    category: 'Accessories',
    imageUrls: const [
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
    ],
    sizes: const [],
    isAvailable: true,
    createdAt: DateTime(2026, 2, 5),
  ),
  ProductModel(
    id: 'prod_004',
    title: 'Ergonomic Mechanical Keyboard',
    description: 'Hot-swappable tactile mechanical switches with per-key RGB backlighting and aircraft-grade aluminum frame.',
    price: 129.00,
    stock: 30,
    category: 'Electronics',
    imageUrls: const [
      'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800&q=80',
    ],
    sizes: const [],
    isAvailable: true,
    createdAt: DateTime(2026, 2, 10),
  ),
  ProductModel(
    id: 'prod_005',
    title: 'Heritage Canvas Travel Backpack',
    description: 'Durable water-resistant waxed canvas with padded laptop compartment (up to 16 inch) and quick-access magnetic closures.',
    price: 89.95,
    stock: 15,
    category: 'Accessories',
    imageUrls: const [
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800&q=80',
    ],
    sizes: const [],
    isAvailable: true,
    createdAt: DateTime(2026, 2, 15),
  ),
  ProductModel(
    id: 'prod_006',
    title: 'Smart Fitness Tracker Band',
    description: 'Continuous heart-rate monitoring with SpO2 sensor, sleep analytics, and 14-day battery life with 5ATM water resistance.',
    price: 59.99,
    stock: 0,
    category: 'Electronics',
    imageUrls: const [
      'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?w=800&q=80',
    ],
    sizes: const [],
    isAvailable: false,
    createdAt: DateTime(2026, 2, 18),
  ),
];
