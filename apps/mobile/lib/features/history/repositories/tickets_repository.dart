import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_receipt_mobile/shared/models/failure.dart';
import 'package:smart_receipt_mobile/shared/models/ticket.dart';
import 'package:smart_receipt_mobile/shared/models/ticket_data.dart';

/// Repository for managing tickets
class TicketsRepository {
  final Dio _dio;

  TicketsRepository(this._dio);

  /// Get all tickets from the server
  ///
  /// Returns Either<Failure, List<Ticket>>
  /// Left: Failure if something went wrong
  /// Right: List of tickets
  Future<Either<Failure, List<Ticket>>> getTickets() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/tickets');

      // Check status code
      if (response.statusCode != 200) {
        final errorData = response.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? (errorData['message'] ?? errorData['error'] ?? 'Unknown error')
                  .toString()
            : 'Server returned status ${response.statusCode}';

        return Left(
          Failure.server(
            message: errorMessage,
            statusCode: response.statusCode ?? 500,
            errorData: errorData is Map<String, dynamic> ? errorData : null,
          ),
        );
      }

      // Parse response
      final data = response.data;
      if (data == null) {
        return const Left(
          Failure.unknown(message: 'Empty response from server'),
        );
      }

      try {
        // The API returns: { "success": true, "data": [...] }
        if (!data.containsKey('data') || data['data'] is! List) {
          return const Left(
            Failure.validation(
              message:
                  'Invalid response format: expected object with data array',
            ),
          );
        }

        final ticketsList = data['data'] as List<dynamic>;

        // Convert each ticket data to Ticket model
        // The API returns tickets in format: { id, store, transactionId, date, time, finalTotal, taxBreakdown, items }
        final tickets = ticketsList
            .map((ticketJson) {
              try {
                if (ticketJson is Map<String, dynamic>) {
                  // Map the API response to TicketData format
                  final ticketDataMap = <String, dynamic>{
                    'store': ticketJson['store'],
                    'transaction_id': ticketJson['transactionId'],
                    'date': ticketJson['date'],
                    'time': ticketJson['time'],
                    'final_total': ticketJson['finalTotal'],
                    'tax_breakdown':
                        (ticketJson['taxBreakdown'] as Map<String, dynamic>?) ??
                        <String, double>{},
                    'items':
                        (ticketJson['items'] as List<dynamic>?)
                            ?.map((item) {
                              if (item is Map<String, dynamic>) {
                                return {
                                  'original_name': item['originalName'],
                                  'normalized_name': item['normalizedName'],
                                  'category': item['category'],
                                  'quantity': item['quantity'],
                                  'unit_of_measure': item['unitOfMeasure'],
                                  'base_quantity': item['baseQuantity'],
                                  'base_unit_name': item['baseUnitName'],
                                  'paid_price': item['paidPrice'],
                                  'real_unit_price': item['realUnitPrice'],
                                  'original_quantity_raw': null,
                                  'original_unit_of_measure_raw': null,
                                  'original_price_raw': null,
                                };
                              }
                              return null;
                            })
                            .whereType<Map<String, dynamic>>()
                            .toList() ??
                        [],
                  };

                  // Parse as TicketData and convert to Ticket
                  final ticketData = TicketData.fromJson(ticketDataMap);
                  return Ticket.fromTicketData(
                    ticketData,
                    id: ticketJson['id']?.toString() ?? '',
                  );
                }
                return null;
              } catch (e) {
                return null;
              }
            })
            .whereType<Ticket>()
            .toList();

        return Right(tickets);
      } catch (e) {
        return Left(
          Failure.validation(
            message: 'Failed to parse tickets',
            errors: ['Error: $e'],
          ),
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // Server returned an error response
        final statusCode = e.response!.statusCode ?? 500;
        final errorData = e.response!.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? (errorData['message'] ??
                      errorData['error'] ??
                      e.message ??
                      'Unknown error')
                  .toString()
            : e.message ?? 'Unknown error';

        return Left(
          Failure.server(
            message: errorMessage,
            statusCode: statusCode,
            errorData: errorData is Map<String, dynamic> ? errorData : null,
          ),
        );
      }

      // Network error (no response)
      return Left(
        Failure.network(
          message: e.message ?? 'Network error occurred',
          statusCode: null,
        ),
      );
    } catch (e) {
      return Left(
        Failure.unknown(
          message: 'Unexpected error: ${e.toString()}',
          error: e,
        ),
      );
    }
  }
}
