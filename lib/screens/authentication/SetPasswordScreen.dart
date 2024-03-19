import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/widgets/Styles.dart';
import '/screens/authentication/VerifyAccountScreen.dart';
import '/util/Util.dart';

class SetPasswordScreen extends StatefulWidget {
  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  bool isDisplayErrorNotification = false;

  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

  FocusNode focusNodePassword = new FocusNode();
  FocusNode focusNodeConfirmPassword = new FocusNode();

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
    focusNodePassword.addListener(() => setState(() {}));
    focusNodeConfirmPassword.addListener(() => setState(() {}));
    //INFO: dummy password
    password.text = demoPassword;
    confirmPassword.text = demoPassword;
  }

  @override
  void dispose() {
    focusNodePassword.dispose();
    focusNodeConfirmPassword.dispose();
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
                      Container(
                        child: buildHeaderLayout(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child:
                            buildPasswordInputField(password, confirmPassword),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: buildContinueButtons(),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
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
          Visibility(
            visible: isDisplayErrorNotification,
            child: buildErrorNotificationWithOption(
              context,
              errorMessage,
              '',
              isDarkMode(context) ? Colors.red[900]! : pinkishColor,
              true,
              onOptionTap: () {},
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            setPasswordPrefix,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            setPasswordSuffix,
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 10,
          ),
          Text(passwordInfo,style: Theme.of(context).textTheme.bodyText2,),
        ],
      ),
    );
  }

  Widget buildPasswordInputField(
      TextEditingController password, TextEditingController confirmPassword) {
    return Column(
      children: [
        //INFO: Password field
        Container(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 0,
            ),
            child: Container(
              height: 50,
              child: buildTextField(
                  context,
                  password,
                  TextCapitalization.none,
                  TextInputType.text,
                  TextInputAction.done,
                  true,
                  lightGreyColor.withOpacity(0.5),
                  8.0,
                  lightGreyColor.withOpacity(0.2),
                  primaryColor,
                  primaryColor,
                  focusNodePassword.hasFocus
                      ? isDarkMode(context)
                          ? primaryColor.withOpacity(0.3)
                          : primaryColor.withOpacity(0.15)
                      : isDarkMode(context)
                          ? primaryColor.withOpacity(0.15)
                          : Colors.white,
                  TextField.noMaxLength,
                  passwordLabel,
                  true,
                  focusNode: focusNodePassword,
                  onChange: (value) {},
                  onSubmit: () {}),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),

        //INFO: Confirm password field
        Container(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 0,
            ),
            child: Container(
              height: 50,
              child: buildTextField(
                  context,
                  confirmPassword,
                  TextCapitalization.none,
                  TextInputType.text,
                  TextInputAction.done,
                  true,
                  lightGreyColor.withOpacity(0.5),
                  8.0,
                  lightGreyColor.withOpacity(0.2),
                  primaryColor,
                  primaryColor,
                  focusNodeConfirmPassword.hasFocus
                      ? isDarkMode(context)
                          ? primaryColor.withOpacity(0.3)
                          : primaryColor.withOpacity(0.15)
                      : isDarkMode(context)
                          ? primaryColor.withOpacity(0.15)
                          : Colors.white,
                  TextField.noMaxLength,
                  confirmPasswordLabel,
                  true,
                  focusNode: focusNodeConfirmPassword,
                  onChange: (value) {},
                  onSubmit: () {}),
            ),
          ),
        ),

        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget buildContinueButtons() {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              buildButton(
                continueLabel,
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
            ],
          ),
        )
      ],
    );
  }

  void checkValidations() {
    if (password.text.isEmpty) {
      showErrorNotification(pleaseEnterPassword);
    } else if (confirmPassword.text.isEmpty) {
      showErrorNotification(pleaseEnterRepeatPassword);
    } else if (password.text != confirmPassword.text) {
      showErrorNotification(passwordsNotMatch);
    } else if (password.text.length <= 5) {
      showErrorNotification(passwordLengthError);
    } else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(context);
      navigateToScreen(context, VerifyAccountScreen());
    }
  }
}
