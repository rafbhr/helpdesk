import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/screens/settings/SettingsScreen.dart';
import '/util/RemoveGlowEffect.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';

import '../authentication/LoginScreen.dart';
import 'AccountInfoScreen.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();

  static String routeName = '/profile';
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late PackageInfo packageInfo;
  late File imageFile;

  final ImagePicker imagePicker = ImagePicker();

  getPackageName() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  void initState() {
    super.initState();
    getPackageName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      appBar: AppBar(

        backgroundColor: secondaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: RemoveScrollingGlowEffect(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHeaderLayout(),
                SizedBox(
                  height: getProportionateScreenWidth(6),
                ),
                buildAccountInfo(context),
                SizedBox(
                  height: getProportionateScreenWidth(35),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeaderLayout() {
    return Container(
      height: SizeConfig.screenHeight / 4,
      color: isDarkMode(context) ? primaryColorDark : primaryColor,
      child: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(16),
                  vertical: getProportionateScreenWidth(8),
                ),
                child: InkWell(
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: Colors.white,
                  ),
                  onTap: () {
                    final CurvedNavigationBarState? navState = getNavState();
                    navState?.setPage(0);
                  },
                ),
              ),
            ),
            InkWell(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Padding(
                      padding: EdgeInsets.all(1.5),
                      child: ClipOval(
                        child: imageFile == null
                            ? Image.asset(
                                '$baseImagePath/avatar.png',
                                height: SizeConfig.screenHeight * 0.1,
                                width: SizeConfig.screenHeight * 0.1,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                imageFile,
                                height: SizeConfig.screenHeight * 0.1,
                                width: SizeConfig.screenHeight * 0.1,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 0,
                    child: Container(
                      width: SizeConfig.screenHeight * 0.028,
                      height: SizeConfig.screenHeight * 0.028,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              SizeConfig.screenHeight * 0.014)),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: primaryColor,
                          size: SizeConfig.screenHeight * 0.018,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () => showImagePickerDialog(context),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.014,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  demoUserFullName,
                  style: TextStyle(
                    fontFamily: poppinsFont,
                    fontSize: SizeConfig.screenHeight * 0.021,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.004,
                ),
                Text(
                  demoEmail,
                  style: TextStyle(
                    fontSize: SizeConfig.screenHeight * 0.016,
                    fontFamily: poppinsFont,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildAccountInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenWidth(8),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context)
            ? darkGreyColor
            : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: getProportionateScreenWidth(8),
            bottom: getProportionateScreenWidth(8),
          ),
          child: Column(
            children: [
              buildListRow(
                accountInfoLabel,
                onTap: () {
                  navigateToScreen(
                    context,
                    AccountInfoScreen(),
                  );
                },
              ),
              Divider(),
              buildListRow(
                couponsLabel,
                onTap: () {
                  showInfoToast(context, 'Show user coupons');
                },
              ),
              Divider(),
              buildListRow(
                settings,
                onTap: () {
                  navigateToScreen(
                    context,
                    SettingsScreen(isFromBottomNav: false, key: UniqueKey(),),
                  );
                },
              ),
              Divider(),
              buildListRow(
                shareApp,
                onTap: () {
                  String shareText = 'Hello!, I found this awesome Online Store App!'
                          '\njust download this cool app and enjoy cool product for daily life: \n\n' +
                      'Android: https://play.google.com/store/apps/details?id=${packageInfo.packageName} \n\n' +
                      'iOS: https://apps.apple.com/<YOUR APP URL IN APP STORE>';
                  Share.share(shareText);
                },
              ),
              Divider(),
              buildListRow(
                helpLabel,
                onTap: () {
                  showInfoToast(context, 'Open Help center');
                },
              ),
              Divider(),
              buildListRow(
                logoutLabel,
                onTap: () {
                  buildConfirmationDialog(
                    context,
                    'Confirm Logout?',
                    'Are you sure you want to logout?',
                    onOkPress: () {
                      Navigator.of(context).pop();
                      globalClient.destroySession(); //destroy our global session here.
                      
                      Future.delayed(Duration(milliseconds: 200), () {
                        navigateAndClearHistory(context, '/LoginScreen');
                      });
                    },
                    onCancelPress: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListRow(String title, {required Function onTap}) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(16),
          vertical: getProportionateScreenWidth(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
      onTap: () {
        onTap();
      },
    );
  }

  Future showImagePickerDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(imageDialogTitle),
        content: Text(imageDialogDesc),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pickImageFromCamera(context);
            },
            child: Text(
              camera,
              style: TextStyle(
                fontSize: 14,
                fontFamily: poppinsFont,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await pickImageFromGallery(context);
            },
            child: Text(
              gallery,
              style: TextStyle(
                fontSize: 14,
                fontFamily: poppinsFont,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future pickImageFromCamera(BuildContext context) async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 50,
      );

      if(pickedFile!= null)
        cropImage(context, pickedFile?.path ?? "");

    } catch (e) {
      // PlatformException exemption = e;

      showErrorToast(context, 'Error Pick file!');
    }
  }

  Future pickImageFromGallery(BuildContext context) async {
    try {
      final pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 50,
      );

      if(pickedFile!= null)
        cropImage(context, pickedFile?.path     ?? "");

    } catch (e) {


      showErrorToast(context, 'Error Pick file');
    }
  }

  Future cropImage(BuildContext context, String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: setAspectRatios(),
        uiSettings: [        
          AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop your image',
        )],
      );
    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path ?? "");
      });
    }
  }
}
