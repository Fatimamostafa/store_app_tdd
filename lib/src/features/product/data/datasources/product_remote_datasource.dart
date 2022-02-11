import 'package:cc_flutter/src/features/product/data/models/product.dart';

abstract class ProductRemoteDataSource {
  /// Calls the https://fakestoreapi.com/products endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<ProductModel>?> getProductList();

  /// Calls the https://fakestoreapi.com/products/{id} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<ProductModel>? getProductDetails(int id);
}
