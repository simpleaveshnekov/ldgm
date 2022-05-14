
import 'package:user/models/payPalModel.dart';
import 'package:user/models/payStackModel.dart';
import 'package:user/models/razorpayModel.dart';
import 'package:user/models/stripepayModel.dart';

class PaymentGateway {
  RazorpayMethod razorpay;
  StripeMethod stripe;
  PayStackMethod paystack;
  PaypalMethod paypal;
  PaymentGateway();

  PaymentGateway.fromJson(Map<String, dynamic> json) {
    try {
      razorpay = json['razorpay'] != null ? RazorpayMethod.fromJson(json['razorpay']) : null;
      stripe = json['stripe'] != null ? StripeMethod.fromJson(json['stripe']) : null;
      paystack = json['paystack'] != null ? PayStackMethod.fromJson(json['paystack']) : null;
        paypal = json['paypal'] != null ? PaypalMethod.fromJson(json['paypal']) : null;
    } catch (e) {
      print("Exception - paymentGatewayModel.dart - PaymentGateway.fromJson():" + e.toString());
    }
  }
}
