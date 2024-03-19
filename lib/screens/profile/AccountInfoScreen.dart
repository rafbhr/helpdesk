import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/screens/authentication/EditPasswordScreen.dart';
import '/screens/profile/EditProfileScreen.dart';
import '/util/Util.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
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
        accountInfo,
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAccountInfo(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildEditButtons(),
    );
  }

  Widget buildAccountInfo() {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,

        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            buildListRow(emailLabel, demoEmail, onTap: () {}),
            Divider(),
            buildListRow(passwordLabel, demoHiddenPassword, onTap: () {}),
            Divider(),
            buildListRow(phoneLabel, demoPhoneNumber, onTap: () {}),
            Divider(),
            buildListRow(birthDateLabel, demoDateOfBirth, onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget buildListRow(String title, String data, {required Function onTap}) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(16),
            vertical: getProportionateScreenWidth(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              data,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
      onTap: onTap(),
    );
  }

  Widget buildEditButtons() {
    return Container(
      height: SizeConfig.screenHeight * 0.10,
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(22)),
      child: Row(
        children: [
          Expanded(
            child: buildButton(
              'Edit Profile',
              true,
              isDarkMode(context) ? primaryColorDark : primaryColor,
              isDarkMode(context)
                  ? Colors.white.withOpacity(0.8)
                  : Colors.white,
              2,
              2,
              8,
              onPressed: () {
                navigateToScreen(
                  context,
                  EditProfileScreen(key: UniqueKey(),),
                );
              },
            ),
          ),
          SizedBox(
            width: getProportionateScreenWidth(16),
          ),
          Expanded(
            child: buildButton(
              'Change Password',
              true,
              isDarkMode(context) ? primaryColorDark : primaryColor,
              isDarkMode(context)
                  ? Colors.white.withOpacity(0.8)
                  : Colors.white,
              2,
              2,
              8,
              onPressed: () {
                navigateToScreen(
                  context,
                  EditPasswordScreen(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
