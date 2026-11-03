import '../models/product_model.dart';

// Contract defining all product operations
abstract class ProductRepository {
  // Stream of all products
  Stream<List<ProductModel>> streamProducts();

  // One-time fetch of all products
  Future<List<ProductModel>> getProducts();

  // One-time fetch of a single product by ID
  Future<ProductModel?> getProductById(String id);

  // Add a new product
  Future<String> addProduct(ProductModel product);

  // Update an existing product
  Future<void> updateProduct(ProductModel product);

  // Delete a product
  Future<void> deleteProduct(String id);
}
