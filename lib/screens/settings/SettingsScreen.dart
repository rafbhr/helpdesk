import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/colors/Colors.dart';
import '/notifier/dark_theme_provider.dart';
import '/screens/order_process/MyOrdersScreen.dart';
import '/screens/order_process/PaymentMethodScreen.dart';
import '/sharedPreference/PreferenceKeys.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/screens/order_process/DeliveryAddressScreen.dart';
import '/util/Util.dart';
import '/constant/Constants.dart';

import '../../widgets/NotificationsPrefBottomSheet.dart';

class SettingsScreen extends StatefulWidget {
  final isFromBottomNav;

  const SettingsScreen({required Key key, @required this.isFromBottomNav}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkTheme = false;
  late SharedPreferences sharedPreferences;

  addBoolInSharedPref(String key, bool value) async {
    sharedPreferences.setBool(key, value);
  }

  Future<bool?> getPrefBool(String key) async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key);
  }

  @override
  void initState() {
    super.initState();
    getPrefBool(PREF_IS_DARK_THEME).then((value) {
      setState(() {
        isDarkTheme = value!;
      });
    });
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

    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      appBar: buildAppBar(context, settingScreenTitle, onBackPress: () {
        if(widget.isFromBottomNav) {
          final CurvedNavigationBarState? navState = getNavState();
          navState?.setPage(0);
        }else{
          Navigator.pop(context);
        }
      }),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                child: Column(
                  children: [
                    buildAppSettings(context, themeChange),
                    SizedBox(
                      height: 20,
                    ),
                    buildProductSettings(context),
                    SizedBox(
                      height: 20,
                    ),
                    buildPrivacyPolicy(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !widget.isFromBottomNav,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            height: 56.0,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Shopping App. v 1.0',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card buildPrivacyPolicy(BuildContext context) {
    return Card(
      color: isDarkMode(context) ? darkGreyColor : Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          buildSettingsItem(
            label: privacyPolicy,
            onTap: () {
              launchUrl(privacy_policy_url);
            },
          ),
          Divider(),
          buildSettingsItem(
            label: aboutUs,
            onTap: () {
              launchUrl(about_us_url);
            },
          ),
        ],
      ),
    );
  }

  Card buildAppSettings(BuildContext context, DarkThemeProvider themeChange) {
    return Card(
      color: isDarkMode(context) ? darkGreyColor : Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          buildPrefRow(
            Icons.brightness_6_outlined,
            'Use Dark Theme',
            isDarkTheme,
            onChange: (v) {
              setState(
                () {
                  addBoolInSharedPref(PREF_IS_DARK_THEME, v);
                  isDarkTheme = v;
                  themeChange.darkTheme = v;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Card buildProductSettings(BuildContext context) {
    return Card(
      color: isDarkMode(context) ? darkGreyColor : Colors.white,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          buildSettingsItem(
            label: pastOrderHistoryLabel,
            onTap: () {
              navigateToScreen(context, MyOrdersScreen());
            },
          ),
          Divider(),
          buildSettingsItem(
            label: myAddressLabel,
            onTap: () {
              navigateToScreen(
                context,
                DeliveryAddressScreen(
                  shouldDisplayPaymentButton: false, key: UniqueKey(),
                ),
              );
            },
          ),
          Divider(),
          buildSettingsItem(
            label: paymentMethodLabel,
            onTap: () {
              navigateToScreen(
                context,
                PaymentMethodScreen(
                  shouldDisplayContinueButton: false, key: UniqueKey(),
                ),
              );
            },
          ),
          Divider(),
          buildSettingsItem(
            label: pushNotificationLabel,
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: buildNotificationPreference);
            },
          ),
        ],
      ),
    );
  }

  Widget buildSettingsItem({required String label, required Function onTap}) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isDarkMode(context)
                  ? Colors.white70
                  : Colors.black.withOpacity(0.75),
            ),
            onPressed: () {
              onTap();
            },
          ),
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }

  Widget buildPrefRow(IconData icon, String title, bool enabled,
      {required Function onChange}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Row(
        
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: enabled,
                onChanged: (b) => onChange(b),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildNotificationPreference(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BuildNotificationPreference(
                    title: productAddedLabel, initialValue: true, key: UniqueKey(),),
                Divider(),
                BuildNotificationPreference(
                    title: productSellLabel, initialValue: true, key: UniqueKey(),),
                Divider(),
                BuildNotificationPreference(
                    title: orderShippedLabel, initialValue: true, key: UniqueKey(),),
                Divider(),
                BuildNotificationPreference(
                    title: orderDeliveredLabel, initialValue: true, key: UniqueKey(),),
                Divider(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: buildButton(
                saveLabel,
                true,
                isDarkMode(context) ? primaryColorDark : primaryColor,
                isDarkMode(context)
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white,
                4.0,
                2,
                8,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
