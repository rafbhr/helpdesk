import 'package:flutter/material.dart';
import '/Data/ProductData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/model/Product.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/screens/order_process/DeliveryAddressScreen.dart';
import '/util/Util.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context) ? darkBackgroundColor : Theme.of(context).backgroundColor,
      // appBar: buildAppBar(context, checkoutLabel, onBackPress: () {
      //   Navigator.pop(context);
      // }),
      body: SafeArea(
        child: ListView.builder(
          itemCount: myCartData.length + 1,
          itemBuilder: (context, index) {
            return index > myCartData.length - 1
                ? buildDetails()
                : buildCartProduct(myCartData[index].product);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(top: 16.0, left: 22, right: 22, bottom: 25.0),
        child: new Container(
          height: 56.0,
          alignment: Alignment.center,
          child: buildBuyButton(),
        ),
      ),
    );
  }

  Widget buildCartProduct(Product product) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenWidth(6),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: getProportionateScreenWidth(80),
                width: getProportionateScreenWidth(80),
                child: Image.asset(
                  '$productImagesPath/${product.productImage}',
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth / 2,
                        child: Text(
                          product.productName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '\$' +
                                (product.originalPrice -
                                        (product.originalPrice *
                                            product.discountPercent /
                                            100))
                                    .toStringAsFixed(2),
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '\$' + product.originalPrice.toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(
                              decoration:
                              TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${product.discountPercent.round()}% off',
                            style: homeScreensClickableLabelStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            buildListRow('Price Details', '\$16', true, false),
            Divider(),
            buildListRow('Price (3 Item)', '\$16', false, false),
            buildListRow('Discount', '-\$1', false, true),
            buildListRow('Delivery Charges', '\$5', false, false),
            Divider(),
            buildTotalRow('Total Amount', '\$20'),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListRow(
      String title, String data, bool isHeader, bool isTextHighlighted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isHeader ? 16 : 13,
              fontFamily: poppinsFont,
              color: isDarkMode(context)
                  ? Colors.white70
                  : Colors.black.withOpacity(0.6),
            ),
          ),
          Text(
            data,
            style: TextStyle(
              fontSize: isHeader ? 16 : 13,
              fontFamily: poppinsFont,
              color: isTextHighlighted
                  ? primaryColor
                  : isDarkMode(context)
                      ? Colors.white70
                      : Colors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTotalRow(String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyText1),
          Text(data, style: Theme.of(context).textTheme.bodyText1),
        ],
      ),
    );
  }

  Widget buildBuyButton() {
    return Container(
      child: buildButtonWithSuffixIcon(
        proceedToBuyLabel,
        Icons.arrow_forward_rounded,
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          navigateToScreen(
            context,
            DeliveryAddressScreen(
              shouldDisplayPaymentButton: true, key: UniqueKey(),
            ),
          );
        },
      ),
    );
  }
}
