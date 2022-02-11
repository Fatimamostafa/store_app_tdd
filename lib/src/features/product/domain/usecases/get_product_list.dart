import 'package:cc_flutter/src/core/error/failure.dart';
import 'package:cc_flutter/src/core/usecase/usecase.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:cc_flutter/src/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductListUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;

  GetProductListUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>?> call(NoParams params) async {
    return await repository.getProductList();
  }
}


