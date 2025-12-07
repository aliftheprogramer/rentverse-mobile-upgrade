import 'package:logger/logger.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';

class BookingResponseModel {
  final String bookingId;
  final String invoiceId;
  final String status;
  final int amount;
  final String currency;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final BookingBillingPeriodModel? billingPeriod;
  final DateTime? paymentDeadline;
  final BookingPropertySummaryModel? property;
  final String? message;

  const BookingResponseModel({
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

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    Logger().i('Parsing booking response -> $json');
    final data = _asMap(json['data']);
    final propertyJson = _asMap(data['property']);
    final billingPeriodJson = _asMap(data['billingPeriod']);
    return BookingResponseModel(
      bookingId: data['bookingId'] as String? ?? '',
      invoiceId: data['invoiceId'] as String? ?? '',
      status: data['status'] as String? ?? '',
      amount: (data['amount'] as num?)?.toInt() ?? 0,
      currency: data['currency'] as String? ?? '',
      checkIn: _parseDate(data['checkIn'] as String?),
      checkOut: _parseDate(data['checkOut'] as String?),
      billingPeriod: billingPeriodJson.isEmpty
          ? null
          : BookingBillingPeriodModel.fromJson(billingPeriodJson),
      paymentDeadline: _parseDate(data['paymentDeadline'] as String?),
      property: propertyJson.isEmpty
          ? null
          : BookingPropertySummaryModel.fromJson(propertyJson),
      message: json['message'] as String?,
    );
  }

  BookingResponseEntity toEntity() {
    return BookingResponseEntity(
      bookingId: bookingId,
      invoiceId: invoiceId,
      status: status,
      amount: amount,
      currency: currency,
      checkIn: checkIn,
      checkOut: checkOut,
      billingPeriod: billingPeriod?.toEntity(),
      paymentDeadline: paymentDeadline,
      property: property?.toEntity(),
      message: message,
    );
  }
}

class BookingBillingPeriodModel {
  final int id;
  final String slug;
  final String label;
  final int durationMonths;

  const BookingBillingPeriodModel({
    required this.id,
    required this.slug,
    required this.label,
    required this.durationMonths,
  });

  factory BookingBillingPeriodModel.fromJson(Map<String, dynamic> json) {
    return BookingBillingPeriodModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String? ?? '',
      label: json['label'] as String? ?? '',
      durationMonths: (json['durationMonths'] as num?)?.toInt() ?? 0,
    );
  }

  BookingBillingPeriodEntity toEntity() {
    return BookingBillingPeriodEntity(
      id: id,
      slug: slug,
      label: label,
      durationMonths: durationMonths,
    );
  }
}

class BookingPropertySummaryModel {
  final String id;
  final String title;
  final String address;
  final String imageUrl;

  const BookingPropertySummaryModel({
    required this.id,
    required this.title,
    required this.address,
    required this.imageUrl,
  });

  factory BookingPropertySummaryModel.fromJson(Map<String, dynamic> json) {
    return BookingPropertySummaryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      address: json['address'] as String? ?? '',
      imageUrl: json['image'] as String? ?? json['imageUrl'] as String? ?? '',
    );
  }

  BookingPropertySummaryEntity toEntity() {
    return BookingPropertySummaryEntity(
      id: id,
      title: title,
      address: address,
      imageUrl: imageUrl,
    );
  }
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
