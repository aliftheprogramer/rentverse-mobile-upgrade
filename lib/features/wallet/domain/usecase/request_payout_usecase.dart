import 'package:rentverse/core/usecase/usecase.dart';
import 'package:rentverse/features/wallet/domain/entity/payout_response_entity.dart';
import 'package:rentverse/features/wallet/domain/repository/wallet_repository.dart';

class RequestPayoutParams {
  final int amount;
  final String bankName;
  final String accountNo;
  final String accountName;
  final String? notes;

  RequestPayoutParams({
    required this.amount,
    required this.bankName,
    required this.accountNo,
    required this.accountName,
    this.notes,
  });
}

class RequestPayoutUseCase
    implements UseCase<PayoutResponseEntity, RequestPayoutParams> {
  final WalletRepository _repository;

  RequestPayoutUseCase(this._repository);

  @override
  Future<PayoutResponseEntity> call({RequestPayoutParams? param}) {
    if (param == null) throw ArgumentError('param required');
    return _repository.requestPayout(
      amount: param.amount,
      bankName: param.bankName,
      accountNo: param.accountNo,
      accountName: param.accountName,
      notes: param.notes,
    );
  }
}
