import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '/Data/ProductData.dart';
import '/Data/ReviewData.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/model/Product.dart';
import '/screens/launch/HomeScreen.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/util/Util.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'AllProductScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final String heroTagPrefix;

  const ProductDetailScreen({required Key key, required this.product, required this.heroTagPrefix})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  PageController controller = PageController();
  double rowLineHeight = 8.0;

  bool isFullScreenImageDisplaying = false;
  late PackageInfo packageInfo;
  bool enableScrollPhysics = true;
  ScrollController scrollController = new ScrollController();
  String addToCartLabel = 'Add to Cart';

  getPackageName() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<bool> onWillPop() async {
    setState(
      () {
        if (isFullScreenImageDisplaying)
          isFullScreenImageDisplaying = false;
        else
          Navigator.pop(context);
      },
    );
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    getPackageName();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: isDarkMode(context)
            ? darkBackgroundColor
            : Theme.of(context).backgroundColor,
        appBar: !isFullScreenImageDisplaying
            ? AppBar(
                backgroundColor: isDarkMode(context) ? mattColor : Colors.white,
                title: Text(
                  productDetailLabel,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                leading: InkWell(
                  child: Icon(
                    Icons.keyboard_backspace,
                    color: isDarkMode(context)
                        ? Colors.white70
                        : Colors.black.withOpacity(0.8),
                  ),
                  onTap: () {
                    setState(
                      () {
                        if (isFullScreenImageDisplaying)
                          isFullScreenImageDisplaying = false;
                        else
                          Navigator.pop(context);
                      },
                    );
                  },
                ),
                centerTitle: true,
                elevation: 3,
                shadowColor: Colors.black.withOpacity(0.4),
              )
            : AppBar(
                toolbarHeight: 0,
              ),
        body: SafeArea(
          child: !isFullScreenImageDisplaying
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      buildProductCard(),
                      buildDetailScreen(),
                      buildRatingAndComment(),
                      buildSimilarProducts(),
                    ],
                  ),
                )
              : buildProductFullScreenView(
                  heroTagPrefix: widget.heroTagPrefix,
                  image: widget.product.productImage,
                  productTitle: widget.product.productName),
        ),
        bottomNavigationBar: !isFullScreenImageDisplaying
            ? buildAddToCartButtons()
            : Container(
                height: 0,
              ),
      ),
      onWillPop: onWillPop,
    );
  }

  Widget buildProductCard() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenWidth(8),
      ),
      child: Column(
        children: [
          Card(
            elevation: 6,
            color: isDarkMode(context) ? darkGreyColor : Colors.white,
            shadowColor: Colors.grey.withOpacity(0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: PageView.builder(
                      controller: controller,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          child: InkWell(
                            // TODO: Use actual product image (with unique image path) to achive Hero animation
                            child: Hero(
                              tag: widget.heroTagPrefix != null
                                  ? '${widget.heroTagPrefix}${widget.product.productImage}'
                                  : '',
                              child: Image.asset(
                                widget.product != null
                                    ? '$productImagesPath/${widget.product.productImage}'
                                    : '$productImagesPath/demo_image.png',
                                height: MediaQuery.of(context).size.height / 5,
                              ),
                            ),
                            onTap: () {
                              setState(
                                () {
                                  isFullScreenImageDisplaying = true;
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SmoothPageIndicator(
                    controller: controller,
                    count: 6,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      radius: 8,
                      spacing: 8,
                      activeDotColor: primaryColor,
                    ),
                    onDotClicked: (i) {
                      controller.jumpToPage(i);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.product != null
                          ? widget.product.productName
                          : 'iPhone 11 Pro Max',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.product != null
                                        ? "${widget.product.rating}"
                                        : "4.4 ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        '96 ratings',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        highlightColor: primaryColor.withOpacity(0.1),
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.share,
                            size: 16,
                            color: primaryColor,
                          ),
                        ),
                        onTap: () {
                          String shareProductText =
                              'Hello!, I found this awesome Online Store App!'
                                      '\njust download this cool app and enjoy cool product for daily life: \n\n' +
                                  'Android: https://play.google.com/store/apps/details?id=${packageInfo.packageName} \n\n' +
                                  'iOS: https://apps.apple.com/<YOUR APP URL IN APP STORE>';

                          Share.share(shareProductText);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '\$6',
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.fontWeight),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '\$11',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '5% off',
                        style: homeScreensClickableLabelStyle,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailScreen() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(14),
        vertical: getProportionateScreenWidth(8),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(8),
                  left: getProportionateScreenWidth(12)),
              child: Text(
                detailsLabel,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Divider(),
            GridView.count(
              crossAxisCount: 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 9,
              padding: EdgeInsets.all(getProportionateScreenWidth(12)),
              children: productDetails
                  .map(
                    (e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            e['key']!,
                            style: Theme.of(context).textTheme.bodyText2,
                            softWrap: true,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: e['key'] != colorLabel
                              ? Text(
                                  e['value']!,
                                  style: Theme.of(context).textTheme.subtitle2,
                                )
                              : Row(
                                  children: [
                                    Text(
                                      e['value']!,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    SizedBox(
                                      width: rowLineHeight,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Container(
                                        width: getProportionateScreenWidth(10),
                                        height: getProportionateScreenWidth(10),
                                        decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.015,
            )
          ],
        ),
      ),
    );
  }

  Widget buildRatingAndComment() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenWidth(8),
      ),
      child: Card(
        elevation: 6,
        color: isDarkMode(context) ? darkGreyColor : Colors.white,
        shadowColor: Colors.grey.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenWidth(8),
                  left: getProportionateScreenWidth(10)),
              child: Text(
                'Ratings and reviews',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Divider(),
            buildRating(5, 0.8, isDarkMode(context)),
            buildRating(4, 0.42, isDarkMode(context)),
            buildRating(3, 0.2, isDarkMode(context)),
            buildRating(2, 0.1, isDarkMode(context)),
            buildRating(1, 0.05, isDarkMode(context)),
            SizedBox(
              height: getProportionateScreenWidth(16),
            ),
            Column(
              children: [
                Column(
                  children: List.generate(
                    reviewData.length > 4 ? 4 : reviewData.length,
                    (index) => buildReviewComments(
                      context,
                      reviewData[index],
                    ),
                  ),
                ),
                Visibility(
                  visible: reviewData.length > 4,
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: getProportionateScreenWidth(12),
                          right: getProportionateScreenWidth(12)),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'See more',
                          style: homeScreensClickableLabelStyle,
                        ),
                      ),
                    ),
                    onTap: () => showInfoToast(context, 'Show more comments'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAddToCartButtons() {
    return Container(
      height: SizeConfig.screenHeight * 0.10,
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
      ),
      child: Row(
        children: [
          InkWell(
            child: Container(
              height: getProportionateScreenHeight(40),
              width: getProportionateScreenHeight(40),
              decoration: BoxDecoration(
                color: isDarkMode(context)
                    ? primaryColor.withOpacity(0.2)
                    : primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: LikeButton(
                size: getProportionateScreenHeight(25),
                circleColor:
                    CircleColor(start: primaryColor, end: primaryColor),
                bubblesColor: BubblesColor(
                  dotPrimaryColor: primaryColor,
                  dotSecondaryColor: primaryColor,
                ),
                isLiked: widget.product.isFavourite,
                likeBuilder: (bool isLiked) {
                  widget.product.isFavourite = isLiked;
                  return Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border_outlined,
                    color: isDarkMode(context)
                        ? primaryColor.withOpacity(0.8)
                        : primaryColor,
                    size: getProportionateScreenHeight(25),
                  );
                },
              ),
            ),
            onTap: () {},
          ),
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),
          Expanded(
            child: Container(
              child: buildButton(
                widget.product.isAddedInCart
                    ? 'Remove from cart'
                    : addToCartLabel,
                true,
                widget.product.isAddedInCart
                    ? isDarkMode(context)
                        ? Colors.grey[700]!
                        : Colors.blueGrey[100]!
                    : isDarkMode(context)
                        ? primaryColorDark
                        : primaryColor,
                widget.product.isAddedInCart
                    ? isDarkMode(context)
                        ? Colors.black87
                        : Colors.blueGrey[800]!
                    : isDarkMode(context)
                        ? Colors.white.withOpacity(0.8)
                        : Colors.white,
                2,
                2,
                8,
                onPressed: () {
                  setState(
                    () {
                      setState(() {
                        widget.product.isAddedInCart =
                            !widget.product.isAddedInCart;
                        myCartData.remove(widget.product);
                        HomeScreen.cartItemCount = myCartData.length;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSimilarProducts() {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenWidth(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Similar Products',
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
                    categoryTitle: 'Shopping App',
                    productList: mixProducts, key: UniqueKey(),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(8)),
          buildProductGridView(
            context,
            similarProductData,
            scrollController,
            Axis.vertical,
            false,
            heroTagPrefix: tagSimilarProducts,
            onCartTap: (i, isAddedInCart) =>
                showInfoToast(context, 'Product has been added to cart!'),
            onFavoriteTap: (i) {
              setState(() {});
            },
            onProductSelected: (i) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(
                    product: similarProductData[i],
                    heroTagPrefix: tagSimilarProducts + '_$i', key: UniqueKey(),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget buildProductFullScreenView(
      {@required productTitle, @required heroTagPrefix, image}) {
    return Container(
      color: Colors.black87,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(16),
                vertical: getProportionateScreenWidth(8),
              ),
              child: InkWell(
                child: Container(
                  width: getProportionateScreenWidth(26),
                  height: getProportionateScreenWidth(26),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(
                        getProportionateScreenWidth(26) / 2),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: getProportionateScreenWidth(18),
                  ),
                ),
                onTap: () {
                  setState(() {
                    isFullScreenImageDisplaying = false;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: PhotoViewGallery.builder(
              pageController: controller,
              itemCount: 6,
              scrollPhysics: enableScrollPhysics
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  imageProvider: AssetImage(
                    image != null
                        ? '$productImagesPath/$image'
                        : '$productImagesPath/demo_image.png',
                  ),
                );
              },
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                        (event.expectedTotalBytes!),
                  ),
                ),
              ),
              backgroundDecoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: 6,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              radius: 8,
              spacing: 8,
              activeDotColor: primaryColor,
              dotColor: Colors.white,
            ),
            onDotClicked: (i) {
              controller.jumpToPage(i);
            },
          ),
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
        ],
      ),
    );
  }
}
