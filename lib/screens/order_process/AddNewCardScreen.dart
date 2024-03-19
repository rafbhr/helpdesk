import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '/colors/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/constant/Constants.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';
//import 'package:month_picker_dialog/month_picker_dialog.dart';

class AddNewCardScreen extends StatefulWidget {
  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  TextEditingController cardNumber = new TextEditingController();
  TextEditingController validUntil = new TextEditingController();
  TextEditingController cvv = new TextEditingController();
  TextEditingController cardHolder = new TextEditingController();

  FocusNode focusNodeCardNumber = new FocusNode();
  FocusNode focusNodeValidUntil = new FocusNode();
  FocusNode focusNodeCvv = new FocusNode();
  FocusNode focusNodeCardHolder = new FocusNode();
  FocusNode focusNodeErrorNotification = new FocusNode();

  late DateTime selectedCardExpiryDate;

  bool isSaveCardSelected = false,
      displaySuccessDialog = false,
      isDisplayErrorNotification = false;

  String errorMessage = '';

  void showErrorNotification(String message) {
    setState(() {
      isDisplayErrorNotification = true;
      errorMessage = message;
      FocusScope.of(context).requestFocus(focusNodeErrorNotification);
    });
  }

  void hideErrorNotification() {
    setState(() {
      isDisplayErrorNotification = false;
      errorMessage = "";
    });
  }

  @override
  void initState() {
    super.initState();
    focusNodeCardNumber.addListener(() => setState(() {}));
    focusNodeValidUntil.addListener(() => setState(() {}));
    focusNodeCvv.addListener(() => setState(() {}));
    focusNodeCardHolder.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    focusNodeCardNumber.dispose();
    focusNodeValidUntil.dispose();
    focusNodeCvv.dispose();
    focusNodeCardHolder.dispose();
    focusNodeErrorNotification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(context, newCardLabel, onBackPress: () {
      //   Navigator.pop(context);
      // }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                child: Card(
                  elevation: 6,
                  color: isDarkMode(context) ? Colors.white10 : Colors.white,
                  shadowColor: Colors.grey.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 22.0, right: 22.0, top: 8, bottom: 10),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Visibility(
                              visible: isDisplayErrorNotification,
                              child: buildErrorNotificationWithOption(
                                context,
                                errorMessage,
                                hideLabel,
                                isDarkMode(context) ? Colors.red[900]! : pinkishColor,
                                true,
                                focusNode: focusNodeErrorNotification,
                                onOptionTap: () {
                                  setState(
                                    () {
                                      isDisplayErrorNotification = false;
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            isDarkMode(context)
                                ? '$darkIconPath/new_card.svg'
                                : '$lightIconPath/new_card.svg',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5.5,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            cardNumberLabel,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildAddCardNumber(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    validUntilLabel,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    child: buildValidUntil(),
                                    onTap: () {
                                      //buildDatePicker(context);
                                    },
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cvvLabel,
                                    style:
                                        Theme.of(context).textTheme.subtitle2,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  buildCvvNumber()
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            cardHolderLabel,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildCardHolderName(),
                        SizedBox(
                          height: 20,
                        ),
                        buildCheckBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: displaySuccessDialog,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black26,
                      ),
                      buildSuccessDialog(),
                    ],
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !displaySuccessDialog,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 16.0, left: 22, right: 22, bottom: 8.0),
          child: new Container(
            height: 56.0,
            alignment: Alignment.center,
            child: buildSBottomButtons(),
          ),
        ),
      ),
    );
  }

  Widget buildAddCardNumber() {
    return buildTextField(
        context,
        cardNumber,
        TextCapitalization.none,
        TextInputType.number,
        TextInputAction.next,
        true,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeCardNumber.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        16,
        '',
        true,
        focusNode: focusNodeCardNumber,
        onChange: (value) {},
        onSubmit: () {});
  }

  Widget buildValidUntil() {
    return buildTextField(
        context,
        validUntil,
        TextCapitalization.none,
        TextInputType.number,
        TextInputAction.next,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeValidUntil.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        16,
        selectedCardExpiryDate != null
            ? '${selectedCardExpiryDate?.year}\/${selectedCardExpiryDate?.month}'
            : '',
        false,
        focusNode: focusNodeValidUntil,
        onChange: (value) {},
        onSubmit: () {});
  }

  Widget buildCvvNumber() {
    return buildTextField(
        context,
        cvv,
        TextCapitalization.none,
        TextInputType.number,
        TextInputAction.next,
        true,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeCvv.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        3,
        '',
        true,
        focusNode: focusNodeCvv,
        onChange: (value) {},
        onSubmit: () {});
  }

  Widget buildCardHolderName() {
    return buildTextField(
        context,
        cardHolder,
        TextCapitalization.words,
        TextInputType.name,
        TextInputAction.done,
        false,
        primaryColor,
        10.0,
        primaryColor,
        primaryColor,
        primaryColor,
        focusNodeCardHolder.hasFocus
            ? primaryColor.withOpacity(0.15)
            : Colors.transparent,
        16,
        '',
        true,
        focusNode: focusNodeCardHolder,
        onChange: (value) {},
        onSubmit: () {});
  }

  /*
  buildDatePicker(BuildContext context) async {
    final DateTime picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );

    if (picked != null && picked != selectedCardExpiryDate)
      setState(
        () {
          selectedCardExpiryDate = picked;
        },
      );
  }

   */

  Widget buildCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: isSaveCardSelected,
          activeColor: primaryColor,
          onChanged: (b) {
            setState(() {
              isSaveCardSelected = b!;
            });
          },
        ),
        Expanded(
          child: Text(
            saveCardLabel,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  Widget buildSuccessDialog() {
    return buildDialog(
      context,
      cardAddedSuccessLabel,
      goBackLabel,
      isDarkMode(context)
          ? '$darkIconPath/card.svg'
          : '$baseImagePath/card.svg',
      onTap: () {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget buildSBottomButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: buildButton(
              cancelLabel,
              true,
              secondaryColor,
              Colors.white,
              2,
              2,
              8,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            child: buildButtonWithSuffixIcon(
              continueLabel,
              Icons.arrow_forward_rounded,
              true,
              isDarkMode(context) ? primaryColorDark : primaryColor,
              isDarkMode(context)
                  ? Colors.white.withOpacity(0.8)
                  : Colors.white,
              2,
              2,
              8,
              onPressed: () {
                checkValidations();
              },
            ),
          ),
        )
      ],
    );
  }

  void checkValidations() {
    if (cardNumber.text.isEmpty) {
      showErrorNotification('Please enter card number');
    } else if (cardNumber.text.length != 16) {
      showErrorNotification('Please enter 16 digit in card number');
    } else if (selectedCardExpiryDate == null) {
      showErrorNotification('Please select card expiry date');
    } else if (cvv.text.isEmpty) {
      showErrorNotification('Please select country');
    } else if (cardHolder.text.isEmpty) {
      showErrorNotification('Please enter zip code');
    } else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(context);
      setState(() {
        displaySuccessDialog = true;
      });
    }
  }
}
