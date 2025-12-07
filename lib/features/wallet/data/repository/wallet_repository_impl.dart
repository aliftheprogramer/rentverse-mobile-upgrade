import 'package:rentverse/features/wallet/data/source/wallet_api_service.dart';
import 'package:rentverse/features/wallet/domain/entity/my_wallet_response_entity.dart';
import 'package:rentverse/features/wallet/domain/repository/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletApiService _apiService;

  WalletRepositoryImpl(this._apiService);

  @override
  Future<WalletEntity> getWallet() async {
    final res = await _apiService.getWallet();
    return res.toEntity();
  }
}
