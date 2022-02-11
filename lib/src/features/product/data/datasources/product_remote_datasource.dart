import 'dart:convert';

import 'package:cc_flutter/src/features/product/data/models/product.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exception.dart';

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

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<ProductModel>? getProductDetails(int id) {
    // TODO: implement getProductDetails
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>?> getProductList() async {
    final response = await client.get(
        Uri.parse('https://fakestoreapi.com/products?limit=5'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => ProductModel.fromJson(i))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
