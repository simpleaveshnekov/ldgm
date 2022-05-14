import 'dart:convert';
import 'dart:ui';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/controllers/user_profile_controller.dart';
import 'package:user/models/addressModel.dart';
import 'package:user/models/appInfoModel.dart';
import 'package:user/models/appNoticeModel.dart';
import 'package:user/models/googleMapModel.dart';
import 'package:user/models/localNotificationModel.dart';
import 'package:user/models/mapBoxModel.dart';
import 'package:user/models/mapByModel.dart';
import 'package:user/models/nearByStoreModel.dart';
import 'package:user/models/paymentGatewayModel.dart';
import 'package:user/models/userModel.dart';

List<Address> addressList = [];
// APIHelper apiHelper;
String appDeviceId;
AppInfo appInfo = new AppInfo();
AppNotice appNotice = new AppNotice();
String appName = 'MGDLivery Store';
String appShareMessage =
    "Invite kita bes dito sa $appName! Simple lang sya gamitin ang dami pang pwedeng bilhin. Eto ung code ko [CODE]. Lagay mo sa referal code pag nag register ka. Invite ka ng mga friends mo bes para magka points ka! Lets go! :)";
String appVersion = '1.0';
String baseUrl = 'https://mgdliveryapp.mgdlenterprise.com/api/';
int cartCount = 0;
List<Color> colorList = [
  Color(0xFF4DD0E1),
  Color(0xFFAB47BC),
];
String currentLocation;
CurrentUser currentUser = new CurrentUser();
String defaultImage = 'assets/images/icon.png';
GoogleMapModel googleMap;
String imageUploadMessageKey = 'w0daAWDk81';
bool isChatNotTapped = false;
String languageCode = 'en';
double lat;
double lng;
bool isRTL = false;
List<String> rtlLanguageCodeLList = [
  'ar',
  'arc',
  'ckb',
  'dv',
  'fa',
  'ha',
  'he',
  'khw',
  'ks',
  'ps',
  'ur',
  'uz_AF',
  'yi'
];
LocalNotification localNotificationModel = new LocalNotification();
String locationMessage = '';
MapBoxModel mapBox;
NearStoreModel nearStoreModel = new NearStoreModel();
PaymentGateway paymentGateway = new PaymentGateway();
String selectedImage;
SharedPreferences sp;
bool isNavigate = false;
String stripeBaseApi = 'https://api.stripe.com/v1';
var orderApiRazorpay = Uri.parse('https://api.razorpay.com/v1/orders');
final UserProfileController userProfileController =
    Get.put(UserProfileController());
Mapby mapby;

Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  Map<String, String> apiHeader = new Map<String, String>();
  if (authorizationRequired) {
    sp = await SharedPreferences.getInstance();
    if (sp.getString("currentUser") != null) {
      CurrentUser currentUser =
          CurrentUser.fromJson(json.decode(sp.getString("currentUser")));
      apiHeader.addAll({"Authorization": "Bearer " + currentUser.token});
    }
  }
  apiHeader.addAll({"Content-Type": "application/json"});
  apiHeader.addAll({"Accept": "application/json"});
  return apiHeader;
}
