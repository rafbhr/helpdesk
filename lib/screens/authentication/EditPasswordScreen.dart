import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';

import 'ForgotPasswordScreen.dart';

class EditPasswordScreen extends StatefulWidget {
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  bool isDisplayErrorNotification = false;

  TextEditingController oldPassword = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  TextEditingController confirmNewPassword = new TextEditingController();

  FocusNode focusNodeOldPassword = new FocusNode();
  FocusNode focusNodeNewPassword = new FocusNode();
  FocusNode focusNodeConfirmNewPassword = new FocusNode();
  FocusNode focusNodeErrorNotification = new FocusNode();

  String errorMessage = '';

  void showErrorNotification(String message) {
    setState(
      () {
        isDisplayErrorNotification = true;
        errorMessage = message;
        FocusScope.of(context).requestFocus(focusNodeErrorNotification);
      },
    );
  }

  void hideErrorNotification() {
    setState(
      () {
        isDisplayErrorNotification = false;
        errorMessage = "";
      },
    );
  }

  @override
  void initState() {
    super.initState();
    focusNodeOldPassword.addListener(() => setState(() {}));
    focusNodeNewPassword.addListener(() => setState(() {}));
    focusNodeConfirmNewPassword.addListener(() => setState(() {}));
    //INFO: dummy password
    oldPassword.text = demoPassword;
    newPassword.text = demoPassword;
    confirmNewPassword.text = demoPassword;
  }

  @override
  void dispose() {
    focusNodeOldPassword.dispose();
    focusNodeNewPassword.dispose();
    focusNodeConfirmNewPassword.dispose();
    focusNodeErrorNotification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PreferredSize buildAppBar(BuildContext context, String title, {VoidCallback? onBackPress}) {
      return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Set the height as needed
        child: AppBar(
          // Your AppBar code here
        ),
      );
    }
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      appBar: buildAppBar(
        context,
        editPassword,
        onBackPress: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: false,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Column(
                    children: [
                      Container(
                        child: buildHeaderLayout(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: buildPasswordInputField(),
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
              forgetPasswordLabel,
              isDarkMode(context) ? Colors.red[900]! : pinkishColor,
              true,
              focusNode: focusNodeErrorNotification,
              onOptionTap: () {
                navigateToScreen(
                  context,
                  ForgotPasswordScreen(),
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(passwordInfo, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }

  Widget buildPasswordInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //INFO: new Password field
        Text(
          oldPasswordLabel,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(
          height: getProportionateScreenWidth(8),
        ),
        buildTextField(
            context,
            oldPassword,
            TextCapitalization.none,
            TextInputType.text,
            TextInputAction.next,
            true,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            primaryColor,
            focusNodeOldPassword.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            TextField.noMaxLength,
            '',
            true,
            focusNode: focusNodeOldPassword,
            onChange: (value) {},
            onSubmit: () {}),
        SizedBox(
          height: getProportionateScreenWidth(16),
        ),
        Text(
          newPasswordLabel,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(
          height: getProportionateScreenWidth(8),
        ),
        //INFO: new password field
        buildTextField(
            context,
            newPassword,
            TextCapitalization.none,
            TextInputType.text,
            TextInputAction.done,
            true,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            primaryColor,
            focusNodeNewPassword.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            TextField.noMaxLength,
            '',
            true,
            focusNode: focusNodeNewPassword,
            onChange: (value) {},
            onSubmit: () {}),
        SizedBox(
          height: getProportionateScreenWidth(16),
        ),

        //INFO: Confirm new password field
        Text(
          confirmNewPasswordLabel,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(
          height: getProportionateScreenWidth(8),
        ),
        buildTextField(
            context,
            confirmNewPassword,
            TextCapitalization.none,
            TextInputType.text,
            TextInputAction.done,
            true,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            primaryColor,
            focusNodeConfirmNewPassword.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            TextField.noMaxLength,
            '',
            true,
            focusNode: focusNodeConfirmNewPassword,
            onChange: (value) {},
            onSubmit: () {}),

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
// INFO: Change your validations

    if (oldPassword.text.isEmpty) {
      showErrorNotification(pleaseEnterOldPassword);
    } else if (newPassword.text.isEmpty) {
      showErrorNotification(pleaseEnterPassword);
    } else if (confirmNewPassword.text.isEmpty) {
      showErrorNotification(pleaseEnterRepeatPassword);
    } else if (newPassword.text != confirmNewPassword.text) {
      showErrorNotification(passwordsNotMatch);
    } else if (newPassword.text.length <= 5) {
      showErrorNotification(passwordLengthError);
    } else {
      if (isDisplayErrorNotification == true) {
        hideErrorNotification();
      }
      hideKeyboard(context);
      showInfoToast(context, passwordChangeSuccess);
      navigateAndClearHistory(context, '/LoginScreen');
    }
  }
}
