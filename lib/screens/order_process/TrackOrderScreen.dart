import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/widgets/Styles.dart';
import '/widgets/MyCustomStepper.dart'
    as MyCustomStepper;
import '/util/Util.dart';

class TrackOrderScreen extends StatefulWidget {
  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  TextStyle orderStatusInfoTextStyle = TextStyle(
    fontSize: 11,
    fontFamily: poppinsFont,
    color: Colors.black.withOpacity(0.6),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(context, trackOrderLabel, onBackPress: () {
      //   Navigator.pop(context);
      // }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildDeliveryExpectCard(),
              buildStepper(),
              buildHomeAddress(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 25.0),
        child: Container(
          height: 56.0,
          alignment: Alignment.center,
          child: buildBottomPart(),
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: Theme.of(context).textTheme.titleSmall?.fontWeight),
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
                Text('Home Address',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: Theme.of(context).textTheme.titleSmall?.fontWeight),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '2249 Carling Ave #416',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Ottawa, ON K2B 7E9',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Canada',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Default delivery address',
                        style: homeScreensClickableLabelStyle),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            controlsBuilder: (BuildContext context, ControlsDetails controls) => Container(),
            key: UniqueKey(),
            onStepTapped: (int value) {  },
            controls: ControlsDetails(currentStep: 0, stepIndex: 0), // Default controls.
            physics: AlwaysScrollableScrollPhysics(), // Default physics.
          ),
        ),
      ),
    );


  }

  Widget buildBottomPart() {
    return Container(
      child: buildButton(
        'Continue Shopping',
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
}
