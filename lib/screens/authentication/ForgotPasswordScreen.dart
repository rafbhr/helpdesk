import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';

import 'ResetPasswordSuccessScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  FocusNode focusNodeEmail = new FocusNode();
  FocusNode focusNodeErrorNotification = new FocusNode();

  TextEditingController email = new TextEditingController();

  bool isDisplayErrorNotification = false,
      isUnAuthFlag = false,
      showLoadingIndicator = false;
  String errorMessage = '';

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
    focusNodeEmail.addListener(() => setState(() {}));
    email.text = demoEmail;
  }

  @override
  void dispose() {
    focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: false,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 8),
                  child: Column(
                    children: [
                      Visibility(
                          visible: isDisplayErrorNotification,
                          child: buildErrorNotification(
                            errorMessage,
                            isDarkMode(context)
                                ? Colors.red[900]!
                                : pinkishColor,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: buildHeaderLayout(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildEmailInputField(email),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                          visible: showLoadingIndicator,
                          child: displayLoadingIndicator())
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Container(
          height: 60,
          child: buildChangePasswordButton(),
        ),
      ),
    );
  }

  Widget buildHeaderLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            forgotLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            forgotPasswordLabel,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10,
          ),
          Text(enterEmail, style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }

  Widget buildEmailInputField(TextEditingController password) {
    return Column(
      children: [
        //email field
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
                TextInputAction.done,
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
                onSubmit: () {},
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget buildChangePasswordButton() {
    return Container(
      child: buildButton(
        resetPasswordLabel,
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          checkValidations();
        },
      ),
    );
  }

  void checkValidations() {
    if (email.text.isEmpty) {
      showErrorNotification(pleaseEnterEmail);
    } else if (!EmailValidator.validate(
      email.text.trim(),
    )) {
      showErrorNotification(pleaseEnterValidEmail);
    } else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(context);
      setState(() {
        showLoadingIndicator = true;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          showLoadingIndicator = false;
        });
        navigateToScreen(context, ResetPasswordSuccessScreen());
      });
    }
  }
}
