import 'package:rentverse/core/usecase/usecase.dart';
import 'package:rentverse/features/wallet/domain/entity/my_wallet_response_entity.dart';
import 'package:rentverse/features/wallet/domain/repository/wallet_repository.dart';

class GetWalletUseCase implements UseCase<WalletEntity, void> {
  final WalletRepository _repository;

  GetWalletUseCase(this._repository);

  @override
  Future<WalletEntity> call({void param}) {
    return _repository.getWallet();
  }
}
