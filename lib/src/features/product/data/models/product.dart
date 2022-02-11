import 'package:cc_flutter/src/features/product/domain/entities/product.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

part 'product.g.dart';

@freezed
class ProductModel with _$ProductModel implements ProductEntity {
  const factory ProductModel({
    required int id,
    required String title,
    required String description,
    required String category,
    required String image,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
