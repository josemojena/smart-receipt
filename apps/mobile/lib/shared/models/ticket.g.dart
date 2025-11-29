// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ticket _$TicketFromJson(Map<String, dynamic> json) => _Ticket(
  id: json['id'] as String,
  storeName: json['storeName'] as String,
  date: DateTime.parse(json['date'] as String),
  products: (json['products'] as List<dynamic>)
      .map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
  transactionId: json['transactionId'] as String?,
  time: json['time'] as String?,
  finalTotal: (json['finalTotal'] as num?)?.toDouble(),
  taxBreakdown:
      (json['taxBreakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
);

Map<String, dynamic> _$TicketToJson(_Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'storeName': instance.storeName,
  'date': instance.date.toIso8601String(),
  'products': instance.products,
  'transactionId': instance.transactionId,
  'time': instance.time,
  'finalTotal': instance.finalTotal,
  'taxBreakdown': instance.taxBreakdown,
};
