import 'package:dio/dio.dart';
import 'package:rentverse/core/network/dio_client.dart';
import 'package:rentverse/features/wallet/data/models/my_wallet_response_model.dart';
import 'package:rentverse/features/wallet/data/models/payout_response_model.dart';
import 'package:rentverse/core/utils/error_utils.dart';

abstract class WalletApiService {
  Future<MyWalletResponseModel> getWallet();
  Future<PayoutResponseModel> requestPayout({
    required int amount,
    required String bankName,
    required String accountNo,
    required String accountName,
    String? notes,
  });
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
    } on DioException catch (e) {
      throw Exception(resolveApiErrorMessage(e));
    }
  }

  @override
  Future<PayoutResponseModel> requestPayout({
    required int amount,
    required String bankName,
    required String accountNo,
    required String accountName,
    String? notes,
  }) async {
    try {
      final body = {
        'amount': amount,
        'bankName': bankName,
        'accountNo': accountNo,
        'accountName': accountName,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      final response = await _dioClient.post('/finance/payout', data: body);
      return PayoutResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(resolveApiErrorMessage(e));
    }
  }
}
