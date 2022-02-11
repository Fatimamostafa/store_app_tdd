import 'package:cc_flutter/src/core/platform/network_info.dart';
import 'package:cc_flutter/src/features/product/data/datasources/product_local_datasource.dart';
import 'package:cc_flutter/src/features/product/data/datasources/product_remote_datasource.dart';
import 'package:cc_flutter/src/features/product/data/models/product.dart';
import 'package:cc_flutter/src/features/product/data/repositories/product_repository_impl.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  group('getProductList', () {
    const productList = <ProductModel>[
      ProductModel(
        id: 1,
        title: 'title1',
        description: 'description1',
        category: 'category1',
        image: 'imageUrl1',
      ),
      ProductModel(
        id: 2,
        title: 'title2',
        description: 'description2',
        category: 'category2',
        image: 'imageUrl2',
      ),
    ];

    const List<ProductEntity> productEntityList = productList;

    test('should check if the device is online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getProductList();

      verify(() => mockNetworkInfo.isConnected);
    });

    group('deviceIsOnline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(() => mockRemoteDataSource.getProductList())
            .thenAnswer((_) async => productList);

        final result = await repository.getProductList();

        //assert
        verify(() => mockRemoteDataSource.getProductList());
        expect(result, const Right(productEntityList));
      });
    });

    group('deviceIsOffline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should check if the device is offline', () async {});
    });
  });
}