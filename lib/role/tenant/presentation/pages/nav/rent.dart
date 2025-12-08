import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';
import 'package:rentverse/features/bookings/domain/usecase/get_bookings_usecase.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/features/midtrans/domain/usecase/pay_invoice_usecase.dart';
import 'package:rentverse/role/tenant/presentation/pages/rent/midtrans_payment_page.dart';
import 'package:rentverse/role/tenant/presentation/cubit/rent/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/rent/state.dart';

class TenantRentPage extends StatelessWidget {
  const TenantRentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocProvider(
        create: (_) =>
            RentCubit(sl<GetBookingsUseCase>(), sl<PayInvoiceUseCase>())
              ..load(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFF5F5F5),
            elevation: 0,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const Text(
              'My Booking',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
            ],
            bottom: const TabBar(
              indicatorColor: Color(0xFF1CD8D2),
              labelColor: Color(0xFF1CD8D2),
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'PENDING_PAYMENT'),
                Tab(text: 'ACTIVE'),
              ],
            ),
          ),
          body: BlocBuilder<RentCubit, RentState>(
            builder: (context, state) {
              if (state.error != null) {
                return Center(child: Text(state.error!));
              }

              return TabBarView(
                children: [
                  _BookingList(
                    statusLabel: 'Approved by the owner',
                    items: state.pendingPayment,
                    buttonLabel: 'Go to Payment',
                    isPaying: state.isPaying,
                    onPay: (item) => _handlePayment(context, item),
                  ),
                  _BookingList(
                    statusLabel: 'Active Booking',
                    items: state.active,
                    buttonLabel: 'View Detail',
                    isPaying: state.isPaying,
                    onPay: (item) => _handlePayment(context, item),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({
    required this.statusLabel,
    required this.items,
    required this.buttonLabel,
    required this.isPaying,
    required this.onPay,
  });

  final String statusLabel;
  final List<BookingListItemEntity> items;
  final String buttonLabel;
  final bool isPaying;
  final void Function(BookingListItemEntity) onPay;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = items[index];
        return _BookingListItemCard(
          statusLabel: statusLabel,
          title: item.property.title,
          city: item.property.city,
          imageUrl: item.property.image,
          buttonLabel: buttonLabel,
          onTap: () => onPay(item),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: items.length,
    );
  }
}

class _BookingListItemCard extends StatelessWidget {
  const _BookingListItemCard({
    required this.statusLabel,
    required this.title,
    required this.city,
    required this.imageUrl,
    required this.buttonLabel,
    required this.onTap,
  });

  final String statusLabel;
  final String title;
  final String city;
  final String imageUrl;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check, color: Color(0xFF00C853), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    statusLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 100,
                      height: 90,
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                city,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1CD8D2), Color(0xFF0097F6)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: onTap, // Always enable button
                              child: Text(
                                buttonLabel,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
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

Future<void> _handlePayment(
  BuildContext context,
  BookingListItemEntity item,
) async {
  final cubit = context.read<RentCubit>();
  final payment = await cubit.payInvoice(item.payment.invoiceId);
  if (payment == null) return;
  if (!context.mounted) return;

  final booking = _mapToBookingResponse(item);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MidtransPaymentPage(
        booking: booking,
        redirectUrl: payment.redirectUrl,
      ),
    ),
  );
}

BookingResponseEntity _mapToBookingResponse(BookingListItemEntity item) {
  return BookingResponseEntity(
    bookingId: item.id,
    invoiceId: item.payment.invoiceId,
    status: item.status,
    amount: item.payment.amount,
    currency: item.payment.currency,
    checkIn: item.startDate,
    checkOut: item.endDate,
    billingPeriod: null,
    paymentDeadline: null,
    property: BookingPropertySummaryEntity(
      id: item.property.id,
      title: item.property.title,
      address: item.property.city,
      imageUrl: item.property.image,
    ),
    message: null,
  );
}
