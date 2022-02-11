import 'dart:convert';

import 'package:cc_flutter/src/core/error/exception.dart';
import 'package:cc_flutter/src/features/product/data/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kCachedProductList = 'CACHED_PRODUCT_LIST';

abstract class ProductLocalDataSource {
  /// Gets cached list of [ProductModel] from the last fetch.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<ProductModel>>? getProductItems();

  Future<void>? cacheProductList(List<ProductModel> list);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void>? cacheProductList(List<ProductModel> list) {
    return sharedPreferences.setString(
        kCachedProductList, json.encode(list));
  }

  @override
  Future<List<ProductModel>>? getProductItems() {
    final jsonString = sharedPreferences.getString(kCachedProductList);
    if (jsonString != null) {
      final productList = (jsonDecode(jsonString) as List)
          .map((i) => ProductModel.fromJson(i))
          .toList();
      return Future.value(productList);
    } else {
      throw CacheException();
    }
  }
}
