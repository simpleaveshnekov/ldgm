import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart' as autoCmplt;
import 'package:geocoding/geocoding.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user/models/businessLayer/baseRoute.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/businessLayer/placeService.dart';
import 'package:user/models/nearByStoreModel.dart';
import 'package:user/screens/google_address_search_screen.dart';
import 'package:user/screens/home_screen.dart';
import 'package:mapbox_search/mapbox_search.dart' as mapSc;
import 'package:uuid/uuid.dart';

class LocationScreen extends BaseRoute {
  final int screenId;
  LocationScreen({a, o, this.screenId}) : super(a: a, o: o, r: 'LocationScreen');
  @override
  _LocationScreenState createState() => new _LocationScreenState(screenId: screenId);
}

class _LocationScreenState extends BaseRouteState {
  int screenId;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  double _lat;
  double _lng;
  TextEditingController _cSearch = new TextEditingController();

  FocusNode _fSearch = new FocusNode();
  bool _isDataLoaded = false;
  bool _isShowConfirmLocationWidget = false;
  Placemark setPlace;
  _LocationScreenState({this.screenId}) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          return null;
        },
        child: Scaffold(
          appBar: AppBar(
              elevation: 2,
              leading: InkWell(
                onTap: () async {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              automaticallyImplyLeading: false,
              title: TextFormField(
                textAlign: TextAlign.start,
                autofocus: false,
                cursorColor: Color(0xFFFA692C),
                enabled: true,
                readOnly: true,
                style: Theme.of(context).textTheme.subtitle1,
                controller: _cSearch,
                focusNode: _fSearch,
                onFieldSubmitted: (text) async {},
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 14),
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  hintStyle: Theme.of(context).textTheme.subtitle1,
                  hintText: global.currentLocation != null ? global.currentLocation : ' ${AppLocalizations.of(context).txt_no_location_selected}',
                ),
                onTap: () async {
                  if (global.mapby != null) {
                    if (global.mapby.mapbox == 1) {
                      // search through map box
                      Navigator.push(context, MaterialPageRoute(builder: (context) => searchLocation()));
                    } else {
                      print('this is google');
                      // search to google map api

                      final sessionToken = Uuid().v4();
                      final Suggestion result = await showSearch(
                        context: context,
                        delegate: AddressSearch(sessionToken),
                      );
                      _cSearch.text = result.description;
                      String latlng = await getLocationFromAddress(result.description);
                      List<String> _tList = latlng.split("|");

                      // _lat = 18.216876495949794;
                      _lat = double.parse(_tList[0]).toDouble();
                      _lng = double.parse(_tList[1]).toDouble();
                      // _lng = 120.60179552302395;
                      showOnlyLoaderDialog();
                      final GoogleMapController controller = await _controller.future;
                      await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
                      await _updateMarker(_lat, _lng).then((_) async {
                        List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
                        setPlace = placemarks[0];
                        hideLoader();
                        _isShowConfirmLocationWidget = true;
                        setState(() {});
                      });
                      setState(() {});
                    }
                  }
                },
              )),
          body: _isDataLoaded
              ? Stack(
                  children: [
                    GoogleMap(
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_lat, _lng),
                        zoom: 15,
                      ),
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        setState(() {});
                      },
                      markers: Set<Marker>.from(markers),
                      onTap: (latLng) async {
                        _lat = latLng.latitude;
                        _lng = latLng.longitude;
                        final GoogleMapController controller = await _controller.future;
                        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
                        await _updateMarker(_lat, _lng).then((value) async {
                          List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
                          setPlace = placemarks[0];
                          _isShowConfirmLocationWidget = true;
                          setState(() {});
                        });
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25, left: 8, right: 8),
                      child: Align(alignment: Alignment.bottomCenter, child: SizedBox(child: _isShowConfirmLocationWidget ? _setCurrentLocationWidget() : SizedBox())),
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  searchLocation() {
    try {
      return autoCmplt.MapBoxAutoCompleteWidget(
        apiKey: global.mapBox.mapApiKey,
        hint: '${AppLocalizations.of(context).txt_type_here} ',
        onSelect: (place) async {
          _cSearch.text = place.placeName;
          Location location = await _placesSearch(_cSearch.text);
          _lat = location.latitude;
          _lng = location.longitude;
          showOnlyLoaderDialog();
          final GoogleMapController controller = await _controller.future;
          await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_lat, _lng), tilt: 59.440717697143555, zoom: 15)));
          await _updateMarker(_lat, _lng).then((_) async {
            List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
            setPlace = placemarks[0];
            hideLoader();
            _isShowConfirmLocationWidget = true;
            setState(() {});
          });
          setState(() {});
        },
        limit: 5,
      );
    } catch (e) {
      print("Exception - location_screen.dart - searchLocation():" + e.toString());
    }
  }

  _getNearByStore() async {
    try {
      await apiHelper.getNearbyStore().then((result) async {
        print('new data');
        print(result.status);
        if (result != null) {
          if ('${result.status}' == '1') {
            global.nearStoreModel = result.data;
            global.sp.setString("lastloc", '${global.lat}|${global.lng}');
            if (global.currentUser.id != null) {
              await global.userProfileController.getUserAddressList();
            }
            Get.to(() => HomeScreen(
                  a: widget.analytics,
                  o: widget.observer,
                ));
          } else if ('${result.status}' == '0') {
            print('in');
            global.nearStoreModel = new NearStoreModel();
            global.locationMessage = result.message;
            _noStoresAvailableDialog();
          }
        }
      });
    } catch (e) {
      print("Exception t - location_screen.dart - _getNearByStore():" + e.toString());
    }
  }

  _init() async {
    try {
      _lat = global.lat;
      _lng = global.lng;
      _isDataLoaded = true;
      await _updateMarker(_lat, _lng);

      setState(() {});
    } catch (e) {
      print("Exception - location_screen.dart - _init():" + e.toString());
    }
  }

  _noStoresAvailableDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            content: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '${AppLocalizations.of(context).lbl_no_store_at_loc_msg}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('${AppLocalizations.of(context).btn_search_another_location}')),
              global.sp.getString('lastloc') != null
                  ? TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();

                        if (global.sp.getString('lastloc') != null) {
                          List<String> _tlist = global.sp.getString('lastloc').split("|");
                          global.lat = double.parse(_tlist[0]);
                          global.lng = double.parse(_tlist[1]);
                        }

                        final GoogleMapController controller = await _controller.future;
                        await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(global.lat, global.lng), tilt: 59.440717697143555, zoom: 15)));
                        await _updateMarker(global.lat, global.lng).then((value) async {
                          List<Placemark> placemarks = await placemarkFromCoordinates(global.lat, global.lng);
                          setPlace = placemarks[0];
                          setState(() {});
                        });
                        global.currentLocation = "${setPlace.name}, ${setPlace.locality} ";
                        await _getNearByStore();
                      },
                      child: Text('${AppLocalizations.of(context).btn_continue_with_default_location}'))
                  : SizedBox()
            ],
          );
        });
  }

  Future<Location> _placesSearch(String searchText) async {
    try {
      var placesService = mapSc.PlacesSearch(
        apiKey: global.mapBox.mapApiKey,
        // country: "IN",
        limit: 1,
      );
      var places = await placesService.getPlaces(
        searchText,
      );
      List<Location> location = await locationFromAddress(places[0].toString());
      return location[0];
    } catch (e) {
      print('Exception - location_screen.dart - _placesSearch(): ' + e.toString());
      return null;
    }
  }

  _setCurrentLocationWidget() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${AppLocalizations.of(context).txt_select_location} ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    '${setPlace.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Align(alignment: Alignment.centerLeft, child: Text("${setPlace.name.trim()}, ${setPlace.locality}, ${setPlace.street}, ${setPlace.subAdministrativeArea}, ${setPlace.postalCode}")),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${AppLocalizations.of(context).btn_confirm_location}'),
                ),
                onPressed: () async {
                  _isShowConfirmLocationWidget = false;
                  global.lat = _lat;
                  global.lng = _lng;
                  global.currentLocation = "${setPlace.name}, ${setPlace.locality} ";
                  await _getNearByStore();

                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _updateMarker(_lat, _lng) async {
    try {
      if (markers.isNotEmpty) markers.clear();
      List<Placemark> placemarks = await placemarkFromCoordinates(_lat, _lng);
      Placemark place = placemarks[0];
      String startCoordinatesString = '($_lat, $_lng)';
      Marker startMarker = Marker(
          markerId: MarkerId(startCoordinatesString),
          position: LatLng(_lat, _lng),
          infoWindow: InfoWindow(
            title: '${place.name}, ${place.locality} ',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(0),
          onTap: () async {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(_lat, _lng),
                  tilt: 50.0,
                  bearing: 45.0,
                  zoom: 20.0,
                ),
              ),
            );
          });
      mapController = await _controller.future;
      markers.add(startMarker);

      return true;
    } catch (e) {
      print('MAP Exception - location_screen.dart - _updateMarker():' + e.toString());
    }
    return false;
  }
}
