import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import '/Data/CategoryData.dart';
import '/Data/NotificationData.dart';
import '/Data/ProductData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/global_keys/navbar_key.dart';
import '/model/Product.dart';
import '/model/ProductInCart.dart';
import '/screens/products/MyTicketMainScreen.dart';
import '/screens/products/MyTicketScreen.dart';
import '/screens/settings/SettingsScreen.dart';
import '/util/RemoveGlowEffect.dart';
import '/util/size_config.dart';
import '/widgets/SingleProduct.dart';
import '/widgets/Styles.dart';
import '/screens/products/AllProductScreen.dart';

import '/screens/products/ProductDetailScreen.dart';

import '/util/Util.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../products/AllCategoriesScreen.dart';
import '../order_process/MyCartScreen.dart';
import '../profile/UserProfileScreen.dart';
import '../notifications/NotificationsScreen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  final OdooClient client;
  final OdooSession session;

  static int cartItemCount = myCartData.length;

  const HomeScreen({Key? key, required this.client, required this.session}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  PageController controller = PageController(
    viewportFraction: 0.9,
    initialPage: 1,
  );

  bool isBestSellerLoading = true;
  bool isBestInElectronicsLoading = true;
  bool isOtherProductsLoading = true;
  late int currentBottomBarIndex;

  late CurvedNavigationBarState navState;

  Future<bool> onWillPop() async {
    if (currentBottomBarIndex != 0)
      setState(
        () {
          navState = getNavState()!;
          navState.setPage(0);
        },
      );
    else
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');

    return Future.value(false);
  }

  //INFO: initState method

  @override
  void initState() {
    super.initState();
    currentBottomBarIndex = 0;

    //INFO: best seller animation
    Future.delayed(
      Duration(milliseconds: 2000),
      () {
        setState(
          () {
            isBestSellerLoading = false;
          },
        );
      },
    );

    //INFO: all other product loading animation
    //there is no special reason for additional delay.
    //just imitating actual loading process.
    Future.delayed(
      Duration(milliseconds: 4000),
      () {
        setState(
          () {
            isBestInElectronicsLoading = false;
            isOtherProductsLoading = false;
          },
        );
      },
    );
  }

  //INFO: build method

  @override
  Widget build(BuildContext context) {
    var navStateTemp = getNavState();
    if (navStateTemp != null) {
      navState = navStateTemp;
    } else {
      // Handle the case when getNavState() returns null
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: isDarkMode(context)
            ? darkBackgroundColor
            : Theme.of(context).backgroundColor,
        appBar: AppBar(
        leading: Container(),
          backgroundColor: isDarkMode(context)
              ? primaryColor.withOpacity(0.4)
              : primaryColor,
          elevation: 0,
          toolbarHeight: 0,
        ),
        body: selectScreenWidgetToShow(),
        // bottomNavigationBar: CurvedNavigationBar(
        //   color: isDarkMode(context) ? Colors.grey[100]! : Colors.grey[300]!,
        //   backgroundColor: isDarkMode(context)
        //       ? darkBackgroundColor
        //       : Theme.of(context).backgroundColor,
        //   height: SizeConfig.screenHeight * 0.07,
        //   buttonBackgroundColor:
        //       isDarkMode(context) ? primaryColorDark : primaryColor,
        //   animationDuration: Duration(milliseconds: 300),
        //   key: NavbarKey.getKey(),
        //   items: [
        //     Icon(
        //       Icons.home,
        //       size: getProportionateScreenWidth(30),
        //       color: currentBottomBarIndex == 0
        //           ? bottomBarIconSelectedLight
        //           : isDarkMode(context)
        //               ? bottomBarIconDark
        //               : Colors.black87,
        //     ),
        //     Icon(
        //       Icons.format_list_bulleted_sharp,
        //       size: getProportionateScreenWidth(30),
        //       color: currentBottomBarIndex == 1
        //           ? bottomBarIconSelectedLight
        //           : isDarkMode(context)
        //               ? bottomBarIconDark
        //               : Colors.black87,
        //     ),
        //     Icon(
        //       Icons.favorite_outlined,
        //       size: getProportionateScreenWidth(30),
        //       color: currentBottomBarIndex == 2
        //           ? bottomBarIconSelectedLight
        //           : isDarkMode(context)
        //               ? bottomBarIconDark
        //               : Colors.black87,
        //     ),
        //     Icon(
        //       Icons.settings,
        //       size: getProportionateScreenWidth(30),
        //       color: currentBottomBarIndex == 3
        //           ? bottomBarIconSelectedLight
        //           : isDarkMode(context)
        //               ? bottomBarIconDark
        //               : Colors.black87,
        //     ),
        //     Icon(
        //       Icons.account_circle_rounded,
        //       size: getProportionateScreenWidth(30),
        //       color: currentBottomBarIndex == 4
        //           ? bottomBarIconSelectedLight
        //           : isDarkMode(context)
        //               ? bottomBarIconDark
        //               : Colors.black87,
        //     ),
        //   ],
        //   onTap: (index) {
        //     setState(
        //       () {
        //         currentBottomBarIndex = index;
        //       },
        //     );
        //   },
        // ),
      ),
    );
  }

  // Widget selectScreenWidgetToShow() {
  //   switch (currentBottomBarIndex) {
  //     case 0:
  //       return buildHomeScreen();
  //       break;
  //     case 1:
  //       return AllCategoriesScreen();
  //       break;
  //     case 2:
  //       return MyTicketMainScreen();
  //       break;
  //     case 3:
  //       return SettingsScreen(
  //         isFromBottomNav: true, key: UniqueKey(),
  //       );
  //       break;
  //     case 4:
  //       return UserProfileScreen();
  //       break;
  //   }
  //   return buildHomeScreen();
  // }

  // This is the new selectScreenWidgetToShow() method that removes the navbar
  Widget selectScreenWidgetToShow() {
    // Directly return MyTicketMainScreen()
    return MyTicketMainScreen();
  }

  //INFO: home screen
  // TODO: Use actual product image (with unique image path) to achive Hero animation

  Widget buildHomeScreen() {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: RemoveScrollingGlowEffect(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeaderLayout(),
              SizedBox(
                height: getProportionateScreenWidth(8),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.18,
                child: PageView(
                  controller: controller,
                  children: List.generate(
                    3,
                    (index) => buildBanner('$productImagesPath/demo_image_banner.png', onBannerClick: (){
                      navigateToScreen(
                        context,
                        AllProductScreen(
                          categoryTitle: 'Summer Spacial',
                          productList: mixProducts, key: UniqueKey(),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenWidth(16),
              ),
              SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    radius: 8,
                    spacing: 8,
                    activeDotColor: primaryColor),
                onDotClicked: (i) {
                  controller.jumpToPage(i);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(12),
                ),
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenWidth(6)),
                    buildCategoryGridView(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildBestSellerListView(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildBestInElectronics(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildBanner('$productImagesPath/demo_image_banner.png',onBannerClick: (){
                    navigateToScreen(
                        context,
                        AllProductScreen(
                          categoryTitle: 'Men\'s Fashion',
                          productList: shopForMen, key: UniqueKey(),
                        ),
                      );
                    }),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildNewInFashion(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildHealthyFood(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildBeautyProducts(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    lowPriceProducts(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildShopForMen(),
                    SizedBox(height: getProportionateScreenWidth(20)),
                    buildShopForWomen(),
                    SizedBox(height: getProportionateScreenWidth(35))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //INFO: Header layout (AppBar)

  Widget buildHeaderLayout() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode(context) ? primaryColorDark : primaryColor,
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenHeight * 0.022,
          vertical: SizeConfig.screenHeight * 0.03,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: SizeConfig.screenHeight * 0.055,
                child: buildInputWithIcon(
                  searchController,
                  TextCapitalization.words,
                  TextInputType.text,
                  TextInputAction.search,
                  isDarkMode(context) ? Colors.white : Colors.black,
                  10,
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                  isDarkMode(context) ? Colors.black26 : Colors.white,
                  null,
                  searchLabel,
                  iconData: Icons.search,
                  onChange: (value) {},
                  onSubmit: (v) {
                    navigateToScreen(
                      context,
                      AllProductScreen(
                        categoryTitle: searchController.text.isNotEmpty
                            ? searchController.text
                            : 'Search Result',
                        productList: mixProducts, key: UniqueKey(),
                      ),
                    );
                    searchController.clear();
                  },
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            buildHeaderIcons(
              Icons.notifications_none_outlined,
              notificationData.length,
              isDarkMode(context),
              onTap: () {
                navigateToScreen(
                  context,
                  NotificationsScreen(),
                );
              },
            ),
            SizedBox(
              width: getProportionateScreenWidth(16),
            ),
            buildHeaderIcons(
              Icons.shopping_cart_outlined,
              HomeScreen.cartItemCount,
              isDarkMode(context),
              onTap: () {
                navigateToScreen(context, MyCartScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  //INFO: Categories

  Widget buildCategoryGridView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryLabel,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Container(
              child: InkWell(
                child: Text(
                  viewAllLabel,
                  style: homeScreensClickableLabelStyle,
                ),
                onTap: () {
                  setState(
                    () {
                      navState = getNavState()!;
                      navState.setPage(1);
                    },
                  );
                },
              ),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(8)),
        Container(
          height: getProportionateScreenWidth(90),
          width: double.infinity,
          child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 1,
            mainAxisSpacing: 6,
            shrinkWrap: true,
            controller: scrollController,
            children: List.generate(
              categoryImages.length,
              (index) {
                return Center(
                  child: Card(
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              isDarkMode(context)
                                  ? '$darkIconPath/${categoryImages[index]}'
                                  : '$lightIconPath/${categoryImages[index]}',
                              width: getProportionateScreenWidth(35),
                              height: getProportionateScreenWidth(35),
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      highlightColor: primaryColor.withOpacity(0.6),
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
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  //INFO: best seller
  Widget buildBestSellerListView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bestSellerLabel,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            InkWell(
              child: Text(
                viewAllLabel,
                style: homeScreensClickableLabelStyle,
              ),
              onTap: () => navigateToScreen(
                context,
                AllProductScreen(
                  categoryTitle: bestSellerLabel,
                  productList: mixProducts, key: UniqueKey(),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(8)),
        buildProductGridView(
          context,
          mixProducts,
          // bestSellerLabel,
          scrollController,
          Axis.horizontal,
          isBestSellerLoading,
          heroTagPrefix: tagBestSeller,
          onCartTap: (i, b) => addProductToCart(mixProducts[i], b),
          onFavoriteTap: (i) {},
          onProductSelected: (i) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: mixProducts[i],
                  heroTagPrefix: tagBestSeller, key: UniqueKey(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  //INFO: best in electronics

  Widget buildBestInElectronics() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              bestInElectronics,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            InkWell(
              child: Text(
                viewAllLabel,
                style: homeScreensClickableLabelStyle,
              ),
              onTap: () => navigateToScreen(
                context,
                AllProductScreen(
                  categoryTitle: bestInElectronics,
                  productList: bestInElectronicsData, key: UniqueKey(),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(8)),
        buildProductGridView(
          context,
          bestInElectronicsData,

          scrollController,
          Axis.horizontal,
          isBestInElectronicsLoading,
          heroTagPrefix: tagBestInElectronics,
          onCartTap: (i, b) => addProductToCart(bestInElectronicsData[i], b),
          onFavoriteTap: (i) {
            setState(() {});
          },
          onProductSelected: (i) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: bestInElectronicsData[i],
                  heroTagPrefix: tagBestInElectronics, key: UniqueKey(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  //INFO: banner

  Widget buildBanner(String imagePath, {required Function onBannerClick}) {
    return InkWell(
      child: Container(
        height: SizeConfig.screenHeight * 0.18,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(6)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () => onBannerClick(),
    );
  }

  //INFO: new in fashion

  Widget buildNewInFashion() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            newInFashionLabel,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            height: getProportionateScreenWidth(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: SizeConfig.screenWidth * 0.46,
                    height: SizeConfig.screenWidth * 0.46,
                    child: isOtherProductsLoading
                        ? shimmerLoading(context)
                        : buildSingleProduct(
                            context: context,
                            product: newInFashion[0],
                            isDarkMode: isDarkMode(context),
                            heroTagPrefix: tagNewInFashion,
                            onCartTap: (b) {
                              addProductToCart(newInFashion[0], b);
                            },
                            onProductSelected: () => showProductDetails(
                              newInFashion[0],
                              tagNewInFashion,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenWidth * 0.02,
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.46,
                    height: SizeConfig.screenWidth * 0.46,
                    child: isOtherProductsLoading
                        ? shimmerLoading(context)
                        : buildSingleProduct(
                            context: context,
                            product: newInFashion[1],
                            isDarkMode: isDarkMode(context),
                            heroTagPrefix: tagNewInFashion,
                            onCartTap: (b) =>
                                addProductToCart(newInFashion[1], b),
                            onProductSelected: () => showProductDetails(
                              newInFashion[1],
                              tagNewInFashion,
                            ),
                          ),
                  ),
                ],
              ),
              Container(
                width: SizeConfig.screenWidth * 0.46,
                height: SizeConfig.screenWidth * 0.94,
                child: isOtherProductsLoading
                    ? shimmerLoading(context)
                    : buildSingleProduct(
                        context: context,
                        product: newInFashion[2],
                        isDarkMode: isDarkMode(context),
                        heroTagPrefix: tagNewInFashion,
                        onCartTap: (b) => addProductToCart(
                          newInFashion[2],
                          b,
                        ),
                        onProductSelected: () => showProductDetails(
                          newInFashion[2],
                          tagNewInFashion,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //INFO: stay healthy

  Widget buildHealthyFood() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stayHealthyLabel,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            InkWell(
              child: Text(
                viewAllLabel,
                style: homeScreensClickableLabelStyle,
              ),
              onTap: () => navigateToScreen(
                context,
                AllProductScreen(
                  categoryTitle: stayHealthyLabel,
                  productList: stayHealthyData, key: UniqueKey(),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(8)),
        buildProductGridView(
          context,
          stayHealthyData,
          scrollController,
          Axis.vertical,
          isBestInElectronicsLoading,
          heroTagPrefix: tagStayHealthy,
          onCartTap: (index, bool) =>
              addProductToCart(stayHealthyData[index], bool),
          onFavoriteTap: (i) {
            setState(() {});
          },
          onProductSelected: (i) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  product: stayHealthyData[i],
                  heroTagPrefix: '$tagStayHealthy', key: UniqueKey(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  //INFO: beauty products

  Widget buildBeautyProducts() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              makeupProducts,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            InkWell(
              child: Text(
                viewAllLabel,
                style: homeScreensClickableLabelStyle,
              ),
              onTap: () => navigateToScreen(
                context,
                AllProductScreen(
                  categoryTitle: makeupProducts,
                  productList: makupProductsData, key: UniqueKey(),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(8)),
        buildProductGridView(
          context,
          makupProductsData,

          scrollController,
          Axis.horizontal,
          isBestInElectronicsLoading,
          heroTagPrefix: tagBeautyProducts,
          onCartTap: (i, b) => addProductToCart(
            makupProductsData[2],
            b,
          ),
          onFavoriteTap: (i) {
            setState(() {});
          },
          onProductSelected: (i) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                    product: makupProductsData[i],
                    heroTagPrefix: tagBeautyProducts, key: UniqueKey(),),
              ),
            );
          },
        )
      ],
    );
  }

  //INFO: low price products

  Widget lowPriceProducts() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lowPriceEver,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              InkWell(
                child: Text(
                  viewMoreLabel,
                  style: homeScreensClickableLabelStyle,
                ),
                onTap: () => navigateToScreen(
                  context,
                  AllProductScreen(
                    categoryTitle: lowPriceEver,
                    productList: lowPriceProductList, key: UniqueKey(),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenWidth(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.46,
                height: SizeConfig.screenWidth * 0.94,
                child: isOtherProductsLoading
                    ? shimmerLoading(context)
                    : buildSingleProduct(
                        context: context,
                        product: lowPriceProductList[2],
                        isDarkMode: isDarkMode(context),
                        heroTagPrefix:
                            '$tagLowPrice${newInFashion[2].productName}_3',
                        onCartTap: (b) => addProductToCart(
                          lowPriceProductList[2],
                          b,
                        ),
                        onProductSelected: () => showProductDetails(
                          lowPriceProductList[2],
                          '$tagLowPrice${newInFashion[2].productName}_3',
                        ),
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: SizeConfig.screenWidth * 0.46,
                    height: SizeConfig.screenWidth * 0.46,
                    child: isOtherProductsLoading
                        ? shimmerLoading(context)
                        : buildSingleProduct(
                            context: context,
                            product: lowPriceProductList[0],
                            isDarkMode: isDarkMode(context),
                            heroTagPrefix:
                                '$tagLowPrice${newInFashion[0].productName}_4',
                            onCartTap: (b) =>
                                addProductToCart(lowPriceProductList[0], b),
                            onProductSelected: () => showProductDetails(
                              lowPriceProductList[0],
                              '$tagLowPrice${newInFashion[0].productName}_4',
                            ),
                          ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenWidth * 0.02,
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.46,
                    height: SizeConfig.screenWidth * 0.46,
                    child: isOtherProductsLoading
                        ? shimmerLoading(context)
                        : buildSingleProduct(
                            context: context,
                            product: lowPriceProductList[1],
                            isDarkMode: isDarkMode(context),
                            heroTagPrefix:
                                '$tagLowPrice${newInFashion[1].productName}_5',
                            onCartTap: (b) =>
                                addProductToCart(lowPriceProductList[1], b),
                            onProductSelected: () => showProductDetails(
                              lowPriceProductList[1],
                              '$tagLowPrice${newInFashion[1].productName}_5',
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //INFO: shop for men

  Widget buildShopForMen() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shopForMenLabel,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              InkWell(
                child: Text(
                  viewAllLabel,
                  style: homeScreensClickableLabelStyle,
                ),
                onTap: () => navigateToScreen(
                  context,
                  AllProductScreen(
                    categoryTitle: shopForMenLabel,
                    productList: shopForMen, key: UniqueKey(),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenWidth(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.46,
                height: SizeConfig.screenWidth * 0.94,
                child: isOtherProductsLoading
                    ? shimmerLoading(context)
                    : buildSingleProduct(
                        context: context,
                        product: shopForMen[0],
                        isDarkMode: isDarkMode(context),
                        heroTagPrefix: tagShopForMen,
                        onCartTap: (b) => addProductToCart(
                          shopForMen[0],
                          b,
                        ),
                        onProductSelected: () => showProductDetails(
                          shopForMen[0],
                          tagShopForMen,
                        ),
                      ),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.46,
                height: SizeConfig.screenWidth * 0.94,
                child: isOtherProductsLoading
                    ? shimmerLoading(context)
                    : buildSingleProduct(
                        context: context,
                        product: shopForMen[1],
                        isDarkMode: isDarkMode(context),
                        heroTagPrefix:
                            '$tagShopForMen${newInFashion[1].productName}_6',
                        onCartTap: (b) => addProductToCart(
                          shopForMen[1],
                          b,
                        ),
                        onProductSelected: () => showProductDetails(
                          shopForMen[1],
                          '$tagShopForMen${newInFashion[1].productName}_6',
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //INFO: shop for women

  Widget buildShopForWomen() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shopForWomenLabel,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              InkWell(
                child: Text(
                  viewAllLabel,
                  style: homeScreensClickableLabelStyle,
                ),
                onTap: () => navigateToScreen(
                  context,
                  AllProductScreen(
                    categoryTitle: shopForWomenLabel,
                    productList: shopForWomen, key: UniqueKey(),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenWidth(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.46,
                height: SizeConfig.screenWidth * 0.94,
                child: isOtherProductsLoading
                    ? shimmerLoading(context)
                    : buildSingleProduct(
                        context: context,
                        product: shopForWomen[0],
                        isDarkMode: isDarkMode(context),
                        heroTagPrefix:
                            '$tagShopForWomen${newInFashion[0].productName}_7',
                        onCartTap: (b) => addProductToCart(
                          shopForWomen[0],
                          b,
                        ),
                        onProductSelected: () => showProductDetails(
                          shopForWomen[0],
                          '$tagShopForWomen${newInFashion[0].productName}_7',
                        ),
                      ),
              ),
              Container(
                width: SizeConfig.screenWidth * 0.46,
                height: SizeConfig.screenWidth * 0.94,
                child: isOtherProductsLoading
                    ? shimmerLoading(context)
                    : buildSingleProduct(
                        context: context,
                        product: shopForWomen[1],
                        isDarkMode: isDarkMode(context),
                        heroTagPrefix:
                            '$tagShopForWomen${newInFashion[1].productName}_8',
                        onCartTap: (b) => addProductToCart(
                          shopForWomen[1],
                          b,
                        ),
                        onProductSelected: () => showProductDetails(
                          shopForWomen[1],
                          '$tagShopForWomen${newInFashion[1].productName}_8',
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addProductToCart(Product product, bool isAddedInCart) {
    product.isAddedInCart = isAddedInCart;
    setState(
      () {
        if (isAddedInCart) {
          myCartData.add(
            ProductInCart(
              product,
              1,
            ),
          );
        } else {
          myCartData.removeWhere((element) => element.product == product);
        }
        HomeScreen.cartItemCount = myCartData.length;
      },
    );
  }

  void showProductDetails(Product product, String heroTagPrefix) {
    navigateToScreen(
      context,
      ProductDetailScreen(
        product: product,
        heroTagPrefix: heroTagPrefix, key: UniqueKey(),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
