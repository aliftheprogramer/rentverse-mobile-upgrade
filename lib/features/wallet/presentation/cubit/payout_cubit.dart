import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rentverse/core/utils/error_utils.dart';
import 'package:rentverse/features/wallet/domain/entity/payout_response_entity.dart';
import 'package:rentverse/features/wallet/domain/usecase/request_payout_usecase.dart';

part 'payout_state.dart';

class PayoutCubit extends Cubit<PayoutState> {
  PayoutCubit(this._requestPayout) : super(const PayoutState.initial());

  final RequestPayoutUseCase _requestPayout;

  Future<void> submit(RequestPayoutParams params) async {
    emit(state.copyWith(status: PayoutStatus.loading, error: null));
    try {
      final res = await _requestPayout(param: params);
      emit(state.copyWith(status: PayoutStatus.success, result: res));
    }on DioException catch (e) {
      emit(
        state.copyWith(
          status: PayoutStatus.failure,
          error: resolveApiErrorMessage(e),
        ),
      );
    }
  }

  void reset() => emit(const PayoutState.initial());
}
