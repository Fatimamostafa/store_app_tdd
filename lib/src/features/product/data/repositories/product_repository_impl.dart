import 'package:cc_flutter/src/core/error/exception.dart';
import 'package:cc_flutter/src/core/error/failure.dart';
import 'package:cc_flutter/src/features/product/data/datasources/product_remote_datasource.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:cc_flutter/src/features/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/network/network_info.dart';
import '../datasources/product_local_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductEntity>> getProductDetails(int id) {
    // TODO: implement getProductDetails
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductList() async {
    if (await networkInfo.isConnected == true) {
      try {
        final result = await remoteDataSource.getProductList();
        localDataSource.cacheProductList(result!);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localProductList = await localDataSource.getProductItems();
        return Right(localProductList as List<ProductEntity>);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
