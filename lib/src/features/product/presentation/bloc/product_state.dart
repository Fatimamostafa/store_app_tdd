part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class Empty extends ProductState {}

class Loading extends ProductState {}

class Loaded extends ProductState {
  final List<ProductEntity> productList;

  const Loaded({required this.productList});
}

class Error extends ProductState {
  final String message;

  const Error({required this.message});
}
