import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '/OdooApiCall/ToCheckInTicketsApi.dart';
import '/OdooApiCall_DataMapping/ResPartner.dart';
import '/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/riverpod_class/attendance_api.dart';
import '/riverpod_class/currentAddress_api.dart';
import '/riverpod_class/currentLocation_api.dart';
import '/screens/authentication/LoginScreen.dart';
import '/widgets/Styles.dart';
import '/widgets/MyCustomStepper.dart'
as MyCustomStepper;
import '/util/Util.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../OdooApiCall/AllTicketsApi.dart';
import '../../util/size_config.dart';
import '../../widgets/MapsWidget.dart';
import '/screens/products/CheckLocationPermission.dart';



class MyAttendanceScreen extends StatefulWidget {
  MyAttendanceScreen(this.supporticket, this.respartner_id);
  //final SupportTicketResPartner supporticket;
  final supporticket;
  final respartner_id;
  @override
  _MyAttendanceScreenState createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> with SingleTickerProviderStateMixin{

  TextStyle orderStatusInfoTextStyle = TextStyle(
    fontSize: 11,
    fontFamily: poppinsFont,
    color: Colors.black.withOpacity(0.6),
  );
  late double partnerLat = 0; //dont initialize it, this is for a late field.
  late double partnerLong = 0; //same as this one, follow the rules of partnerLat
  String checkin = ''; // jst for temporary variable and also for ternary operation on slideaction
  String checkout = '';

  //all fetchedcheck fields are used for attendanceprovider to give checkin and checkout time
  //fetchedcheck fields are declared at the top because it is needed to be used as conditionals in slide to action 
  late DateTime fetchedCheckout;
  late DateTime fetchedCheckout_plus8;
  late DateTime fetchedCheckin;
  late DateTime fetchedCheckin_plus8;


  final panelController = PanelController();
  late double currentlatitude = 0; //we try to sync provider data with the parameters in slidetocheckin consumer
  late double currentlongitude = 0; //we try to sync provider data with the parameters in slidetocheckin consumer
  late String fullAddress;
  // isLocationDone is used to set flag to true after we manage to fetch location,.. this flag is to be used for slide to check in, if no location is get/error, slide to checkin will appear as container, as sliding it might cause unknown bugs especially on singletickercancel error.
  // another thing is to be proper, we will only show slide to checkin after location is get, because this will prevent user from doing mistakes, in easy word, it makes it more user friendly.

  late AnimationController controller; //animation upon slide to check in

  Future<void> getResPartnerData() async {

    //first check if widget.respartner_id exist
    if (widget.respartner_id !='' )
    {
      var listResPartner = await ToCheckInTicketsApi.getResPartner(widget.respartner_id);
      print(widget.respartner_id);
      setState(() {
        for(int i=0;i<listResPartner.length;i++){

          partnerLat= listResPartner[i].partner_latitude.toDouble();

          partnerLong= listResPartner[i].partner_longitude.toDouble();
        }
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getResPartnerData();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds:3),
    );

    //so that after animation show we can directly pop out of it/do what we want eg:reset controller
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed){
        Navigator.pop(context);
        controller.reset();
      }
    });
    //context.read()
  }

  @override
  Widget build(BuildContext context) {
    //firstly, we have to put the value of fetched data (if it exist) into attendance provider first. ,
    //this should be done at top of build method
    final panelHeightClosed = SizeConfig.screenHeight*0.16;
    final panelHeightOpen = SizeConfig.screenHeight*0.55;

    final container = ProviderContainer();
    final currentLocationFuture = container.read(currentlocationFutureProvider.future);

    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Attendance'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: currentLocationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle the error here
            return Text('Error: ${snapshot.error}');
          } else {
            final currentLocation = snapshot.data as Position?;
            if (currentLocation != null) {
              return SlidingUpPanel (
                defaultPanelState: PanelState.CLOSED,
                color: Theme.of(context).primaryColor,
                controller: panelController,
                minHeight: panelHeightClosed,
                maxHeight: panelHeightOpen,
                parallaxEnabled: true,
                parallaxOffset: 1.0, //maybe 0.5 is better
                body: MapsWidget(
                  widget.supporticket,
                  currentLocation.latitude,
                  currentLocation.longitude,
                  address: widget.supporticket.address,
                  key: UniqueKey(),
                ),
                panelBuilder: (controller) => PanelWidget(
                  panelController : panelController,
                  controller: controller,
                ),
              );
            } else {
              return Text('Current location is not available.');
            }
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 25.0),
        child: Container(
          height: 56.0,
          alignment: Alignment.center,
          child: attendanceWidget(),
        ),
      ),
    );
  }


  void showDoneDialog() =>
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                    'assets/json/lottieJson/check_done.json',
                    repeat: false,
                    controller: controller,
                    onLoaded: (composition) {
                      controller.duration = composition.duration;
                      controller.forward();
                    }),
                Text('Success: Attendance Recorded',style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),),
                const SizedBox(height:16),
              ],
            ),
          )
      );

  void showFailedCheckInDialog() =>
      showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Dialog(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/json/lottieJson/cross-unapproved.json',
                  repeat: false,
                  //controller: controller,
                  //onLoaded: (composition) {
                  //  controller.duration = composition.duration;
                  //  controller.forward();
                  //}
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error: You are out of allowed check in radius!',style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),textAlign: TextAlign.center,),
                ),
                const SizedBox(height:16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Please get nearer to your Customer location and perform Check-In inside the allowed circle radius. \n\nThank you.',style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  ),textAlign: TextAlign.center,),
                ),
              ],
            ),
          )
      );

  void showFailedDialog(e) {
    print('Error: failed to check in! Details: $e');
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                  'assets/json/lottieJson/cross-unapproved.json',
                  repeat: false,
                  controller: controller,
                  onLoaded: (composition) {
                    controller.duration = composition.duration;
                    controller.forward();
                  }
              ),
              Text('Error: failed to check in! Details: $e ',style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),),
              const SizedBox(height:16),
            ],
          ),
        )
    );
  }


  void showLoadingDialog() =>
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                    'assets/json/lottieJson/loading-animation.json',
                    repeat: false,
                    controller: controller,
                    onLoaded: (composition) {
                      controller.duration = composition.duration;
                      controller.forward();
                    }
                ),
                const SizedBox(height:16),
              ],
            ),
          )
      );

  Widget buildrefreshButtonWithIcon(WidgetRef ref){
    return Container( //container might be necessary because we dont want address to cause renderflow problem, address is related to iconbutton location too.
        width: SizeConfig.screenWidth*0.09,


        child: InkWell(child: CircleAvatar(
          backgroundColor: primaryColor,
          child: IconButton(
              highlightColor: Colors.white,
              onPressed: (){
                ref.refresh(currentlocationFutureProvider);  // we willl just refresh the root cause which is currentlocationprovider cause , currentlocationaddress watch on currentlocationprovider
              },
              icon: Icon(Icons.refresh_outlined,
                color: Colors.white,
              )),
        ),
        )
    );
  }

  Widget buildDragHandle()  => InkWell(
    child:Center(
      child:Padding(
        //padding: const EdgeInsets.fromLTRB(8,0,8,8), 
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width:30,
          height:8,
          decoration:BoxDecoration(
            color:Colors.grey[300],
            borderRadius:BorderRadius.circular(12),
          ),// BoxDecoration
        ),
      ),// Container
    ),// Center
    onTap:togglePanel,
  );// GestureDetector
  //currently there is a bug where isPanelOpen and isPanelClosed will always return false because panelposition does not reach 1 , but close to 0. eg : panelposition: 0.9999999
  //due to this bug we cannot close it, @update 8jun) we can fix this using by setting panel position property to 1 maybe
  void togglePanel() => panelController.panelPosition==1.0 //panelController.isPanelOpen
      ? panelController.panelPosition == 0.0
      : panelController.panelPosition == 1.0;

  Widget PanelWidget({required ScrollController controller, required PanelController panelController}){
    //final ScrollController controller; 
    //we will combine all the widgets needed inside here.
    return
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildDragHandle(),
            Flexible(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: controller,
                child: Column(
                  children: [
                    buildIntro(),
                    //buildStepper(),
                    buildAttendanceData(),
                    buildHomeAddress(),
                    //buildDeliveryExpectCard() //
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget buildIntro () {
    return Padding(
      padding:
      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, ' + globalClient.sessionId!.userName.toString(),

                  //+ 'this is partner longitude: '+widget.supporticket.partner_long.toString()
                  //+' \n this is partner latitude: '+ partnerLat.toString()
                  //+' \N this is last update '+ partnerLong.toString(),
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                ),
                SizedBox(
                  height: 5,
                ),
                //Text('Please Check in here!', style: homeScreensClickableLabelStyle),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: (0),
                    vertical: (0),
                  ),
                  child: Row(
                    children: [
                      StreamBuilder<Object>(
                          stream: Stream.periodic (const Duration (seconds: 1), (count) => Duration(seconds:count)),
                          builder: (context, snapshot) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  DateFormat ('hh:mm:ss aa').format(DateTime.now()),
                                  style: ticketScreensClickableLabelStyle.copyWith(color: isDarkMode(context)?Color.fromARGB(255, 232, 120, 251): Colors.purpleAccent )
                              ),
                            );
                          }
                      ),
                      Spacer(),
                      //TODO if checked in and checked out, put icons.check, otherwise put icons.warning/icons..waiting
                      InkWell(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(10, 10),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                        onTap: () {}(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeliveryExpectCard() {
    return Padding(
      padding:
      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16, bottom: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery expected on Sat, 19',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('Order ID: OD110589307',
                    style: homeScreensClickableLabelStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAttendanceData() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenWidth(8),
            bottom: getProportionateScreenWidth(8),
          ),
          child: Column(
            children: [
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final watchAddress = ref.watch(currentaddressFutureProvider);
                  return watchAddress.when(
                      data:(placemark){
                        String addressLine1 = "${placemark[0].street}";
                        String addressLine2 = "${placemark[0].postalCode}, ${placemark[0].locality}";
                        String addressLine3 = "${placemark[0].administrativeArea}";
                        String addressLine4 = "${placemark[0].country}";
                        fullAddress = '$addressLine1,\n$addressLine2\n$addressLine3\n$addressLine4'; //this is to be inserted to data inside slidetocheck


                        return buildListRowAddress(
                          Icon(Icons.location_pin, size:30),//size: SizeConfig.screenHeight*0.030),
                          'Location',
                          addressLine1,
                          addressLine2,
                          addressLine3,
                          addressLine4,
                        );
                      },
                      error: (e,stack){
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Error occured!\nDetails $e', textAlign: TextAlign.start,),
                            ),

                            Consumer(
                              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                return buildrefreshButtonWithIcon(ref);
                              },
                            ),
                          ],
                        );

                      },
                      loading: () => const CircularProgressIndicator()
                  );
                },
              ),

              Divider(),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final watchCheckin = ref.watch(attendanceProvider).checkInTime;
                  final watchCheckout = ref.watch(attendanceProvider).checkOutTime;
                  checkin = watchCheckin;
                  checkout = watchCheckout;

                  DateFormat inputFormat =  DateFormat ('yyyy-MM-dd HH:mm:ss');

                  if(widget.supporticket.check_in != ''){
                    fetchedCheckin = DateTime.parse(widget.supporticket.check_in);
                    fetchedCheckin_plus8 = fetchedCheckin.add(Duration(hours:8));
                  }
                  else if(widget.supporticket.check_out != ''){
                    fetchedCheckout = DateTime.parse(widget.supporticket.check_out);
                    fetchedCheckout_plus8 = fetchedCheckout.add(Duration(hours:8));
                  }
                  print("${widget.supporticket.check_in}==asdfasdfsadfwidget.checkin && ${watchCheckin} == asdfasdfasdfwatchcheckin $checkin == checkin");
                  print("${widget.supporticket.check_out}==aasdfasdfasdfsdwidget.checkin && ${watchCheckout} == asdfasdfasdfasdfwatchcheckout $checkout == checkout ");


                  return buildListRowWithTwoData(
                    Icon(Icons.calendar_month, size:30),//size: SizeConfig.screenHeight*0.030), 
                    'Check In',
                    //the ternary below explains that, if there is a check_in data already inside the odoo (we fetch this data by getting it from the ticket screen), then we will just use the supplied data from the ticketscreen, otherwise we will get the data by sliding check in which will notify our changenotifierprovider CheckInTime
                    // ignore: unrelated_type_equality_checks
                    widget.supporticket.check_in == '' ? checkin.toString() : fetchedCheckin_plus8.toString().substring(0,19),//flutter keep giving .millisecnds for example 2022-06-06 12:12:12.000 and we dont want that, therefore we substring it at the UI level. database level will still get .000 and that is fine
                    'Check out',
                    widget.supporticket.check_out == '' ? checkout.toString() : fetchedCheckout_plus8.toString().substring(0,19),//flutter keep giving .millisecnds for example 2022-06-06 12:12:12.000 and we dont want that, therefore we substring it at the UI level. database level will still get .000 and that is fine
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
  /*
  Widget buildStepper() {
    List<MyCustomStepper.Step> orderSteps = [
      MyCustomStepper.Step(
        title: Text(
          'Ordered',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.complete,
        subtitle: Text(
          'Sat, 19th Dec 2020',
          style: Theme.of(context).textTheme.caption,
        ),
        content: Container(),
      ),
      MyCustomStepper.Step(
        title: Text(
          'Shipped',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.complete,
        subtitle: Text(
          'Tue, 22nd Dec 2020',
          style: Theme.of(context).textTheme.caption,
        ),
        content: Text(
          'Package left warehouse facility, 10:00 pm\n' +
              'Package arrived at Grand Station, 12:00 am',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      MyCustomStepper.Step(
        title: Text(
          'Delivered',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        isActive: true,
        state: MyCustomStepper.StepState.emptyCircle,
        subtitle: Container(),
        content: Container(),
      ),
    ];

    return Theme(
      data: ThemeData(
        primaryColor: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          elevation: 2,
          color: isDarkMode(context) ? darkGreyColor : Colors.white,
          shadowColor: Colors.grey.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: MyCustomStepper.MyCustomStepper(
            steps: orderSteps,
            currentStep: 1,
            controlsBuilder: (BuildContext context,
                    ControlsDetails controls) =>
                Container(),
          ),
        ),
      ),
    );
  }
  */
  Widget buildHomeAddress() {

    return Padding(


      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    final watchPosition = ref.watch(currentlocationFutureProvider);
                    return watchPosition.when(
                        data:(value){
                          currentlatitude = value.latitude; //value to be inserted when slide to check in
                          currentlongitude = value.longitude; //same as currentlatitude line
                          return Text(
                              value.toString(), style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight
                          ));
                        },
                        error: (e,stack) => Text('Error! Details$e'),  //TODO:// we should show old location too if error happens, we should persist the old data
                        loading: () => const CircularProgressIndicator()
                    );

                  },
                  /*child: Text('Check in Check out',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: Theme.of(context).textTheme.subtitle2.fontWeight),
                  ),*/
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget attendanceWidget() {
    return Container(
        child: Builder(
            builder: (context){
              final GlobalKey <SlideActionState> key = GlobalKey();
              return Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final watchCheckInTime = ref.watch(attendanceProvider).checkInTime;
                  final watchCheckOutTime = ref.watch(attendanceProvider).checkOutTime;
                  final watchLastKnownLocation = ref.read(lastknownlocationFutureProvider);

                  print('Check-in time: $watchCheckInTime');
                  print('Check-out time: $watchCheckOutTime');
                  print('partnerLat: $partnerLat');
                  print('partnerLong: $partnerLong');
                  print('currentlatitude: $currentlatitude');
                  print('currentlongitude: $currentlongitude');

                  return
                    watchCheckOutTime != '' || widget.supporticket.check_out != '' || checkout != '' //|| _isLocationDone != true //container will be return if one of these conditions are met.
                        ? Container()
                        : SlideAction(
                        text:
                        widget.supporticket.check_in =='' && watchCheckInTime == ''   // AND if we found no data for check in (through provider) There should be data after we slide it to check in
                            ?  'Slide to Check in'
                            :  watchCheckOutTime == '' || widget.supporticket.check_out == ''//AND if we found no data for check out after slide to check out
                            ? 'Slide to Check Out' // then display slide to check out
                            : 'Finished',
                        textStyle: normalTextStyle,
                        outerColor: isDarkMode(context) ? Colors.white : Colors.white,
                        innerColor: isDarkMode(context) ? Colors.black : primaryColor,
                        key: key,

                        onSubmit: () {
                          checkLocationPermission(context); // Add this line to check location permission

                          Future.delayed(
                              Duration(milliseconds: 900),
                                  () => key.currentState?.reset());

                          if (watchCheckInTime == '' && widget.supporticket.check_in =='')
                            watchLastKnownLocation.when(
                              data:(value) async {
                                print('Last known location: $value');

                                // Convert the address to geographic coordinates
                                List<Location> locations = await locationFromAddress(widget.supporticket.address);
                                print('Locations: $locations');
                                if (locations.isNotEmpty) {
                                  Location location = locations.first;

                                  // Calculate the distance
                                  var distance = GeolocatorPlatform.instance.distanceBetween(
                                      location.latitude,
                                      location.longitude,
                                      value.latitude,
                                      value.longitude
                                  );

                                  print('Distance from location: $distance');

                                  // R

                                  if (distance < 1000){
                                    ref.read(attendanceProvider.notifier).updateCheckInWithTicketId(
                                        widget.supporticket.ticket_id, currentlatitude.toString(), currentlongitude.toString(), fullAddress);
                                    return showDoneDialog();
                                  }
                                  else{
                                    showFailedCheckInDialog();
                                    ref.read(attendanceProvider).checkInTime = '';
                                  }
                                }
                                // else if(partnerLat == null && partnerLong == null){
                                //   ref.read(attendanceProvider.notifier).updateCheckInWithTicketId(
                                //       widget.supporticket.ticket_id, currentlatitude.toString(), currentlongitude.toString(), fullAddress);
                                //   return showDoneDialog();
                                // }
                              },
                              error: (e,stack) => {
                                showFailedDialog(e),
                              },
                              loading: () => showLoadingDialog(),
                            );

                          else if  (watchCheckOutTime == '' || widget.supporticket.check_out == '')
                          {
                            try{
                              ref.read(attendanceProvider.notifier).updateCheckOutWithTicketId(
                                  widget.supporticket.ticket_id, currentlatitude.toString(), currentlongitude.toString(), fullAddress);
                              showDoneDialog();
                            }catch(e){
                              ref.read(attendanceProvider).checkOutTime = '';
                              showFailedDialog(e);
                            }
                          }

                          print("${widget.supporticket.check_in} ==widget.checkin && ${watchCheckInTime} == watchcheckin");
                          print("${widget.supporticket.check_out} ==widget.checkout && ${watchCheckOutTime} == watchcheckout $checkout == checkout ");
                        }
                    );
                },
              );
            }
        )
    );
  }

  Widget buildBottomPart() {
    return Container(
      child: buildButton(
        'Slide to check in',
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          navigateHomeScreen(context);
        },
      ),
    );
  }

  Widget buildListRowAddress(Icon icon, String title, String address1, String address2, String address3, String address4) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenWidth(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Padding(
              padding: const EdgeInsets.only(left: 20), //to make it kinda allign
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: SizeConfig.screenWidth*0.59, //can use approx 0.6
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              address1+',',
                              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                  fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              address2+',',
                              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                  fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              address3+',',
                              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                  fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              address4,
                              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                                  fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
                          ]
                      )
                  ),
                ],
              ),
            ),
            Spacer(),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return buildrefreshButtonWithIcon(ref);
                //return Container( //container might be necessary because we dont want address to cause renderflow problem, address is related to iconbutton location too.
                //  width: SizeConfig.screenWidth*0.09,
                //
                //
                //  child: InkWell(child: CircleAvatar(
                //    backgroundColor: primaryColor,
                //    child: IconButton(
                //      highlightColor: Colors.white,
                //      onPressed: (){
                //        ref.refresh(currentlocationFutureProvider);  // we willl just refresh the root cause which is currentlocationprovider cause , currentlocationaddress watch on currentlocationprovider
                //      },
                //      icon: Icon(Icons.refresh_outlined,
                //      color: Colors.white,
                //    )),
                //  ),
                //)
                //);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget buildListRowWithTwoData(Icon icon, String title, String subtitle, String title2, String subtitle2 ) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenWidth(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Padding( //to make the padding kinda allign, i have to set this paddning to 0, while keeping location icon padding to 20 // TODO: find a way to align, perhaps using property such as spacebetween/spaceevenly properly
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: Container(
                width: SizeConfig.screenWidth*0.3, //TODO change the screenwidth, this is temporary only because want to test functionality of check in with provider
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container
              (
              height: SizeConfig.screenHeight/20, // i think this is the magic height, otherwise, please find way to stretch this container size to its parent size <row>. //TODO making this todo incase 
              child: VerticalDivider(
                thickness: 2,
                width: 20,
                color: isDarkMode(context) ? Colors.white54 : Colors.black,
              ),
            ),
            Container(
              width: SizeConfig.screenWidth*0.3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title2,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      subtitle2,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight
                      ),
                    ),
                  ]
              ),
            ),
            //Spacer(),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }



  @override
  void dispose(){
    super.dispose();
    print("Attendancescreen disposed");
    controller: controller;

  }


}
