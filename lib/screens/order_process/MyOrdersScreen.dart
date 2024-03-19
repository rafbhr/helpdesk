import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/Data/ProductData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/model/Product.dart';
import '/widgets/Styles.dart';
import '/screens/products/FilterProductScreen.dart';
import '/screens/products/ProductNotFoundScreen.dart';
import '/screens/products/ProductDetailScreen.dart';
import '/screens/order_process/TrackOrderScreen.dart';
import '/util/Util.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  TextEditingController searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor:  isDarkMode(context) ? primaryColor.withOpacity(0.4) : primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeaderLayout(),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: myOngoingOrderHistory.length,
                  itemBuilder: (context, index) {
                    return buildOrderProduct(myOngoingOrderHistory[index]);
                  }),
              Text(
                noMoreOrdersLabel,
                style: Theme.of(context).textTheme.caption,
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Text(
                    ordersHistoryLabel,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
              ListView.builder(
                itemCount: myPastOrderHistory.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildOrderHistory(
                    myPastOrderHistory[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderLayout() {
    return Container(
      child: Column(
        children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode(context)
                  ? primaryColorDark
                  : primaryColor,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.keyboard_backspace,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            myOrdersLabel,
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.subtitle1?.fontSize,
                              fontFamily: Theme.of(context).textTheme.subtitle1?.fontFamily,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildIconButtonOutline(
                        '$lightIconPath/filter_icon.svg',
                        'Filter',
                        isDarkMode(context),
                        onPressed: () {
                          navigateToScreen(context, FilterProductScreen());
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: buildInputWithIcon(
                            searchController,
                            TextCapitalization.words,
                            TextInputType.text,
                            TextInputAction.done,
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
                              searchController.text = '';
                              navigateToScreen(
                                  context, ProductNotFoundScreen());
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildOrderProduct(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width / 4,
                      child: Hero(
                        tag: 'tag_ongoing_orders_${product.productImage}',
                        child: Center(
                          child: Image.asset(
                            '$productImagesPath/${product.productImage}',
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    navigateToScreen(
                      context,
                      ProductDetailScreen(
                        product: product,
                        heroTagPrefix: tagAllProducts, key: UniqueKey(),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product.productName}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Order ID: OD11054569100',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Delivered by Mon, Dec 7',
                        overflow: TextOverflow.ellipsis,
                        style: homeScreensClickableLabelStyle,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: trackOrderLabel,
                        style: homeScreensClickableLabelStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigateToScreen(context, TrackOrderScreen());
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderHistory(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 4,
                      width: MediaQuery.of(context).size.width / 4,
                      child: Hero(
                        tag: '$tagAllProducts${product.productImage}',
                        child: Center(
                          child: Image.asset(
                            '$productImagesPath/${product.productImage}',
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    navigateToScreen(
                      context,
                      ProductDetailScreen(
                        product: product,
                        heroTagPrefix: tagAllProducts, key: UniqueKey(),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${product.productName}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Order ID: OD1105d55847',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Paid \$6',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: buyAgainLabel,
                        style: homeScreensClickableLabelStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            navigateToScreen(
                              context,
                              ProductDetailScreen(
                                product: product,
                                heroTagPrefix: tagAllProducts, key: UniqueKey(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
