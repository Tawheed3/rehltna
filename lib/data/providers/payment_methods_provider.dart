import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/payment_method_model.dart';
import 'base_provider.dart';

class PaymentMethodsProvider extends BaseProvider {
  List<PaymentMethodModel> _paymentMethods = [];
  List<PaymentMethodModel> get paymentMethods => _paymentMethods;

  Future<void> fetchPaymentMethods() async {
    startLoading();
    final data = await getRequest('payment-methods');
    developer.log(
      '[payment-methods] Response:\n${const JsonEncoder.withIndent('  ').convert(data)}',
      name: BaseProvider.logTag,
    );
    if (data != null && data['code'] == 200 && data['data'] != null) {
      _paymentMethods = (data['data'] as List)
          .map((item) => PaymentMethodModel.fromJson(item))
          .toList();
    }
    stopLoading();
  }

  Future<Map<String, dynamic>?> checkCoupon({
    required String email,
    required List<Map<String, dynamic>> items,
    String? couponCode,
    bool usePoints = false,
  }) async {
    startLoading();
    final body = {
      "email": email,
      "use_points": usePoints,
      "coupon_code": couponCode ?? "",
      "items": items,
    };
    final data = await postRequest('check-coupon', body);
    stopLoading();
    return data;
  }

  Future<Map<String, dynamic>?> checkout({
    required String name,
    required String email,
    required String phone,
    required String paymentMethodCode,
    String? applePayToken,
    String? couponCode,
    bool usePoints = false, // ✅ أضفناها
    required List<Map<String, dynamic>> items,
  }) async {
    startLoading();
    final body = {
      "source": "app",
      "name": name,
      "email": email,
      "phone": phone,
      "payment_method_code": paymentMethodCode,
      "apple_pay_token": applePayToken,
      "coupon_code": couponCode,
      "use_points": usePoints, // ✅ إرسال use_points
      "items": items,
    };
    final data = await postRequest('checkout', body);
    stopLoading();
    return data;
  }

  Future<Map<String, dynamic>?> uploadReceipt({
    required int orderId,
    required String transactionToken,
    required String receiptPath,
  }) async {
    final url = '${BaseProvider.baseUrl}/upload-receipt';
    startLoading();
    try {
      final fields = {
        'order_id': orderId.toString(),
        'transaction_token': transactionToken,
        'receipt': receiptPath,
      };
      logRequest('POST-MULTIPART', url, body: fields);

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'X-API-Key': BaseProvider.XApiKey,
        'X-Tenant-ID': BaseProvider.XTenantID.toString(),
      });
      request.fields['order_id'] = orderId.toString();
      request.fields['transaction_token'] = transactionToken;
      request.files.add(await http.MultipartFile.fromPath('receipt', receiptPath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      logResponse('POST-MULTIPART', url, response.statusCode, response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          setError(errorBody['message'] ?? 'خطأ في رفع الإيصال');
          return errorBody;
        } catch (e) {
          setError('خطأ في رفع الإيصال: ${response.statusCode}');
          return null;
        }
      }
    } catch (e) {
      logError('POST-MULTIPART', url, e);
      setError('حدث خطأ: $e');
      return null;
    } finally {
      stopLoading();
    }
  }

  List<PaymentMethodModel> getBankTransfers() =>
      _paymentMethods.where((m) => m.isBankTransfer).toList();

  PaymentMethodModel? getTamara() {
    try {
      return _paymentMethods.firstWhere((m) => m.isTamara); } catch (e) { return null; }
  }
}