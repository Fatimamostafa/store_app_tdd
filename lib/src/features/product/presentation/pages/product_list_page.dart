// ignore_for_file: sized_box_for_whitespace

import 'package:cc_flutter/injection_container.dart';
import 'package:cc_flutter/src/features/product/presentation/bloc/product_bloc.dart';
import 'package:cc_flutter/src/features/product/presentation/widgets/product_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/widgets.dart';

/// Displays a list of Products.
class ProductListPage extends StatelessWidget {
  const ProductListPage({Key? key}) : super(key: key);

  static const routeName = '/product-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: buildBody(context));
  }

  BlocProvider<ProductBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(GetProductList()),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is Empty) {
            return const MessageDisplay(message: 'Start searching');
          } else if (state is Loading) {
            return const LoadingWidget();
          } else if (state is Loaded) {
            return ProductDisplay(list: state.productList);
          } else if (state is Error) {
            return MessageDisplay(message: state.message);
          }
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: const Placeholder(),
          );
        },
      ),
    );
  }
}
