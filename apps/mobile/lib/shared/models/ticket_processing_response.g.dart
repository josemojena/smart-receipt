// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_processing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TicketProcessingResponse _$TicketProcessingResponseFromJson(
  Map<String, dynamic> json,
) => _TicketProcessingResponse(
  success: json['success'] as bool,
  data: json['data'] == null
      ? null
      : TicketData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TicketProcessingResponseToJson(
  _TicketProcessingResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};
