import 'package:cc_flutter/src/features/product/presentation/widgets/product_widget.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductDisplay extends StatelessWidget {
  final List<ProductEntity> list;

  const ProductDisplay({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 230,
        childAspectRatio: 1,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        mainAxisExtent: 250,
      ),
      physics: const PageScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ProductWidget(
          product: list[index],
        );
      },
    );
  }
}
