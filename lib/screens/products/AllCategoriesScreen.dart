import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/Data/CategoryData.dart';
import '/Data/ProductData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';

import 'AllProductScreen.dart';

class AllCategoriesScreen extends StatefulWidget {
  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
  static String routeName = '/all_categories';
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(
      //   context,
      //   allCategories,
      //   onBackPress: () {
      //     final CurvedNavigationBarState navState = getNavState();
      //     navState.setPage(0);
      //   },
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(
              getProportionateScreenWidth(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  shrinkWrap: true,
                  controller: scrollController,
                  children: List.generate(
                    categoryImages.length,
                    (index) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        color: isDarkMode(context)
                            ? darkGreyColor
                            : primaryColor.withOpacity(0.08),
                        shadowColor: Colors.grey.withOpacity(0.20),
                        child: InkWell(
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  isDarkMode(context)
                                      ? '$darkIconPath/${categoryImages[index]}'
                                      : '$lightIconPath/${categoryImages[index]}',
                                  width: getProportionateScreenWidth(45),
                                  height: getProportionateScreenWidth(45),
                                ),
                                Text(
                                  '${categoryTitles[index]}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .caption
                                              ?.fontSize),
                                )
                              ],
                            ),
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                          onTap: () {
                            navigateToScreen(
                              context,
                              AllProductScreen(
                                categoryTitle: '${categoryTitles[index]}',
                                productList: getCategoryProducts(index), key: UniqueKey(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
