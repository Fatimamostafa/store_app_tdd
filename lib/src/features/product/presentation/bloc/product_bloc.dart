import 'package:bloc/bloc.dart';
import 'package:cc_flutter/src/core/error/failure.dart';
import 'package:cc_flutter/src/core/usecase/usecase.dart';
import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:cc_flutter/src/features/product/domain/usecases/get_product_list.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/util/input_converter.dart';

part 'product_event.dart';

part 'product_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductListUseCase getProductList;
  final InputConverter inputConverter;

  ProductState get initialState => Empty();

  ProductBloc({
    required this.getProductList,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetProductList>((event, emit) async {
      emit(Loading());
      final response = await getProductList(NoParams());
      response!.fold((failure) {
        emit(Error(message: _mapFailureToMessage(failure)));
      }, (list) {
        emit(Loaded(productList: list));
      });
    });
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected error';
  }
}
