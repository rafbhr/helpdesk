import 'package:flutter/material.dart';
import '/Data/NotificationData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/Util.dart';
import '/widgets/Styles.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
        notificationLabel,
        onBackPress: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notificationData.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        '$productImagesPath/${notificationData[index].image}',
                        height: 40,
                        width: 40,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: notificationData[index]
                                            .discountMessage
                                            .isEmpty
                                        ? ''
                                        : notificationData[index]
                                                .discountMessage +
                                            "  ",
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  TextSpan(
                                    text: notificationData[index].message,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              notificationData[index].time,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider()
              ],
            );
          },
        ),
      ),
    );
  }
}
