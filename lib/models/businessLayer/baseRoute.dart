import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:user/models/businessLayer/base.dart';

class BaseRoute extends Base {
  BaseRoute({a, o, r}) : super(routeName: r, analytics: a, observer: o);

  @override
  BaseRouteState createState() => BaseRouteState();
}

class BaseRouteState extends BaseState with RouteAware {
  BaseRouteState() : super();

  @override
  Widget build(BuildContext context) => null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPopNext() {
    _setCurrentScreen();
    _sendAnalyticsEvent();
  }

  @override
  void didPush() {
    _setCurrentScreen();
    _sendAnalyticsEvent();
  }

  @override
  void dispose() {
    widget.observer.unsubscribe(this);
    super.dispose();
  }

  Future<String> getLocationFromAddress(String address) async {
    try {
      List<Location> _locationList = await locationFromAddress(address);
      return '${_locationList[0].latitude}|${_locationList[0].longitude}';
    } catch (e) {
      print("Exception -  base.dart - getLocationFromAddress():" + e.toString());
      return null;
    }
  }

  void hideLoader() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _setCurrentScreen();
    _sendAnalyticsEvent();
  }

  Future<void> _sendAnalyticsEvent() async {
    await widget.observer.analytics.logEvent(
      name: widget.routeName,
      parameters: <String, dynamic>{},
    );
  }

  Future<void> _setCurrentScreen() async {
    await widget.observer.analytics.setCurrentScreen(
      screenName: widget.routeName,
      screenClassOverride: widget.routeName,
    );
  }
}
