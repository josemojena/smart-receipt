// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ticket _$TicketFromJson(Map<String, dynamic> json) => _Ticket(
  id: (json['id'] as num).toInt(),
  storeName: json['storeName'] as String,
  date: DateTime.parse(json['date'] as String),
  products: (json['products'] as List<dynamic>)
      .map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TicketToJson(_Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'storeName': instance.storeName,
  'date': instance.date.toIso8601String(),
  'products': instance.products,
};
