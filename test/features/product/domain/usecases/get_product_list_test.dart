import 'package:cc_flutter/src/core/usecase/usecase.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:cc_flutter/src/features/product/domain/repositories/product_repository.dart';
import 'package:cc_flutter/src/features/product/domain/usecases/get_product_list.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  List<Product> products = <Product>[
    const Product(
      id: 1,
      title: 'title1',
      description: 'description1',
      category: 'category1',
      image: 'imageUrl1',
    ),
    const Product(
      id: 2,
      title: 'title2',
      description: 'description2',
      category: 'category2',
      image: 'imageUrl2',
    ),
  ];

  test('should get product list from the repository', () async {
    final mockRepository = MockProductRepository();
    GetProductListUseCase useCase = GetProductListUseCase(mockRepository);

    //arrange
    when(() => mockRepository.getProductList())
        .thenAnswer((_) async => Right(products));

    //act
    final result = await useCase(NoParams());

    //assert
    expect(result, Right(products));
    verify(() => mockRepository.getProductList());
    verifyNoMoreInteractions(mockRepository);
  });
}
