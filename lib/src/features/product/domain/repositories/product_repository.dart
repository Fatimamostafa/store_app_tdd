import 'package:cc_flutter/src/core/error/failure.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProductList();

  Future<Either<Failure, Product>> getProductDetails(int id);
}
