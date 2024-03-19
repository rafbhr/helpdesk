import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/model/Product.dart';
import '/util/size_config.dart';

import 'Styles.dart';

Widget buildSingleProduct({
  required BuildContext context,
  required Product product,
  required bool isDarkMode,
  required String heroTagPrefix,
  onCartTap,
  required Function onProductSelected,
}) {
  return Card(
    elevation: 2,
    shape:  RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    color: isDarkMode ? darkGreyColor : Colors.white,
    shadowColor: isDarkMode ? Colors.blueGrey : Colors.white.withOpacity(0.2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //info: product image
// TODO: Use actual product image (with unique image path) in order to achive Hero animation
        Expanded(
          child: InkWell(
            child: Hero(
              tag: '$heroTagPrefix${product.productImage}',
              child: Padding(
                padding: EdgeInsets.all(getProportionateScreenWidth(6)),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      '$productImagesPath/${product.productImage}',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              onProductSelected();
            },
          ),
        ),

        //info: product title
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
          ),
          child: InkWell(
            child: Text(
              '${product.productName}',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.9)
                    : Colors.black.withOpacity(0.9),
                fontSize: Theme.of(context).textTheme.subtitle2?.fontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
            onTap: () {
              onProductSelected();
            },
          ),
        ),

        //info: rating bar
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: buildReadOnlyRatingBar(
              product.rating,
              SizeConfig.screenHeight * 0.018,
              isDarkMode ? Colors.yellow[800]! : Colors.amberAccent),
        ),

        //info: price and cart
        Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$' +
                        (product.originalPrice -
                                (product.originalPrice *
                                    product.discountPercent /
                                    100))
                            .toStringAsFixed(2),
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white70
                          : Colors.black.withOpacity(0.7),
                      fontSize: Theme.of(context).textTheme.bodyText1?.fontSize,
                      fontWeight:
                          Theme.of(context).textTheme.subtitle2?.fontWeight,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$' + product.originalPrice.toStringAsFixed(2),
                        style: TextStyle(
                            fontFamily: poppinsFont,
                            fontSize:
                                Theme.of(context).textTheme.caption?.fontSize,
                            color: Theme.of(context).textTheme.caption?.color,
                            decoration: TextDecoration.lineThrough),
                      ),
                      SizedBox(width: SizeConfig.screenWidth * 0.01),
                      Text(
                        '${product.discountPercent.round()}% off',
                        style: homeScreensClickableLabelStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.screenWidth * 0.02),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? primaryColor.withOpacity(0.6) : primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      getProportionateScreenWidth(6),
                    ),
                    bottomRight: Radius.circular(
                      getProportionateScreenWidth(4),
                    ),
                  ),
                ),
                child: LikeButton(
                  size: getProportionateScreenHeight(24),
                  circleColor: CircleColor(
                      start: isDarkMode ? Colors.white70 : Colors.white,
                      end: isDarkMode ? Colors.white70 : Colors.white),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: isDarkMode ? Colors.white70 : Colors.white,
                    dotSecondaryColor:
                        isDarkMode ? Colors.white70 : Colors.white,
                  ),
                  isLiked: product.isAddedInCart,
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked
                          ? Icons.shopping_cart_sharp
                          : Icons.shopping_cart_outlined,
                      color: isDarkMode ? Colors.white70 : Colors.white,
                    );
                  },
                  onTap: (isLiked) async {
                    Future.delayed(Duration(milliseconds: 100), () {
                      onCartTap(!isLiked);
                    });
                    return !isLiked;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
