import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/cardModel.dart';

class StripeService {
  static String paymentApiUrl = '${global.stripeBaseApi}/payment_intents';
  static String createCustomerUrl = '${global.stripeBaseApi}/customers';

  static Map<String, String> headers = {'Authorization': 'Bearer ${global.paymentGateway.stripe.stripSecret}', 'Content-Type': 'application/x-www-form-urlencoded'};

  static Future<Map<String, dynamic>> confirmPaymentIntent(String paymentIntentId, String paymentMethodId, {String customerId}) async {
    try {
      Map<String, dynamic> body = {'payment_method': paymentMethodId};
      var response = await http.post(Uri.parse('${global.stripeBaseApi}/payment_intents/$paymentIntentId/confirm'), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - confirmPaymentIntent(): ${err.toString()}');
    }
    return null;
  }

  static Future<Map<String, dynamic>> createCustomer({String source, String email}) async {
    try {
      Map<String, dynamic> body = {'email': email};
      var response = await http.post(Uri.parse(StripeService.createCustomerUrl), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - createCustomer():${err.toString()}');
    }
    return null;
  }

  static Future<Map<String, dynamic>> createPaymentIntent(int amount, String currency, {String customerId}) async {
    try {
      Map<String, dynamic> body = {'amount': amount.toString(), 'currency': 'INR', 'customer': customerId};
      var response = await http.post(Uri.parse(StripeService.paymentApiUrl), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - createPaymentIntent(): ${err.toString()}');
    }
    return null;
  }

  static Future<Map<String, dynamic>> createPaymentMethod(CardModel card) async {
    try {
      Map<String, dynamic> body = {'type': "card", 'card[number]': card.number.replaceAll(' ', ''), 'card[exp_month]': '${card.expiryMonth}', 'card[exp_year]': '${card.expiryYear}', "card[cvc]": card.cvv};
      var response = await http.post(Uri.parse('${global.stripeBaseApi}/payment_methods'), body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('Exception - stripe_payment_screen.dart - createPaymentMethod():${err.toString()}');
    }
    return null;
  }

  static getPlatformExceptionErrorResult(err) {
    String message = 'Something went wrong';
    if (err.code == 'cancelled') {
      message = 'Transaction cancelled';
    }

    return new StripeTransactionResponse(message: message, success: false);
  }
}

class StripeTransactionResponse {
  String message;
  bool success;
  StripeTransactionResponse({this.message, this.success});
}
