part of 'payout_cubit.dart';

enum PayoutStatus { initial, loading, success, failure }

class PayoutState extends Equatable {
  final PayoutStatus status;
  final PayoutResponseEntity? result;
  final String? error;

  const PayoutState({required this.status, this.result, this.error});

  const PayoutState.initial()
    : this(status: PayoutStatus.initial, result: null, error: null);

  PayoutState copyWith({
    PayoutStatus? status,
    PayoutResponseEntity? result,
    String? error,
  }) {
    return PayoutState(
      status: status ?? this.status,
      result: result ?? this.result,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, result, error];
}
