import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/widgets/Styles.dart';
import '/screens/order_process/AddNewCardScreen.dart';
import '/screens/order_process/OrderSuccessfulScreen.dart';
import '/util/Util.dart';

class PaymentMethodScreen extends StatefulWidget {
  final bool shouldDisplayContinueButton;

  const PaymentMethodScreen({required Key key, required this.shouldDisplayContinueButton})
      : super(key: key);

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(
      //   context,
      //   paymentMethodLabel,
      //   onBackPress: () {
      //     Navigator.pop(context);
      //   },
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creditDebitLabel,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                ),
                SizedBox(
                  height: 10,
                ),
                buildATMCard(),
                SizedBox(
                  height: 20,
                ),
                buildAddNewCard(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  walletLabel,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                ),
                SizedBox(
                  height: 10,
                ),
                buildWalletStickers(),
                SizedBox(
                  height: 10,
                ),
                Text(netBankingLabel,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                ),
                SizedBox(
                  height: 10,
                ),
                buildNetBankingStickers()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: widget.shouldDisplayContinueButton,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 22, right: 22, bottom: 25.0),
          child: new Container(
            height: 56.0,
            alignment: Alignment.center,
            child: buildContinueButton(),
          ),
        ),
      ),
    );
  }

  Widget buildATMCard() {
    return Card(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    '$baseImagePath/master_card.png',
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(dummyCardDetails,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  InkWell(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(10, 10))),
                      child: Center(
                          child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )),
                    ),
                    onTap: () {}(),
                  ),
                ],
              ),
              Divider(),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    '$baseImagePath/visa.png',
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(dummyVisaCard,
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddNewCard() {
    return InkWell(
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
                newCardLabel,
                style: TextStyle(
                  fontFamily: poppinsFont,
                  color: isDarkMode(context) ? Colors.white70 : primaryColor,
                  fontSize: Theme.of(context).textTheme.button?.fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
      highlightColor: primaryColor.withOpacity(0.2),
      onTap: () {
        navigateToScreen(
          context,
          AddNewCardScreen(),
        );
      },
    );
  }

  Widget buildWalletStickers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildPaymentMethodUI('gpay.png', onTap: () {
          showInfoToast(context, 'Use Google Pay wallet');
        }),
        buildPaymentMethodUI('phonepe.png', onTap: () {
          showInfoToast(context, 'Use PhonePay wallet');
        }),
        buildPaymentMethodUI('amazon_pay.png', onTap: () {
          showInfoToast(context, 'Use Amazon wallet');
        }),
        buildPaymentMethodUI('upi.png', onTap: () {
          showInfoToast(context, 'Use Bhim UPI wallet');
        }),
      ],
    );
  }

  Widget buildNetBankingStickers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildPaymentMethodUI('sbi.png', onTap: () {
          showInfoToast(context, 'Use SBI net baking');
        }),
        buildPaymentMethodUI('yes_bank.png', onTap: () {
          showInfoToast(context, 'Use Yes Bank net baking');
        }),
        buildPaymentMethodUI('axis_bank.png', onTap: () {
          showInfoToast(context, 'Use Axis Bank net baking');
        }),
        buildPaymentMethodUI('hdfc_bank.png', onTap: () {
          showInfoToast(context, 'Use Yes HDFC net baking');
        }),
      ],
    );
  }

  Widget buildPaymentMethodUI(String image, {@required onTap}) {
    return InkWell(
      child: Card(
        elevation: 0.2,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            '$baseImagePath/$image',
            width: MediaQuery.of(context).size.width / 6,
          ),
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }

  Widget buildContinueButton() {
    return Container(
      child: buildButtonWithSuffixIcon(
        continueLabel,
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
            OrderSuccessfulScreen(),
          );
        },
      ),
    );
  }
}
