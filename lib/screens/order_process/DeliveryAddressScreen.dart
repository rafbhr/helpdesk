import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/widgets/Styles.dart';
import '/screens/order_process/AddNewAddressScreen.dart';
import '/screens/order_process/PaymentMethodScreen.dart';
import '/util/Util.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final bool shouldDisplayPaymentButton;

  const DeliveryAddressScreen({required Key key, required this.shouldDisplayPaymentButton})
      : super(key: key);

  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(context, deliveryAddressLabel, onBackPress: () {
      //   Navigator.pop(context);
      // }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAddNewAddress(),
              buildHomeAddress(),
              buildBillingAddress()
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: widget.shouldDisplayPaymentButton,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 22, right: 22, bottom: 25.0),
          child: new Container(
            height: 56.0,
            alignment: Alignment.center,
            child: buildPaymentButton(),
          ),
        ),
      ),
    );
  }

  Widget buildAddNewAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16,
      ),
      child: InkWell(
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode(context)
                  ? primaryColor.withOpacity(0.4)
                  : primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: isDarkMode(context) ? Colors.white70 : primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    newAddressLabel,
                    style: TextStyle(
                      fontFamily: poppinsFont,
                      color: isDarkMode(context) ? Colors.white70 : primaryColor,
                      fontSize: Theme.of(context).textTheme.button?.fontSize,
                    ),
                  ),
                ],
              ),
            )),
        highlightColor: primaryColor.withOpacity(0.2),
        onTap: () => navigateToScreen(
          context,
          AddNewAddressScreen(),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  homeAddressLabel,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
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
                Text(defaultAddressLabel,
                    style: homeScreensClickableLabelStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBillingAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(billingAddressLabel,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                ),
                SizedBox(
                  height: 5,
                ),
                Text('4153  Rosewood Lane',
                    style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: 5,
                ),
                Text('Toronto, M4P 1A6',
                    style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: 5,
                ),
                Text('Canada', style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Text(setDefaultAddressLabel,
                      style: homeScreensClickableLabelStyle),
                  highlightColor: primaryColor.withOpacity(0.1),
                  onTap: () {
                    showInfoToast(context, changeDefaultAddressLabel);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPaymentButton() {
    return Container(
      child: buildButtonWithSuffixIcon(
        proceedToPaymentLabel,
        Icons.arrow_forward_rounded,
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          navigateToScreen(
            context,
            PaymentMethodScreen(
              shouldDisplayContinueButton: true, key: UniqueKey(),
            ),
          );
        },
      ),
    );
  }
}
