import 'package:rentverse/features/wallet/domain/entity/my_wallet_response_entity.dart';

abstract class WalletRepository {
  Future<WalletEntity> getWallet();
}
