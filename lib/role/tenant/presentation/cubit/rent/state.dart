import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';

class RentState {
  final bool isLoading;
  final bool isPaying;
  final String? error;
  final List<BookingListItemEntity> pendingPayment;
  final List<BookingListItemEntity> active;
  final bool hasMore;
  final String? nextCursor;

  const RentState({
    this.isLoading = false,
    this.isPaying = false,
    this.error,
    this.pendingPayment = const [],
    this.active = const [],
    this.hasMore = false,
    this.nextCursor,
  });

  RentState copyWith({
    bool? isLoading,
    bool? isPaying,
    String? error,
    List<BookingListItemEntity>? pendingPayment,
    List<BookingListItemEntity>? active,
    bool? hasMore,
    String? nextCursor,
    bool resetError = false,
  }) {
    return RentState(
      isLoading: isLoading ?? this.isLoading,
      isPaying: isPaying ?? this.isPaying,
      error: resetError ? null : error ?? this.error,
      pendingPayment: pendingPayment ?? this.pendingPayment,
      active: active ?? this.active,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }
}
