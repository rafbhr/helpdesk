import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final pageController = PageController(initialPage: 0);

  int currentSplashScreen = 0;
  var splashScreenImages = [
    'easy_checkout.svg',
    'fast_delivery.svg',
    'sale.svg',
    'secure_payment.svg',
  ];

  var splashScreenTitles = [
    'Easy Checkout',
    'Fast Delivery',
    'Sale',
    'Secure Payment'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: splashScreenImages.length,
            itemBuilder: (context, int currentPage) {
              currentSplashScreen = currentPage;
              return buildIntroSlides(currentPage);
            },
          ),
        ),
      ),
    );
  }

  Widget buildIntroSlides(int currentPage) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isDarkMode(context)
                ? '$darkIconPath/${splashScreenImages[currentPage]}'
                : '$lightIconPath/${splashScreenImages[currentPage]}',
            height: getProportionateScreenWidth(180),
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.only(top: getProportionateScreenWidth(16)),
            child: buildMiddlePart(currentPage),
          ),
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(24)),
            child: buildNextButtons(currentPage),
          )
        ],
      ),
    );
  }

  Widget buildMiddlePart(int currentPage) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            splashScreenTitles[currentPage],
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: getProportionateScreenWidth(16),
          ),
          Text(loremIpsum,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget buildNextButtons(int currentPage) {
    return Stack(
      children: [
        Container(
          child: Column(
            children: [
              buildButtonWithLongShadow(
                  currentPage + 1 == (splashScreenImages.length)
                      ? continueLabel
                      : nextLabel,
                  true,
                  isDarkMode(context) ? primaryColorDark : primaryColor,
                  isDarkMode(context)
                      ? Colors.white.withOpacity(0.8)
                      : Colors.white,
                  8,
                  8,
                  8, onPressed: () {
                if (currentSplashScreen + 1 < splashScreenImages.length)
                  pageController.nextPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                else
                  navigateAndClearHistory(context, '/LoginScreen');
              }),
              SizedBox(
                height: getProportionateScreenWidth(8),
              ),
              InkWell(
                child: Container(
                  height: getProportionateScreenWidth(50),
                  width: SizeConfig.screenHeight / 2,
                  child: Center(
                    child: Text(
                      skipLabel,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                onTap: () {
                  navigateAndClearHistory(context, '/LoginScreen');
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
