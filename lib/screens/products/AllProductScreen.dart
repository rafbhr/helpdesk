import 'package:flutter/material.dart';
import '/Data/ProductData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/model/Product.dart';
import '/model/ProductInCart.dart';
import '/screens/launch/HomeScreen.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/screens/products/ProductDetailScreen.dart';
import '/util/Util.dart';

import 'FilterProductScreen.dart';
import 'ProductNotFoundScreen.dart';

class AllProductScreen extends StatefulWidget {
  final String categoryTitle;
  final List<Product> productList;

  const AllProductScreen(
      {required Key key, required this.categoryTitle, required this.productList})
      : super(key: key);

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen>
    with TickerProviderStateMixin {
  TextEditingController searchController = new TextEditingController();
  ScrollController scrollController = new ScrollController();

  // TODO: Use actual product image (with unique image path) in order to achive Hero animation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode(context)
          ? darkBackgroundColor
          : Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor:
            isDarkMode(context) ? primaryColor.withOpacity(0.4) : primaryColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildHeaderLayout(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenHeight * 0.016,
                  vertical: SizeConfig.screenHeight * 0.016,
                ),
                child: Column(
                  children: [
                    buildProductGridView(
                      context,
                      widget.productList,
                      scrollController,
                      Axis.vertical,
                      false,
                      heroTagPrefix: tagAllProducts,
                      onCartTap: (index, isAddedInCart) {
                        addProductToCart(
                            widget.productList[index], isAddedInCart);
                      },
                      onFavoriteTap: (i) {},
                      onProductSelected: (index) {
                        navigateToScreen(
                          context,
                          ProductDetailScreen(
                            product: widget.productList[index],
                            heroTagPrefix: tagAllProducts, key: UniqueKey(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode(context) ? primaryColorDark : primaryColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenWidth(16),
                horizontal: getProportionateScreenHeight(20),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Icon(
                          Icons.keyboard_backspace,
                          color: isDarkMode(context)
                              ? Colors.white70
                              : Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      Text(
                        widget.categoryTitle,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.titleMedium?.fontFamily,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
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
                        filter,
                        isDarkMode(context),
                        onPressed: () {
                          navigateToScreen(
                            context,
                            FilterProductScreen(),
                          );
                        },
                      ),
                      SizedBox(
                        width: SizeConfig.screenHeight * 0.010,
                      ),
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
                              searchController.clear();
                              navigateToScreen(
                                context,
                                ProductNotFoundScreen(),
                              );
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
}
