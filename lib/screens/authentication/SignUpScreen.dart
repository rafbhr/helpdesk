import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/screens/launch/HomeScreen.dart';
import '/widgets/Styles.dart';
import '/screens/authentication/LoginScreen.dart';
import '/util/Util.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SetPasswordScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String errorMessage = "";

  bool isDisplayErrorNotification = false,
      isUnAuthFlag = false,
      termsConditionsChecked = true,
      enableCheckBox = true,
      showLoadingIndicator = false;

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();

  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodeName = new FocusNode();
  FocusNode focusNodeSurname = new FocusNode();

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  void showErrorNotification(String message) {
    setState(() {
      isDisplayErrorNotification = true;
      errorMessage = message;
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

    focusNodeEmail.addListener(onFocusChanged);
    focusNodeName.addListener(onFocusChanged);
    focusNodeSurname.addListener(onFocusChanged);
    //INFO: dummy username and password
    name.text = demoName;
    surname.text = demoSurname;

    email.text = demoEmail;
  }

  @override
  void dispose() {
    focusNodeName.dispose();
    focusNodeSurname.dispose();
    focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
                    child: Column(
                      children: [
                        Container(child: buildHeaderLayout()),
                        SizedBox(
                          height: 20,
                        ),
                        buildSignUpInputField(name, surname, email),
                        Container(
                          child: buildTermsAndCondition(),
                        ),
                        Visibility(
                            visible: showLoadingIndicator,
                            child: displayLoadingIndicator()),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: buildSignUpButtons()),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 56.0,
        alignment: Alignment.center,
        child: buildBottomPart(),
      ),
    );
  }

  Widget buildHeaderLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
              visible: isDisplayErrorNotification,
              child: buildErrorNotificationWithOption(context, errorMessage, '',
                  isDarkMode(context) ? Colors.red[900]! : pinkishColor, false,
                  onOptionTap: () {})),
          SizedBox(
            height: 10,
          ),
          Text(
            welcomeLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10,
          ),
          Text(provideDetailsLabel,
              style: Theme.of(context).textTheme.bodyText2),
        ],
      ),
    );
  }

  Widget buildSignUpInputField(TextEditingController name,
      TextEditingController surname, TextEditingController email) {
    return Column(
      children: [
        //INFO: name field
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 0),
            child: (Container(
              height: 50,
              child: (buildTextField(
                  context,
                  name,
                  TextCapitalization.words,
                  TextInputType.name,
                  TextInputAction.next,
                  false,
                  lightGreyColor.withOpacity(0.5),
                  8.0,
                  lightGreyColor.withOpacity(0.2),
                  primaryColor,
                  secondaryColor.withOpacity(0.2),
                  focusNodeName.hasFocus
                      ? isDarkMode(context)
                          ? primaryColor.withOpacity(0.3)
                          : primaryColor.withOpacity(0.15)
                      : isDarkMode(context)
                          ? primaryColor.withOpacity(0.15)
                          : Colors.white,
                  TextField.noMaxLength,
                  nameLabel,
                  true,
                  focusNode: focusNodeName,
                  onChange: (value) {}, onSubmit: () {
                FocusScope.of(context).requestFocus(focusNodeSurname);
              })),
            )),
          ),
        ),

        //INFO: surname field
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 0),
            child: Container(
              height: 50,
              child: buildTextField(
                context,
                surname,
                TextCapitalization.words,
                TextInputType.name,
                TextInputAction.next,
                false,
                lightGreyColor.withOpacity(0.5),
                8.0,
                lightGreyColor.withOpacity(0.2),
                primaryColor,
                secondaryColor.withOpacity(0.2),
                focusNodeSurname.hasFocus
                    ? isDarkMode(context)
                        ? primaryColor.withOpacity(0.3)
                        : primaryColor.withOpacity(0.15)
                    : isDarkMode(context)
                        ? primaryColor.withOpacity(0.15)
                        : Colors.white,
                TextField.noMaxLength,
                surnameLabel,
                true,
                focusNode: focusNodeSurname,
                onChange: (value) {},
                onSubmit: () {
                  FocusScope.of(context).requestFocus(focusNodeEmail);
                },
              ),
            ),
          ),
        ),

        //INFO: email field
        Container(
          child: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 0),
            child: Container(
              height: 50,
              child: buildTextField(
                context,
                email,
                TextCapitalization.none,
                TextInputType.emailAddress,
                TextInputAction.next,
                false,
                lightGreyColor.withOpacity(0.5),
                8.0,
                lightGreyColor.withOpacity(0.2),
                primaryColor,
                secondaryColor.withOpacity(0.2),
                focusNodeEmail.hasFocus
                    ? isDarkMode(context)
                        ? primaryColor.withOpacity(0.3)
                        : primaryColor.withOpacity(0.15)
                    : isDarkMode(context)
                        ? primaryColor.withOpacity(0.15)
                        : Colors.white,
                TextField.noMaxLength,
                emailLabel,
                true,
                focusNode: focusNodeEmail,
                onChange: (value) {},
                onSubmit: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTermsAndCondition() {
    return Container(
      child: CheckboxListTile(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: userAgreementLabel,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              TextSpan(
                text: termsAndConditionLabel,
                style: authScreensClickableLabelStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL('https://example.com/privacy-policy');
                  },
              )
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: termsConditionsChecked,
        onChanged: enableCheckBox
            ? (bool? value) {
          setState(
                () {
              termsConditionsChecked = value ?? false;
              hideErrorNotification();
            },
          );
        } : null,
        checkColor: Colors.white,
        activeColor: primaryColor,
      ),
    );
  }

  Widget buildSignUpButtons() {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              buildButton(
                signUpLabel,
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
              SizedBox(
                height: 15,
              ),
              buildButtonWithIcon(
                context,
                '$baseImagePath/fb.png',
                signUpWithFB,
                true,
                isDarkMode(context)
                    ? Colors.white24
                    : Colors.black.withOpacity(0.7),
                Colors.white,
                2,
                2,
                8,
                onPressed: () {
                  setState(
                    () {
                      showLoadingIndicator = true;
                    },
                  );
                  Future.delayed(
                    Duration(milliseconds: 500),
                    () {
                      navigateAndClearHistory(context, HomeScreen.routeName);
                    },
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildBottomPart() {
    return Container(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: alreadyAccountLabel,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            TextSpan(
              text: signInLabel,
              style: authScreensClickableLabelStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  navigateToScreen(context, LoginScreen());
                },
            )
          ],
        ),
      ),
    );
  }

  void checkValidations() {
    if (name.text.isEmpty) {
      showErrorNotification(pleaseEnterName);
    } else if (surname.text.isEmpty) {
      showErrorNotification(pleaseEnterSurname);
    } else if (email.text.isEmpty) {
      showErrorNotification(pleaseEnterEmail);
    } else if (!EmailValidator.validate(email.text.trim())) {
      showErrorNotification(pleaseEnterValidEmail);
    } else if (!termsConditionsChecked) {
      showErrorNotification(agreeTermsConditions);
    } else {
      hideErrorNotification();
      setState(() {
        showLoadingIndicator = true;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        navigateToScreen(context, SetPasswordScreen());
      });
    }
  }

  void onFocusChanged() {
    setState(() {});
  }
}
