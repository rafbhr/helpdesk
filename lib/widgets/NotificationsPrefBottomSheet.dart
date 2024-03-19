import 'package:flutter/material.dart';
import '/colors/Colors.dart';
import '/util/Util.dart';
import '/util/size_config.dart';

class BuildNotificationPreference extends StatefulWidget {
  final bool initialValue;
  final String title;

  const BuildNotificationPreference(
      {required Key key, required this.initialValue, required this.title})
      : super(key: key);
  @override
  _BuildNotificationPreferenceState createState() =>
      _BuildNotificationPreferenceState(title, initialValue);
}

class _BuildNotificationPreferenceState
    extends State<BuildNotificationPreference> {
  bool initialValue;
  String title;

  _BuildNotificationPreferenceState(this.title, this.initialValue);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:EdgeInsets.symmetric(vertical: getProportionateScreenHeight(6)),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(getProportionateScreenHeight(2)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: initialValue
                        ? isDarkMode(context) ? primaryColorDark :  primaryColor
                        : Colors.transparent,
                    border: Border.all(
                      color: isDarkMode(context) ? primaryColorDark :  primaryColor,
                      width: 2.0,
                    ),

                  ),
                  child: initialValue
                      ? Icon(
                          Icons.check,
                          size:getProportionateScreenHeight(10),
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.check_box_outline_blank,
                    size:getProportionateScreenHeight(10),
                          color: Colors.transparent,
                        ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                initialValue = !initialValue;
              });
            },
          ),
        ),
      ],
    );
  }
}
