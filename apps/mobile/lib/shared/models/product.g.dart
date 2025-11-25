// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  name: json['name'] as String,
  unitPrice: (json['unitPrice'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'name': instance.name,
  'unitPrice': instance.unitPrice,
  'quantity': instance.quantity,
};
