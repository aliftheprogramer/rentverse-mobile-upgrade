import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/common/utils/network_utils.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/booking_request/cubit.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/booking_request/state.dart';
import 'package:rentverse/role/lanlord/presentation/pages/booking_detail.dart';
import 'package:rentverse/role/lanlord/widget/my_property/property_components.dart';

class RequestTab extends StatelessWidget {
  const RequestTab({super.key});

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
                Text(state.error ?? 'Failed to load booking requests'),
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

        if (state.requests.isEmpty) {
          return const EmptyState(message: 'No booking requests yet');
        }

        return RefreshIndicator(
          onRefresh: () => context.read<LandlordBookingRequestCubit>().load(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = state.requests[index];
              return _BookingRequestCard(item: item);
            },
          ),
        );
      },
    );
  }
}

class _BookingRequestCard extends StatelessWidget {
  const _BookingRequestCard({required this.item});

  final BookingListItemEntity item;

  @override
  Widget build(BuildContext context) {
    final isPending = item.status == 'PENDING';
    final isPendingPayment = item.status == 'PENDING_PAYMENT';
    final showActions = isPending || isPendingPayment;
    final state = context.watch<LandlordBookingRequestCubit>().state;
    final isWorking = state.isActionLoading && state.actionBookingId == item.id;

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
          decoration: BoxDecoration(
            color: Colors.white,
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
                        _StatusBadge(label: item.status),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (showActions)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        onPressed: isWorking
                            ? null
                            : () => context
                                  .read<LandlordBookingRequestCubit>()
                                  .rejectBooking(item.id),
                        child: isWorking
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Reject booking'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1CD8D2),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isWorking
                            ? null
                            : () => context
                                  .read<LandlordBookingRequestCubit>()
                                  .confirmBooking(item.id),
                        child: isWorking
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Accept booking'),
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
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isPendingPayment = label == 'PENDING_PAYMENT';
    final isPending = label == 'PENDING';
    if (isPendingPayment) return const SizedBox.shrink();
    Color color;
    if (isPending) {
      color = const Color(0xFF1CD8D2);
    } else {
      color = Colors.blueGrey;
    }

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
