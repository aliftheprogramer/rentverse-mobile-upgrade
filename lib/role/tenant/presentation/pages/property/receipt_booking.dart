import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/role/tenant/presentation/cubit/receipt_booking/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/receipt_booking/state.dart';

class ReceiptBookingPage extends StatelessWidget {
  const ReceiptBookingPage({super.key, required this.response});

  final BookingResponseEntity response;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReceiptBookingCubit(response),
      child: Scaffold(
        appBar: AppBar(title: const Text('Receipt Booking'), centerTitle: true),
        body: BlocBuilder<ReceiptBookingCubit, ReceiptBookingState>(
          builder: (context, state) {
            final res = state.response;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row(label: 'Booking ID', value: res.bookingId),
                    _Row(label: 'Invoice ID', value: res.invoiceId),
                    _Row(label: 'Status', value: res.status),
                    _Row(
                      label: 'Amount',
                      value: '${res.amount} ${res.currency}',
                    ),
                    _Row(label: 'Message', value: res.message ?? '-'),
                    const SizedBox(height: 12),
                    _Row(label: 'Check In', value: _fmtDate(res.checkIn)),
                    _Row(label: 'Check Out', value: _fmtDate(res.checkOut)),
                    _Row(
                      label: 'Payment Deadline',
                      value: _fmtDate(res.paymentDeadline),
                    ),
                    const SizedBox(height: 12),
                    if (res.billingPeriod != null) ...[
                      _Row(
                        label: 'Billing Period',
                        value: res.billingPeriod!.label,
                      ),
                      _Row(
                        label: 'Duration (months)',
                        value: res.billingPeriod!.durationMonths.toString(),
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (res.property != null) ...[
                      _Row(label: 'Property Title', value: res.property!.title),
                      _Row(
                        label: 'Property Address',
                        value: res.property!.address,
                      ),
                      _Row(label: 'Property ID', value: res.property!.id),
                      _Row(
                        label: 'Primary Image',
                        value: res.property!.imageUrl,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}

String _fmtDate(DateTime? date) {
  if (date == null) return '-';
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
