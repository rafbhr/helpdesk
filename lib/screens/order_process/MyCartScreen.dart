import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/Data/ProductData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/model/ProductInCart.dart';
import '/screens/launch/HomeScreen.dart';
import '/util/RemoveGlowEffect.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/screens/order_process/CheckoutScreen.dart';
import '/util/Util.dart';

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: buildAppBar(
      //   context,
      //   myCart,
      //   onBackPress: () {
      //  Navigator.pop(context);
      //   },
      // ),
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: RemoveScrollingGlowEffect(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: getProportionateScreenWidth(10.0),
                ),
                myCartData.length > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: myCartData.length,
                        itemBuilder: (context, index) {
                          return buildCartProduct(myCartData[index]);
                        })
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                getProportionateScreenWidth(16.0)),
                            child: SvgPicture.asset(
                              isDarkMode(context)
                                  ? '$darkIconPath/empty_cart.svg'
                                  : '$lightIconPath/empty_cart.svg',
                              height: SizeConfig.screenHeight * 0.5,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            noProductLabel,
                            style: Theme.of(context).textTheme.headline6,
                          )
                        ],
                      ),
                SizedBox(height: getProportionateScreenWidth(8)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: myCartData.length > 0 ? buildCheckoutButton() : null,
    );
  }

  Widget buildCartProduct(ProductInCart productInCart) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenWidth(4),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(8),
              vertical: getProportionateScreenWidth(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    '$productImagesPath/${productInCart.product.productImage}',
                    height: getProportionateScreenWidth(80),
                    width: getProportionateScreenWidth(80),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10)),
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
                              productInCart.product.productName,
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
                                    (productInCart.product.originalPrice -
                                            (productInCart
                                                    .product.originalPrice *
                                                productInCart
                                                    .product.discountPercent /
                                                100))
                                        .toStringAsFixed(2),
                                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '\$' +
                                    productInCart.product.originalPrice
                                        .toStringAsFixed(2),
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
                                '${productInCart.product.discountPercent.round()}% off',
                                style: homeScreensClickableLabelStyle,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                child: Icon(
                                  Icons.indeterminate_check_box_outlined,
                                  color: primaryColor,
                                ),
                                onTap: () {
                                  if (productInCart.quantity > 1) {
                                    setState(
                                      () {
                                        productInCart.quantity--;
                                      },
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${productInCart.quantity}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                child: Icon(
                                  Icons.add_box_outlined,
                                  color: primaryColor,
                                ),
                                onTap: () {
                                  setState(
                                    () {
                                      productInCart.quantity++;
                                    },
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Icons.delete,
                    size: 18,
                    color: primaryColor,
                  ),
                ),
                onTap: () {
                  buildConfirmationDialog(
                    context,
                    removeProductLabel,
                    confirmRemoveProductLabel,
                    onOkPress: () {
                      Navigator.of(context).pop();
                      Future.delayed(
                        Duration(milliseconds: 200),
                        () {
                          setState(
                            () {
                              productInCart.product.isAddedInCart = false;
                              myCartData.remove(productInCart);
                              HomeScreen.cartItemCount = myCartData.length;
                            },
                          );
                        },
                      );
                    },
                    onCancelPress: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckoutButton() {
    return Container(
      height: SizeConfig.screenHeight * 0.150,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 22.0),
      alignment: Alignment.bottomCenter,
      child: buildButtonWithSuffixIcon(
        proceedToCheckoutLabel,
        Icons.arrow_forward_rounded,
        true,
        isDarkMode(context) ? primaryColorDark : primaryColor,
        isDarkMode(context) ? Colors.white.withOpacity(0.8) : Colors.white,
        2,
        2,
        8,
        onPressed: () {
          navigateToScreen(context, CheckoutScreen());
        },
      ),
    );
  }
}
