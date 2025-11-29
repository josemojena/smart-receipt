// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TicketData _$TicketDataFromJson(Map<String, dynamic> json) => _TicketData(
  store: json['store'] as String?,
  transactionId: json['transaction_id'] as String?,
  date: json['date'] as String?,
  time: json['time'] as String?,
  finalTotal: (json['final_total'] as num?)?.toDouble(),
  taxBreakdown:
      (json['tax_breakdown'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  items: (json['items'] as List<dynamic>)
      .map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TicketDataToJson(_TicketData instance) =>
    <String, dynamic>{
      'store': instance.store,
      'transaction_id': instance.transactionId,
      'date': instance.date,
      'time': instance.time,
      'final_total': instance.finalTotal,
      'tax_breakdown': instance.taxBreakdown,
      'items': instance.items,
    };
