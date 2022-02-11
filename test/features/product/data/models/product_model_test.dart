import 'dart:convert';

import 'package:cc_flutter/src/features/product/data/models/product.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const productModel = ProductModel(
    id: 1,
    title: 'title1',
    description: 'description1',
    category: 'category1',
    image: 'image1',
  );

  test('should be a subclass of Product entity', () async {
    expect(productModel, isA<ProductEntity>());
  });

  group('check json conversion', () {
    test('should return a valid model', () async {
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('product.json'));

      final result = ProductModel.fromJson(jsonMap);

      expect(result, productModel);
    });

    test('should return a JSON map', () async {
      final Map<String, dynamic> expectedMap =
          jsonDecode(fixture('product.json'));

      final result = productModel.toJson();

      expect(result, expectedMap);
    });
  });
}
