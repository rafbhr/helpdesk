import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/Util.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({required Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  FocusNode focusNodeName = new FocusNode();
  FocusNode focusNodePhoneNum = new FocusNode();
  FocusNode focusNodeDob = new FocusNode();

  var userDob = DateTime.now();
  late DateTime selectedDob;

  String errorMessage = '';
  bool isDisplayErrorNotification = false;

  void showErrorNotification(String message) {
    setState(
      () {
        isDisplayErrorNotification = true;
        errorMessage = message;
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
    nameController.text = demoUserFullName;
    phoneNumController.text = demoPhoneNumber;
    dobController.text = demoDateOfBirth;

    nameController.addListener(() => setState(() {}));
    phoneNumController.addListener(() => setState(() {}));
    dobController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    focusNodeName.dispose();
    focusNodePhoneNum.dispose();
    focusNodeDob.dispose();
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
        editProfileLabel,
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
              vertical: getProportionateScreenWidth(8),
            ),
            child: Column(
              children: [
                Visibility(
                  visible: isDisplayErrorNotification,
                  child: buildErrorNotification(
                    errorMessage,
                    isDarkMode(context) ? Colors.red[900]! : pinkishColor,
                  ),
                ),
                buildInputFields(),
                SizedBox(
                  height: getProportionateScreenWidth(16),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildSaveButton(),
    );
  }

  Container buildSaveButton() {
    return Container(
      height: SizeConfig.screenHeight * 0.10,
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(22)),
      child: buildButton(
        saveLabel,
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

  Column buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getProportionateScreenWidth(16),
        ),
        Text(
          fullNameLabel,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(
          height: getProportionateScreenWidth(8),
        ),
        buildTextField(
          context,
          nameController,
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
          '',
          true,
          focusNode: focusNodeName,
          onChange: (value) {},
          onSubmit: () {},
        ),
        SizedBox(
          height: getProportionateScreenWidth(16),
        ),
        Text(
          moNumLabel,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(
          height: getProportionateScreenWidth(8),
        ),
        buildTextField(
          context,
          phoneNumController,
          TextCapitalization.none,
          TextInputType.number,
          TextInputAction.next,
          false,
          lightGreyColor.withOpacity(0.5),
          8.0,
          lightGreyColor.withOpacity(0.2),
          primaryColor,
          secondaryColor.withOpacity(0.2),
          focusNodePhoneNum.hasFocus
              ? isDarkMode(context)
                  ? primaryColor.withOpacity(0.3)
                  : primaryColor.withOpacity(0.15)
              : isDarkMode(context)
                  ? primaryColor.withOpacity(0.15)
                  : Colors.white,
          13,
          '',
          true,
          focusNode: focusNodePhoneNum,
          onChange: (value) {},
          onSubmit: () {},
        ),
        SizedBox(
          height: getProportionateScreenWidth(16),
        ),
        Text(
          dobLabel,
          style: Theme.of(context).textTheme.subtitle2,
        ),
        SizedBox(
          height: getProportionateScreenWidth(8),
        ),
        InkWell(
          child: buildTextField(
            context,
            dobController,
            TextCapitalization.none,
            TextInputType.number,
            TextInputAction.next,
            false,
            lightGreyColor.withOpacity(0.5),
            8.0,
            lightGreyColor.withOpacity(0.2),
            primaryColor,
            secondaryColor.withOpacity(0.2),
            focusNodeDob.hasFocus
                ? isDarkMode(context)
                    ? primaryColor.withOpacity(0.3)
                    : primaryColor.withOpacity(0.15)
                : isDarkMode(context)
                    ? primaryColor.withOpacity(0.15)
                    : Colors.white,
            TextField.noMaxLength,
            '',
            false,
            focusNode: focusNodeDob,
            onChange: (value) {},
            onSubmit: () {},
          ),
          onTap: () {
            buildDateOfBirthPicker(context);
          },
        ),
      ],
    );
  }

  buildDateOfBirthPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      helpText: selectDobLabel,
      initialDate: userDob,
      firstDate: DateTime(1901),
      lastDate: DateTime.now(),
    );

    FocusScope.of(context).requestFocus(FocusNode());

    if (picked != null && picked != selectedDob)
      setState(
        () {
          userDob = picked;
          String selectedDob = DateFormat('dd/MM/yyyy').format(userDob);
          dobController.text = selectedDob;
          demoDateOfBirth = selectedDob;

        },
      );
  }

  void checkValidations() {
    // Edit validations as per your need

    if (nameController.text.isEmpty) {
      showErrorNotification(pleaseEnterName);
    } else if (phoneNumController.text.isEmpty) {
      showErrorNotification(pleaseEnterMobileNum);
    } else {
      setState(
        () {
          if (nameController.text != null) {
            demoUserFullName = nameController.text;
          }

          if (phoneNumController.text != null &&
              phoneNumController.text.length >= 10) {
            demoPhoneNumber = phoneNumController.text;
          }
        },
      );

      showInfoToast(context, passwordUpdateSuccess);
      Navigator.pop(context);
    }
  }
}
