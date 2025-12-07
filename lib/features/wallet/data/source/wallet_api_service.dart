import 'package:rentverse/core/network/dio_client.dart';
import 'package:rentverse/features/wallet/data/models/my_wallet_response_model.dart';

abstract class WalletApiService {
  Future<MyWalletResponseModel> getWallet();
}

class WalletApiServiceImpl implements WalletApiService {
  final DioClient _dioClient;

  WalletApiServiceImpl(this._dioClient);

  @override
  Future<MyWalletResponseModel> getWallet() async {
    try {
      final response = await _dioClient.get('/finance/wallet');
      return MyWalletResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}
