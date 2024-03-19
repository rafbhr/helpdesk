import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../authentication/LoginScreen.dart';
import '/colors/Colors.dart';
import '/screens/products/MyTicketScreen.dart';
import '/screens/products/MyToCheckInScreen.dart';
import '/screens/products/tabCheckIn.dart';
import '/screens/products/tabCheckOut.dart';
import '/screens/products/tabSubmitForm.dart';
//import '/screens/products/tabSubmitJobDetails.dart';
import '/util/Util.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';


class MyTicketMainScreen extends ConsumerStatefulWidget {


  @override
  _MyTicketMainScreenState createState() => _MyTicketMainScreenState();

}


class _MyTicketMainScreenState extends ConsumerState with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      final storage = new FlutterSecureStorage();

      // Clear credentials from secure storage
      await storage.delete(key: 'username');
      await storage.delete(key: 'password');

      // Close the Odoo client session
      globalClient.close();

      // Navigate to the login screen
      Navigator.pushReplacementNamed(context, '/LoginScreen');
    }


    return SafeArea(
      child: DefaultTabController(

        length: 3,
        child: Scaffold(
          backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
          appBar:  AppBar(
            backgroundColor: isDarkMode(context) ? darkGreyColor : Colors.white,
            title: Text(
              'My Tickets',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
            ),
            centerTitle: true,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.4),
            actions: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  cardColor: Colors.white, // This changes the background color of the menu
                  textTheme: TextTheme(
                    bodyText1: TextStyle(color: Colors.black), // This changes the text color
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.menu, color: Colors.black), // This makes the hamburger menu icon black
                  onSelected: (String result) {
                    if (result == 'Logout') {
                      logout();
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Logout',
                      child: Text(
                          'Logout',
                        style: TextStyle(color: Colors.black),
                          ),
                    ),
                  ],
                ),
              ),
            ],
            bottom: TabBar(
              controller: _controller,
              isScrollable: true,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // Creates border
                  color: Colors.greenAccent),
              tabs: [
                // Tab(text: 'All '),
                Tab(text: 'Check In'),
                Tab(text: 'Check Out'),
                Tab(text: 'Submit Job Details'),
                // Tab(text: 'Submit Form'),
              ],
            ),
          ),



          body: TabBarView(
              controller: _controller,
              children: [
                // MyTicketScreen(),
                CheckInTab(key: UniqueKey()),
                CheckOutTab(key: UniqueKey(),),
                SubmitFormTab(),
                // Add another widget here for the fifth tab
                // Icon(Icons.flight, size: 350), // This is just an example. Replace it with the actual widget you want to display for the fifth tab.
              ]
          ),


        ),         
      ),  
    );   
  }
}
