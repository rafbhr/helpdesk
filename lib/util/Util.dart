import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import '/colors/Colors.dart';
import '/global_keys/navbar_key.dart';
import '/util/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';

bool isAnimate = false;
int currentIndex = -1;

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

void navigateToScreen(BuildContext context, Widget screenWidget) {
  Navigator.push(context, MaterialPageRoute(
    builder: (context) {
      return screenWidget;
    },
  ));
}

void navigateHomeScreen(BuildContext context) {
  Navigator.of(context).popUntil((route) => route.isFirst);
}

void navigateAndReplaceScreen(BuildContext context, String destination) {
  Navigator.of(context).pushReplacementNamed(destination);
}

void navigateAndClearHistory(BuildContext context, String destination) {

  Navigator.pushNamedAndRemoveUntil(context, destination, (r) => false);
}

void navigateToScreenFromDrawer(BuildContext context, Widget screenWidget) {
  Navigator.pop(context);
  Future.delayed(Duration(milliseconds: 300), () {
    navigateToScreen(context, screenWidget);
  });
}

class BouncyPageRoute extends PageRouteBuilder{
  final Widget widget;
 BouncyPageRoute({required this.widget})
      :super(
            transitionDuration:Duration(seconds:1),
            transitionsBuilder:(BuildContext context,
                Animation<double>animation,
                Animation<double>secAnimation,
                Widget child){
                  animation = CurvedAnimation(
                  parent:animation,curve:Curves.elasticInOut);
                  return ScaleTransition(
                    alignment:Alignment.center,
                    scale:animation,
                    child:child,  
                  );
                },
                pageBuilder:(BuildContext context,Animation<double>animation,
                    Animation<double>secAnimation){
                  return widget;
                });
}


class OpenUpwardsPageRoute extends PageRouteBuilder{
  final Widget child;
  final AxisDirection direction;

  OpenUpwardsPageRoute({
    required this.child, required this.direction})

      :super(
            transitionDuration:Duration(milliseconds:300),
            reverseTransitionDuration: Duration(milliseconds: 300),
            pageBuilder:(BuildContext context,Animation<double>animation,
                    Animation<double>secAnimation) => child);
      
  //side note refer to johan mike in YT for this one
  @override
  Widget buildTransitions(BuildContext context,Animation<double> animation, 
    Animation<double> secondaryAnimation, Widget child) => 
      SlideTransition(
        position: Tween<Offset>(
          begin: getBeginOffset(),
          end: Offset.zero,
        )
        .animate(animation),
        child: child,
      );
          
  
  Offset getBeginOffset(){
   switch(direction){
     case AxisDirection.up:
        return Offset(0,1);
     case AxisDirection.down:
        return Offset(0,-1);
     case AxisDirection.right:
        return Offset(-1,0);
     case AxisDirection.left:
        return Offset(1,0);
   }
  }
  
}

Widget displayLoadingIndicator() {
  return Center(
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(primaryColor),
      backgroundColor: Colors.transparent,
    ),
  );
}

void showInfoToast(BuildContext context, String message) {
  ToastUtils.showCustomToast(context, message, primaryColor, 3);
}

void showErrorToast(BuildContext context, String message) {
  ToastUtils.showCustomToast(context, message, Colors.red, 3);
}

void launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

CurvedNavigationBarState? getNavState(){
  if (NavbarKey.getKey().currentState != null) {
    return NavbarKey.getKey().currentState as CurvedNavigationBarState;
  } else {
    // Handle the case when currentState is null
    return null;
  }
}


List<CropAspectRatioPreset> setAspectRatios() {
  return Platform.isAndroid
      ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
      : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ];
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
