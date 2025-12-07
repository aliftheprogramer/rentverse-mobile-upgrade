import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/role/tenant/presentation/cubit/receipt_booking/state.dart';

class ReceiptBookingCubit extends Cubit<ReceiptBookingState> {
  ReceiptBookingCubit(BookingResponseEntity response)
    : super(ReceiptBookingState(response: response));
}
