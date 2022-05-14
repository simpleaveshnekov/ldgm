class PaypalMethod{
  String paypalStatus;
  String paypalClientId;
  String paypalSecret;

   PaypalMethod();

  PaypalMethod.fromJson(Map<String, dynamic> json) {
    try {
      paypalStatus = json['paypal_status'] != null ? json['paypal_status'] : null;
      paypalClientId = json['paypal_client_id'] != null ? json['paypal_client_id'] : null;
      paypalSecret = json['paypal_secret'] != null ? json['paypal_secret'] : null;
    } catch (e) {
      print("Exception - PaypalModel.dart - PaypalMethod.fromJson():" + e.toString());
    }
  }
}