import 'dart:convert';

import 'package:cc_flutter/src/core/error/exception.dart';
import 'package:cc_flutter/src/core/error/failure.dart';
import 'package:cc_flutter/src/core/network/network_info.dart';
import 'package:cc_flutter/src/features/product/data/datasources/product_local_datasource.dart';
import 'package:cc_flutter/src/features/product/data/datasources/product_remote_datasource.dart';
import 'package:cc_flutter/src/features/product/data/models/product.dart';
import 'package:cc_flutter/src/features/product/data/repositories/product_repository_impl.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock implements ProductRemoteDataSource {}

class MockLocalDataSource extends Mock implements ProductLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late ProductRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getProductList', () {
    final productList = (jsonDecode(fixture('product_list.json')) as List)
        .map((i) => ProductModel.fromJson(i))
        .toList();

    List<ProductEntity> productEntityList = productList;

    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(() => mockRemoteDataSource.getProductList())
          .thenAnswer((_) async => productList);

      repository.getProductList();

      verify(() => mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(() => mockRemoteDataSource.getProductList())
            .thenAnswer((_) async => productList);

        final result = await repository.getProductList();

        //assert
        verify(() => mockRemoteDataSource.getProductList());
        expect(result, equals(Right(productEntityList)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(() => mockRemoteDataSource.getProductList())
            .thenAnswer((_) async => productList);

        await repository.getProductList();

        //assert
        verify(() => mockRemoteDataSource.getProductList());
        verify(() => mockLocalDataSource.cacheProductList(productList));
      });
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      when(() => mockRemoteDataSource.getProductList())
          .thenThrow((ServerException()));

      final result = await repository.getProductList();

      //assert
      verify(() => mockRemoteDataSource.getProductList());
      verifyZeroInteractions(mockLocalDataSource);

      expect(result, equals(Left(ServerFailure())));
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(() => mockLocalDataSource.getProductItems())
            .thenAnswer((_) async => productList);

        final result = await repository.getProductList();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getProductItems());

        expect(result, equals(Right(productEntityList)));
      });

      test('should return failure when the cached data is not present',
          () async {
        when(() => mockLocalDataSource.getProductItems())
            .thenThrow(CacheException());

        final result = await repository.getProductList();

        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getProductItems());

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
