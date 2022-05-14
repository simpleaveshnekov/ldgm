import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:user/l10n/l10n.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/localNotificationModel.dart';
import 'package:user/provider/local_provider.dart';
import 'package:user/screens/splash_screen.dart';
import 'package:user/theme/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp();
  }catch(e){
    print(e);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = new MyHttpOverrides();
  runApp(App());
}
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
  description: 'Channel Description',
  playSound: true
);
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  } catch (e) {
    print('Exception - main.dart - _firebaseMessagingBackgroundHandler(): ' + e.toString());
  }
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return new MyHttpClient(super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true);
  }
}

class MyHttpClient implements HttpClient {
  HttpClient _realClient;

  MyHttpClient(this._realClient);

  @override
  bool get autoUncompress => _realClient.autoUncompress;

  @override
  set autoUncompress(bool value) => _realClient.autoUncompress = value;

  @override
  Duration get connectionTimeout => _realClient.connectionTimeout;

  @override
  set connectionTimeout(Duration value) =>
      _realClient.connectionTimeout = value;

  @override
  Duration get idleTimeout => _realClient.idleTimeout;

  @override
  set idleTimeout(Duration value) => _realClient.idleTimeout = value;

  @override
  int get maxConnectionsPerHost => _realClient.maxConnectionsPerHost;

  @override
  set maxConnectionsPerHost(int value) =>
      _realClient.maxConnectionsPerHost = value;

  @override
  String get userAgent => _realClient.userAgent;

  @override
  set userAgent(String value) => _realClient.userAgent = value;

  @override
  void addCredentials(
      Uri url, String realm, HttpClientCredentials credentials) =>
      _realClient.addCredentials(url, realm, credentials);

  @override
  void addProxyCredentials(String host, int port, String realm,
      HttpClientCredentials credentials) =>
      _realClient.addProxyCredentials(host, port, realm, credentials);

  @override
  void set authenticate(
      Future<bool> Function(Uri url, String scheme, String realm) f) =>
      _realClient.authenticate = f;

  @override
  void set authenticateProxy(
      Future<bool> Function(
          String host, int port, String scheme, String realm)
      f) =>
      _realClient.authenticateProxy = f;

  @override
  void set badCertificateCallback(
      bool Function(X509Certificate cert, String host, int port)
      callback) =>
      _realClient.badCertificateCallback = callback;

  @override
  void close({bool force = false}) => _realClient.close(force: force);

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      _realClient.delete(host, port, path);

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => _realClient.deleteUrl(url);

  @override
  void set findProxy(String Function(Uri url) f) => _realClient.findProxy = f;

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      _updateHeaders(_realClient.get(host, port, path));

  Future<HttpClientRequest> _updateHeaders(
      Future<HttpClientRequest> httpClientRequest) async {
    return (await httpClientRequest)
      ..headers.add("Access-Control-Allow-Origin", "*")
      ..headers.add("Access-Control-Allow-Headers",
          "Origin, X-Requested-With, Content-Type, Accept, Authorization")
      ..headers
          .add("Access-Control-Allow-Methods", "PUT, POST, DELETE, GET, PATCH");
  }

  @override
  Future<HttpClientRequest> getUrl(Uri url) =>
      _updateHeaders(_realClient.getUrl(url.replace(path: url.path)));

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      _realClient.head(host, port, path);

  @override
  Future<HttpClientRequest> headUrl(Uri url) => _realClient.headUrl(url);

  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) =>
      _realClient.open(method, host, port, path);

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) =>
      _realClient.openUrl(method, url);

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      _realClient.patch(host, port, path);

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _realClient.patchUrl(url);

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      _realClient.post(host, port, path);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _realClient.postUrl(url);

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      _realClient.put(host, port, path);

  @override
  Future<HttpClientRequest> putUrl(Uri url) => _realClient.putUrl(url);
}

class _AppState extends State<App> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final String routeName = "main";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          return GetMaterialApp(
              navigatorObservers: <NavigatorObserver>[observer],
              debugShowCheckedModeBanner: false,
              title: "MGDLivery Store",
              locale: Get.deviceLocale,
              supportedLocales: L10n.all,
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: SplashScreen(
                a: analytics,
                o: observer,
              ),
              theme: ThemeUtils.defaultAppThemeData);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setFNotification();
  }

  void setFNotification() async{
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    var initialzationSettingsAndroid = AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      try {
        if(message!=null && message.data!=null){
          LocalNotification _notificationModel = LocalNotification.fromJson(message.data);
          global.localNotificationModel = _notificationModel;
          global.isChatNotTapped = false;
        }

        if (message.notification != null) {
          Future<String> _downloadAndSaveFile(String url, String fileName) async {
            final Directory directory = await getApplicationDocumentsDirectory();
            final String filePath = '${directory.path}/$fileName';
            final http.Response response = await http.get(Uri.parse(url));
            final File file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);
            return filePath;
          }

          if (Platform.isAndroid) {
            String bigPicturePath;
            AndroidNotificationDetails androidPlatformChannelSpecifics;
            if(message.notification.android.imageUrl!=null && '${message.notification.android.imageUrl}'!='N/A'){
              print('in Image');
              print('${message.notification.android.imageUrl}');
              bigPicturePath = await _downloadAndSaveFile(message.notification.android.imageUrl != null ? message.notification.android.imageUrl : 'https://picsum.photos/200/300', 'bigPicture');
              final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
                FilePathAndroidBitmap(bigPicturePath),
              );
              androidPlatformChannelSpecifics = AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: 'ic_notification', styleInformation: bigPictureStyleInformation, playSound: true);
            }else{
              print('in No Image');
              androidPlatformChannelSpecifics = AndroidNotificationDetails(channel.id, channel.name, channelDescription: channel.description, icon: 'ic_notification', styleInformation: BigTextStyleInformation(message.notification.body), playSound: true);
            }
            // final AndroidNotificationDetails androidPlatformChannelSpecifics2 =
            final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
            flutterLocalNotificationsPlugin.show(1, message.notification.title, message.notification.body, platformChannelSpecifics);
          } else if (Platform.isIOS) {
            final String bigPicturePath = await _downloadAndSaveFile(message.notification.apple.imageUrl != null ? message.notification.apple.imageUrl : 'https://picsum.photos/200/300', 'bigPicture.jpg');
            final IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails(attachments: <IOSNotificationAttachment>[IOSNotificationAttachment(bigPicturePath)], presentSound: true);
            final IOSNotificationDetails iOSPlatformChannelSpecifics2 = IOSNotificationDetails(presentSound: true);
            final NotificationDetails notificationDetails = NotificationDetails(
              iOS: message.notification.apple.imageUrl != null ? iOSPlatformChannelSpecifics : iOSPlatformChannelSpecifics2,
            );
            await flutterLocalNotificationsPlugin.show(1, message.notification.title, message.notification.body, notificationDetails);
          }
        }
      } catch (e) {
        print('Exception - main.dart - onMessage.listen(): ' + e.toString());
      }
    });
  }
}
