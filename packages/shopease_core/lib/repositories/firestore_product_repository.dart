import 'package:cloud_firestore/cloud_firestore.dart' hide sum;

import '../models/product_model.dart';
import 'product_repository.dart';

// Cloud Firestore implementation of ProductRepository
class FirestoreProductRepository implements ProductRepository {
  FirestoreProductRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('products');

  @override
  Stream<List<ProductModel>> streamProducts() {
    return _productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data(), documentId: doc.id);
      }).toList();
    });
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final snapshot = await _productsRef.get();
    return snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data(), documentId: doc.id);
    }).toList();
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return ProductModel.fromMap(doc.data()!, documentId: doc.id);
  }

  @override
  Future<String> addProduct(ProductModel product) async {
    final docId = product.id.trim();
    final docRef = docId.isNotEmpty
        ? _productsRef.doc(docId)
        : _productsRef.doc();

    final data = product.toMap()
      ..['id'] = docRef.id
      ..['createdAt'] = FieldValue.serverTimestamp()
      ..['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data);
    return docRef.id;
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final data = product.toMap()..['updatedAt'] = FieldValue.serverTimestamp();
    await _productsRef.doc(product.id).set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }
}
