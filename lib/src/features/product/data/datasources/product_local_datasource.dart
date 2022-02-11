import 'package:cc_flutter/src/features/product/data/models/product.dart';

abstract class ProductLocalDataSource {
  /// Gets cached list of [ProductModel] from the last fetch.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ProductModel>>? getProductItems();

  Future<void>? cacheProductList(List<ProductModel> list);
}
