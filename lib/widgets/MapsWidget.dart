import 'dart:async';
import 'dart:developer';
import 'package:after_layout/after_layout.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '/OdooApiCall_DataMapping/SupportTicket.dart';
import '/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import '/util/size_config.dart';
import '../colors/Colors.dart';
import '../util/Util.dart';
import 'Styles.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/riverpod_class/currentLocation_api.dart';

//For demo, we will set this value to const
const double CAMERA_ZOOM=17.0;
const double CAMERA_TILT=0;
const double CAMERA_BEARING=0;

final locationProvider = Provider<String>((ref) => 'location... ');


class MapsWidget extends StatefulWidget {
  final supportticket;
  final partner_lat;
  final partner_long;
  final String address;
  MapsWidget(this.supportticket, this.partner_lat, this.partner_long, {required this.address, Key? key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapsWidgetState();
  }
}


class _MapsWidgetState extends State<MapsWidget> with AutomaticKeepAliveClientMixin, 
      WidgetsBindingObserver,AfterLayoutMixin
{

  
  late BitmapDescriptor siteLocationIcon;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  late GoogleMapController _googleMapController;
  Completer<GoogleMapController> _controller = Completer();
  var currentLong; //= 2.9293851; // WE WILL SET SOMETHING 
  var currentLat; //= 101.6292768; //should be null or empty because later, setstate will change the value when geolocator position are called
  var currentSiteLat;
  var currentSiteLong;
  late String _mapStyle;


  
  

  get _initialCameraPosition =>   
    CameraPosition(
    target: LatLng(widget.partner_lat , widget.partner_long), //this is sigma location
    zoom: CAMERA_ZOOM,
    bearing: CAMERA_BEARING,
    tilt: CAMERA_TILT
  );
   
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //streamLocation();
    rootBundle.loadString('assets/json/googlemapsapi/aubergine.txt').then((string) {
    _mapStyle = string;});
    getGeoLocatorPermission();
    _callCustomMarker(); // this is compulsory to get the custom marker, otherwise null error are thrown.
  }
  @override
  bool get wantKeepAlive => true;

  
  
 late StreamSubscription<Position> positionStream;
  // ignore: cancel_subscriptions

  void streamLocation () {
  //stream current position using geolocator
    final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    );
    // ignore: cancel_subscriptions
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
          var distance = GeolocatorPlatform.instance.distanceBetween( (widget.partner_lat), widget.partner_long,position.latitude, position.longitude);
          print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
          if (distance < 1000){
            print("return true: let this user check in ");
            
          }else{
            print("return false: do not let this user check in ");
          
          } 
      }
    );
  }

  Future<void> _getCurrentUserLocation() async {
   final GoogleMapController controller = await _controller.future;
   Position?  currentLocation;
   try {
     print('getting current location');
     //getcurrentlocationb ased on last known
     currentLocation = await Geolocator.getLastKnownPosition();
     //getlocation ifprint("apakah ini anak muda"); last known is not get. this probably will tweak performance a little bit. because calling for position takes a lot of utilization.
     if(currentLocation == null){
      currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("bro we cannot find last known");
     }
   } on Exception {
    currentLocation = null;
    }
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        zoom: 17.0,
      ),
    ));
  }
  Future<void> _getSiteLocation() async {
    final GoogleMapController controller = await _controller.future;
    List<Location> locations = await locationFromAddress(widget.address);
    if (locations.isNotEmpty) {
      print('pin pressed and location: ${locations.first}');
      Location location = locations.first;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(location.latitude, location.longitude),
          zoom: 17.0,
        ),
      ));
    }
  }

  void _callCustomMarker()async{
    siteLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 0.5),'assets/maps_images/purplemarker-site-location.png');
  }
  //to be called inside onMapCreated
  void _setMarkersAndCircles(GoogleMapController controller) async {
    if(widget.address.isNotEmpty) {
      List<Location> locations = await locationFromAddress(widget.address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _markers.add(
              Marker(
                markerId: MarkerId(widget.supportticket.partner_id),
                position: LatLng(location.latitude, location.longitude),
                infoWindow: InfoWindow(
                  title: widget.supportticket.partner_name,
                  snippet:'Our Customer',
                ),
                icon: siteLocationIcon,
              )
          );
          _circles.add(
              Circle(
                  circleId: CircleId(widget.supportticket.partner_id),
                  center: LatLng(location.latitude, location.longitude),
                  radius: 500,
                  strokeWidth: 1,
                  strokeColor: Colors.red.withOpacity(0.25), // Set the color and opacity here
                  fillColor: Colors.red.withOpacity(0.25)
              )
          );
        });
      }
    }
  }


  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {

      _googleMapController.setMapStyle("[]");
    }
  }
  

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //ifnot mistaken this is so that maps wont return to blank if we tabout, and tab in back to the apps //
    //positionStream.cancel(); //dispose listening to stream position
    print("mapswidget disposed");
  }

  void getGeoLocatorPermission() async{
    bool serviceEnabled;
    LocationPermission permission;
    

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    print(permission);
  }
  
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    throw UnimplementedError();
  }
  

  /*Future<String> getAddress() async {
    List<Placemark> placemark = await placemarkFromCoordinates(widget.partner_lat, widget.partner_long);
    String location = "${placemark[0].street},${placemark[0].subAdministrativeArea},${placemark[0].administrativeArea},${placemark[0].postalCode},${placemark[0].country}";
    
    return location;  
  }
  */


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.6,
        child: GoogleMap(
          circles: _circles,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          tiltGesturesEnabled: true,
          compassEnabled: false,
          markers: _markers,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition: _initialCameraPosition,
          onMapCreated:(GoogleMapController controller){
            isDarkMode(context) ? controller.setMapStyle(_mapStyle) : controller.setMapStyle("[]");
            _controller.complete(controller);
            _setMarkersAndCircles(controller);
          },
        ),
      ),
      floatingActionButton:_buildFAB(),
    );
  }

  Widget _buildFAB(){
              return Padding(
              padding: const EdgeInsets.symmetric(vertical: 320,horizontal: 2),
              //EdgeInsets.symmetric(vertical: SizeConfig.screenHeight*0.38,horizontal: 2), //need to find good height so that googlemapsapi direction button are shown too
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                  onPressed: _getCurrentUserLocation,
                  child: Icon(Icons.gps_fixed_outlined,
                  size: 30,
                  color: primaryColor,),
                  backgroundColor: Colors.white,
                  heroTag: null // need to put the herotag otherwise error will occurs if we use 2 floating button
                  ),
                  SizedBox(height:20),
                  FloatingActionButton(
                  onPressed: _getSiteLocation,
                  child: Icon(Icons.pin_drop,
                  size: 30,
                  color: primaryColor,),
                  backgroundColor: Colors.white,
                  heroTag: null
                  ),
                ],
              ),
            ) ;
  }
  
}
//var globalAllowCheckIn = false; //set default to false yeah. 

