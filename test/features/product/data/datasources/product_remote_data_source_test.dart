import 'dart:convert';

import 'package:cc_flutter/src/core/error/exception.dart';
import 'package:cc_flutter/src/features/product/data/datasources/product_remote_datasource.dart';
import 'package:cc_flutter/src/features/product/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ProductRemoteDataSourceImpl remoteDataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = ProductRemoteDataSourceImpl(mockHttpClient);
  });

  setUpAll(() {
    registerFallbackValue(
        Uri.parse('https://fakestoreapi.com/products?limit=5'));
  });

  void setMockHttpClientSuccess() {
    when(() => mockHttpClient
            .get(any(), headers: {'Content-Type': 'application/json'}))
        .thenAnswer(
            (_) async => http.Response(fixture('product_list.json'), 200));
  }

  final productList = (jsonDecode(fixture('product_list.json')) as List)
      .map((i) => ProductModel.fromJson(i))
      .toList();

  group('get product', () {
    test('should perform a GET request to fetch product list', () async {
      //arrange
      setMockHttpClientSuccess();

      //act
      remoteDataSource.getProductList();

      //assert
      verify(() => mockHttpClient.get(
            Uri.parse('https://fakestoreapi.com/products?limit=5'),
            headers: {'Content-Type': 'application/json'},
          ));
    });

    test('should return List<ProductModel> when success', () async {
      //arrange
      setMockHttpClientSuccess();

      //act
      final result = await remoteDataSource.getProductList();

      //assert
      expect(result, productList);
    });

    test('should throw ServerException when error', () async {
      //arrange
      when(() => mockHttpClient
              .get(any(), headers: {'Content-Type': 'application/json'}))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      //assert
      expect(remoteDataSource.getProductList(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
