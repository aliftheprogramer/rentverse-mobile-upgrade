import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/common/utils/network_utils.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/booking_request/cubit.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/booking_request/state.dart';
import 'package:rentverse/role/lanlord/presentation/pages/booking_detail.dart';
import 'package:rentverse/role/lanlord/widget/my_property/property_components.dart';

class PaymentTab extends StatelessWidget {
  const PaymentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      LandlordBookingRequestCubit,
      LandlordBookingRequestState
    >(
      builder: (context, state) {
        if (state.status == LandlordBookingRequestStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == LandlordBookingRequestStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.error ?? 'Failed to load payments'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      context.read<LandlordBookingRequestCubit>().load(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final pending = state.pendingPayments;
        final hasData = pending.isNotEmpty;

        if (!hasData) {
          return const EmptyState(message: 'No payment data yet');
        }

        return RefreshIndicator(
          onRefresh: () => context.read<LandlordBookingRequestCubit>().load(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle(label: 'Pending Payment'),
              const SizedBox(height: 8),
              ...pending
                  .map(
                    (item) => _PaymentCard(item: item, isPendingPayment: true),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.item, required this.isPendingPayment});

  final BookingListItemEntity item;
  final bool isPendingPayment;

  @override
  Widget build(BuildContext context) {
    final bgColor = isPendingPayment ? Colors.grey.shade200 : Colors.white;
    final badgeColor = isPendingPayment ? Colors.grey : const Color(0xFF1CD8D2);
    final paymentStatus = item.payment.status;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LandlordBookingDetailPage(booking: item),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PropertyThumb(item: item),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.property.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.property.city,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _dateRange(item.startDate, item.endDate),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _StatusBadge(label: paymentStatus, color: badgeColor),
                        const SizedBox(height: 4),
                        Text(
                          _formatAmount(
                            item.payment.currency,
                            item.payment.amount,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0C7B77),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyThumb extends StatelessWidget {
  const _PropertyThumb({required this.item});

  final BookingListItemEntity item;

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.property.image;
    final processedUrl = makeDeviceAccessibleUrl(imageUrl);

    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          processedUrl ?? imageUrl,
          width: 90,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              _PlaceholderBox(title: item.property.title),
        ),
      );
    }

    return _PlaceholderBox(title: item.property.title);
  }
}

class _PlaceholderBox extends StatelessWidget {
  const _PlaceholderBox({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final initial = title.isNotEmpty
        ? title.characters.first.toUpperCase()
        : '-';
    return Container(
      width: 90,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE7F9F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1CD8D2)),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0C7B77),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

String _dateRange(DateTime? start, DateTime? end) {
  if (start == null || end == null) return 'Tanggal tidak tersedia';
  final fmt = DateFormat('dd MMM yyyy');
  return '${fmt.format(start)} - ${fmt.format(end)}';
}

String _formatAmount(String currency, num amount) {
  try {
    final symbol = currency.toUpperCase() == 'IDR' ? 'Rp' : currency;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol.isNotEmpty ? '$symbol ' : 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  } catch (_) {
    return '$currency $amount';
  }
}
