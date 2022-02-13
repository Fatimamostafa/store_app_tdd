import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductWidget extends StatelessWidget {
  final ProductEntity product;

  const ProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.2,
              ),
              spreadRadius: 3.0,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 120,
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(75),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              product.category,
              style: const TextStyle(
                color: Color(0xFFF17532),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Text(
                product.title,
                style: const TextStyle(
                  color: Color(0xFF575E67),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
