import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_receipt_mobile/shared/models/ticket_data.dart';

part 'ticket_processing_response.freezed.dart';
part 'ticket_processing_response.g.dart';

/// Response from ticket processing endpoint
@freezed
sealed class TicketProcessingResponse with _$TicketProcessingResponse {
  const factory TicketProcessingResponse({
    required bool success,
    required TicketData? data,
  }) = _TicketProcessingResponse;

  factory TicketProcessingResponse.fromJson(Map<String, dynamic> json) =>
      _$TicketProcessingResponseFromJson(json);
}
