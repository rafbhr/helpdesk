import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '/colors/Colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/constant/Constants.dart';
import '/widgets/Styles.dart';
import 'package:country_picker/country_picker.dart';
import '/util/Util.dart';

class AddNewAddressScreen extends StatefulWidget {
  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  ScrollController scrollController = new ScrollController();
  TextEditingController addressLineOne = new TextEditingController();
  TextEditingController city = new TextEditingController();
  TextEditingController zipCode = new TextEditingController();
  TextEditingController country = new TextEditingController();

  FocusNode focusNodeAddressOne = new FocusNode();
  FocusNode focusNodeCity = new FocusNode();
  FocusNode focusNodeZipCode = new FocusNode();
  FocusNode focusNodeCountry = new FocusNode();
  FocusNode focusNodeErrorNotification = new FocusNode();

  String countryName = 'Select Country', errorMessage = '';
  bool isHomeSelected = false,
      isOfficeSelected = false,
      displaySuccessDialog = false,
      isDisplayErrorNotification = false;

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
  void dispose() {
    focusNodeAddressOne.dispose();
    focusNodeCity.dispose();
    focusNodeZipCode.dispose();
    focusNodeCountry.dispose();
    focusNodeErrorNotification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(context, newAddressLabel, onBackPress: () {
      //   Navigator.pop(context);
      // }),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
                child: Card(
                  elevation: 6,
                  color: isDarkMode(context) ? darkGreyColor : Colors.white,
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
                                    isDarkMode(context)
                                        ? Colors.red[900]!
                                        : pinkishColor,
                                    true,
                                    focusNode: focusNodeErrorNotification,
                                    onOptionTap: () {
                                  setState(() {
                                    isDisplayErrorNotification = false;
                                  });
                                })),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            isDarkMode(context)
                                ? '$darkIconPath/new_address.svg'
                                : '$lightIconPath/new_address.svg',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            addressLabel,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        buildAddressLineOneInput(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            cityLabel,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        buildCityInput(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            countryLabel,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        buildCountryPicker(),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            zipLabel,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        buildZipCodeInput(),
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
                ),
              ),
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
            child: buildBottomButtons(),
          ),
        ),
      ),
    );
  }

  Widget buildAddressLineOneInput() {
    return buildAddressInputField(
      context,
      addressLineOne,
      enterAddressLabel,
        Icons.cabin, // cannot be null
      TextInputType.streetAddress,
      TextInputAction.next,
      true,
      focusNodeAddressOne,
      onSubmitted: () {},
    );
  }

  Widget buildCityInput() {
    return buildAddressInputField(
      context,
      city,
      enterCityLabel,
      Icons.location_city,
      TextInputType.streetAddress,
      TextInputAction.next,
      true,
      focusNodeCity,
      onSubmitted: () {},
    );
  }

  Widget buildZipCodeInput() {
    return buildAddressInputField(
      context,
      zipCode,
      enterZipLabel,
      Icons.abc, // cannot be null
      TextInputType.number,
      TextInputAction.done,
      true,
      focusNodeZipCode,
      onSubmitted: () {},
    );
  }

  Widget buildCountryPicker() {
    return InkWell(
      child: buildAddressInputField(
        context,
        country,
        countryName,
        Icons.keyboard_arrow_down,
        TextInputType.name,
        TextInputAction.none,
        false,
        focusNodeCountry,
        onSubmitted: () {},
      ),
      onTap: () {
        displayCountryPicker();
      },
    );
  }

  Widget buildCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: isHomeSelected,
          activeColor: primaryColor,
          onChanged: (b) {
            setState(
              () {
                isHomeSelected = b!;
                if (b) {
                  isOfficeSelected = false;
                }
                isOfficeSelected = false;
              },
            );
          },
        ),
        Text(
          homeLabel,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(
          width: 30,
        ),
        Checkbox(
          value: isOfficeSelected,
          activeColor: primaryColor,
          onChanged: (b) {
            setState(
              () {
                isOfficeSelected = b!;
                if (b) {
                  isHomeSelected = false;
                }
              },
            );
          },
        ),
        Text(
          officeLabel,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }

  Widget buildSuccessDialog() {
    return buildDialog(
      context,
      addressAddedSuccess,
      goBackLabel,
      isDarkMode(context)
          ? '$darkIconPath/location.svg'
          : '$lightIconPath/location.svg',
      onTap: () {
        SchedulerBinding.instance.addPostFrameCallback(
          (_) {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Widget buildBottomButtons() {
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

  void displayCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(
          () {
            countryName = country.name;
          },
        );
      },
    );
  }

  void checkValidations() {
    if (addressLineOne.text.isEmpty) {
      showErrorNotification('Please enter address');
    } else if (city.text.isEmpty) {
      showErrorNotification('Please enter city');
    } else if (countryName == 'Select Country') {
      showErrorNotification('Please select country');
    } else if (zipCode.text.isEmpty) {
      showErrorNotification('Please enter zipcode');
    } else if (!isHomeSelected && !isOfficeSelected) {
      showErrorNotification(
          'Please select either home or office as address type');
    } else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(context);
      setState(
        () {
          displaySuccessDialog = true;
        },
      );
    }
  }
}
