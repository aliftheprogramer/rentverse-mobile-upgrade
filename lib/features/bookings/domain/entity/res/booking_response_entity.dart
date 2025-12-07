class BookingResponseEntity {
  final String bookingId;
  final String invoiceId;
  final String status;
  final int amount;
  final String currency;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final BookingBillingPeriodEntity? billingPeriod;
  final DateTime? paymentDeadline;
  final BookingPropertySummaryEntity? property;
  final String? message;

  const BookingResponseEntity({
    required this.bookingId,
    required this.invoiceId,
    required this.status,
    required this.amount,
    required this.currency,
    this.checkIn,
    this.checkOut,
    this.billingPeriod,
    this.paymentDeadline,
    this.property,
    this.message,
  });
}

class BookingBillingPeriodEntity {
  final int id;
  final String slug;
  final String label;
  final int durationMonths;

  const BookingBillingPeriodEntity({
    required this.id,
    required this.slug,
    required this.label,
    required this.durationMonths,
  });
}

class BookingPropertySummaryEntity {
  final String id;
  final String title;
  final String address;
  final String imageUrl;

  const BookingPropertySummaryEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.imageUrl,
  });
}
