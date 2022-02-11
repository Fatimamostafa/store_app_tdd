import 'dart:convert';

import 'package:cc_flutter/src/core/error/exception.dart';
import 'package:cc_flutter/src/features/product/data/datasources/product_local_datasource.dart';
import 'package:cc_flutter/src/features/product/data/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ProductLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl =
        ProductLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  final productList = (jsonDecode(fixture('product_list.json')) as List)
      .map((i) => ProductModel.fromJson(i))
      .toList();

  group('get last cached list', () {
    test('should return product list from SharedPreference if cached',
        () async {
      //arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('product_list.json'));

      //act
      final result = await dataSourceImpl.getProductItems();

      //assert
      verify(() => mockSharedPreferences.getString(kCachedProductList));
      expect(result, equals(productList));
    });

    test('should throw CacheException if SharedPreference empty', () async {
      //arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);

      //assert
      expect(() => dataSourceImpl.getProductItems(),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cache product list', () {
    test('should call SharedPreferences to cache the data', () async {
      //arrange
      when(() => mockSharedPreferences.setString(kCachedProductList, jsonEncode(productList)))
          .thenAnswer((_) => Future.value(true));

      //act
      dataSourceImpl.cacheProductList(productList);

      //assert
      verify(() => mockSharedPreferences.setString(kCachedProductList, jsonEncode(productList)));
    });
  });
}
