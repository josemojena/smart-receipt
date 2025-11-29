// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReceiptItem _$ReceiptItemFromJson(Map<String, dynamic> json) => _ReceiptItem(
  originalName: json['original_name'] as String?,
  normalizedName: json['normalized_name'] as String?,
  category: json['category'] as String?,
  quantity: (json['quantity'] as num?)?.toDouble(),
  unitOfMeasure: json['unit_of_measure'] as String?,
  baseQuantity: (json['base_quantity'] as num?)?.toDouble(),
  baseUnitName: json['base_unit_name'] as String?,
  paidPrice: (json['paid_price'] as num?)?.toDouble(),
  realUnitPrice: (json['real_unit_price'] as num?)?.toDouble(),
  originalQuantityRaw: json['original_quantity_raw'] as String?,
  originalUnitOfMeasureRaw: json['original_unit_of_measure_raw'] as String?,
  originalPriceRaw: (json['original_price_raw'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ReceiptItemToJson(_ReceiptItem instance) =>
    <String, dynamic>{
      'original_name': instance.originalName,
      'normalized_name': instance.normalizedName,
      'category': instance.category,
      'quantity': instance.quantity,
      'unit_of_measure': instance.unitOfMeasure,
      'base_quantity': instance.baseQuantity,
      'base_unit_name': instance.baseUnitName,
      'paid_price': instance.paidPrice,
      'real_unit_price': instance.realUnitPrice,
      'original_quantity_raw': instance.originalQuantityRaw,
      'original_unit_of_measure_raw': instance.originalUnitOfMeasureRaw,
      'original_price_raw': instance.originalPriceRaw,
    };
