import 'package:rentverse/features/wallet/domain/entity/my_wallet_response_entity.dart';
import 'package:rentverse/features/wallet/domain/entity/payout_response_entity.dart';

abstract class WalletRepository {
  Future<WalletEntity> getWallet();
  Future<PayoutResponseEntity> requestPayout({
    required int amount,
    required String bankName,
    required String accountNo,
    required String accountName,
    String? notes,
  });
}
