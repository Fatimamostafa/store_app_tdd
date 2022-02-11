import 'package:cc_flutter/src/core/error/failure.dart';
import 'package:cc_flutter/src/core/usecase/usecase.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:cc_flutter/src/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductDetailsUseCase implements UseCase<ProductEntity, Params> {
  final ProductRepository repository;

  GetProductDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductEntity>?> call(Params params) async {
    return await repository.getProductDetails(params.productId);
  }
}

class Params {
  final int productId;

  Params(this.productId);
}
