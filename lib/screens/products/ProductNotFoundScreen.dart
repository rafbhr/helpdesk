import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/Util.dart';
import '/widgets/Styles.dart';

class ProductNotFoundScreen extends StatefulWidget {
  @override
  _ProductNotFoundScreenState createState() => _ProductNotFoundScreenState();
}

class _ProductNotFoundScreenState extends State<ProductNotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    isDarkMode(context)
                        ? '$darkIconPath/page_not_found.svg'
                        :'$lightIconPath/page_not_found.svg',
                    height: 150,
                    width: double.infinity,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    child: buildMiddlePart(),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: buildBottomButtons(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMiddlePart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              apologyTitle,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 10,
            ),
            Text(productNotAvailable,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget buildBottomButtons() {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              buildButton(
                searchAgain,
                true,
                isDarkMode(context) ? primaryColorDark : primaryColor,
                isDarkMode(context)
                    ? Colors.white.withOpacity(0.8)
                    : Colors.white,
                2,
                2,
                8,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: buildButtonOutline(
                  continueShoppingLabel,
                  primaryColor,
                  primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
