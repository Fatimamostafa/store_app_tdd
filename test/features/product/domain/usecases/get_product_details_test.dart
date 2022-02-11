import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:cc_flutter/src/features/product/domain/repositories/product_repository.dart';
import 'package:cc_flutter/src/features/product/domain/usecases/get_product_details.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  int productId = 1;

  ProductEntity product = ProductEntity(
    id: productId,
    title: 'title1',
    description: 'description1',
    category: 'category1',
    image: 'imageUrl1',
  );

  test('should get product details from the repository', () async {
    final mockRepository = MockProductRepository();
    final useCase = GetProductDetailsUseCase(mockRepository);

    //arrange
    when(() => mockRepository.getProductDetails(any()))
        .thenAnswer((_) async => Right(product));

    //act
    final result = await useCase(Params(productId));

    //assert
    expect(result, Right(product));
    verify(() => mockRepository.getProductDetails(productId));
    verifyNoMoreInteractions(mockRepository);
  });
}
