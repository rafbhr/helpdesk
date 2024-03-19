import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/model/produtct_reviews.dart';
import '/util/RemoveGlowEffect.dart';
import '/util/Util.dart';
import '/util/size_config.dart';

import 'SingleProduct.dart';

Widget buildTextFieldExtraHeight(

    BuildContext context,
    TextEditingController controller,
    TextCapitalization capitalization,
    TextInputType textInputType,
    TextInputAction textInputAction,
    bool obscure,
    Color cursorColor,
    double borderRadius,
    Color enabledBorderSideColor,
    Color focusBorderSideColor,
    Color borderSideColor,
    Color fillColor,
    int maxLength,
    int maxLines,
    String hint,
    bool isEnabled,

    {focusNode,
    @required onChange,
    @required onSubmit}) {
  return TextField(
    maxLines: maxLines,
    autofocus: false,
    obscureText: obscure,
    controller: controller,
    textCapitalization: capitalization,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    cursorColor: cursorColor,
    maxLength: maxLength,
    style: Theme.of(context).textTheme.bodyText2,
    decoration: InputDecoration(
      counterText: '',
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: focusBorderSideColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: enabledBorderSideColor,
          width: 1,
        ),
      ),
      fillColor: fillColor,
      filled: true,
      hintText: hint,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: enabledBorderSideColor,
          width: 1,
        ),
      ),
      hintStyle: Theme.of(context).textTheme.bodyText2,
      contentPadding: EdgeInsets.only(
        top: getProportionateScreenHeight(28),
        left: getProportionateScreenHeight(28),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: borderSideColor,
            width: 3,
          )),
    ),
    enabled: isEnabled,
    focusNode: focusNode,
    onChanged: (v) {
      onChange(v);
    },
    onSubmitted: (v) {
      onSubmit();
    },
  );
}

Widget buildTextField(

    BuildContext context,
    TextEditingController controller,
    TextCapitalization capitalization,
    TextInputType textInputType,
    TextInputAction textInputAction,
    bool obscure,
    Color cursorColor,
    double borderRadius,
    Color enabledBorderSideColor,
    Color focusBorderSideColor,
    Color borderSideColor,
    Color fillColor,
    int maxLength,
    String hint,
    bool isEnabled,
    {focusNode,
    @required onChange,
    @required onSubmit}) {
  return TextField(
    autofocus: false,
    obscureText: obscure,
    controller: controller,
    textCapitalization: capitalization,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    cursorColor: cursorColor,
    maxLength: maxLength,
    style: Theme.of(context).textTheme.bodyText2,
    decoration: InputDecoration(
      counterText: '',
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: focusBorderSideColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: enabledBorderSideColor,
          width: 1,
        ),
      ),
      fillColor: fillColor,
      filled: true,
      hintText: hint,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: enabledBorderSideColor,
          width: 1,
        ),
      ),
      hintStyle: Theme.of(context).textTheme.bodyText2,
      contentPadding: EdgeInsets.only(
        top: getProportionateScreenHeight(28),
        left: getProportionateScreenHeight(28),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: borderSideColor,
            width: 3,
          )),
    ),
    enabled: isEnabled,
    focusNode: focusNode,
    onChanged: (v) {
      onChange(v);
    },
    onSubmitted: (v) {
      onSubmit();
    },
  );
}

Widget buildAddressInputField(
    BuildContext context,
    TextEditingController addressLineOne,
    String hintText,
    IconData icon,
    TextInputType inputType,
    TextInputAction inputAction,
    bool enabled,
    FocusNode focusNode,
    {required Function onSubmitted}) {
  return Container(
      child: Container(
    height: 50,
    child: TextField(
      controller: addressLineOne,
      cursorColor: primaryColor,
      keyboardType: inputType,
      textInputAction: inputAction,
      enabled: enabled,
      style: Theme.of(context).textTheme.bodyText2,
      decoration: InputDecoration(
        hintText: hintText,
        labelStyle: Theme.of(context).textTheme.bodyText2,
        hintStyle: Theme.of(context).textTheme.bodyText2,
        suffixIcon: Icon(icon),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      focusNode: focusNode,
      onSubmitted: onSubmitted(),
    ),
  ));
}

Widget buildButton(
    String label,
    bool setPadding,
    Color buttonColor,
    Color textColor,
    double elevation,
    double highlightElevation,
    double borderRadius,
    {@required onPressed}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      MaterialButton(
        child: Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.screenHeight * 0.018,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: setPadding
            ? EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.018)
            : EdgeInsets.all(0.0),
        color: buttonColor,
        textColor: textColor,
        elevation: elevation,
        highlightElevation: highlightElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    ],
  );
}

Widget buildButtonWithLongShadow(
    String label,
    bool setPadding,
    Color buttonColor,
    Color textColor,
    double elevation,
    double highlightElevation,
    double borderRadius,
    {@required onPressed}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: buttonColor.withOpacity(0.3),
              blurRadius: 50 / 5,
              offset: Offset(0, 50 / 5),
            ),
          ],
        ),
        child: MaterialButton(
          child: Text(
            label,
          ),
          padding: setPadding
              ? EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.018)
              : EdgeInsets.all(0.0),
          color: buttonColor,
          textColor: textColor,
          elevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
          ),
          onPressed: () {
            onPressed();
          },
        ),
      ),
    ],
  );
}

Widget buildButtonWithSuffixIcon(
    String label,
    IconData icon,
    bool setPadding,
    Color buttonColor,
    Color textColor,
    double elevation,
    double highlightElevation,
    double borderRadius,
    {@required onPressed}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 14,
            ),
            Icon(
              icon,
              size: 20,
            ),
          ],
        ),
        padding: setPadding
            ? EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.018)
            : EdgeInsets.all(0.0),
        color: buttonColor,
        textColor: textColor,
        elevation: elevation,
        highlightElevation: highlightElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    ],
  );
}

Widget buildButtonWithIcon(
    BuildContext context,
    String iconPath,
    String label,
    bool setPadding,
    Color buttonColor,
    Color textColor,
    double elevation,
    double highlightElevation,
    double borderRadius,
    {required onPressed()}) {
  return MaterialButton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: SizeConfig.screenHeight * 0.022,
          height: SizeConfig.screenHeight * 0.022,
        ),
        SizedBox(
          width: SizeConfig.screenHeight * 0.015,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: poppinsFont,
              fontSize: SizeConfig.screenHeight * 0.016),
        ),
      ],
    ),
    padding: setPadding
        ? EdgeInsets.symmetric(
            vertical: SizeConfig.screenHeight * 0.016,
          )
        : EdgeInsets.all(0.0),
    color: buttonColor,
    textColor: textColor,
    elevation: elevation,
    highlightElevation: highlightElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    onPressed: () {
      onPressed();
    },
  );
}

Widget buildButtonWithSvgIcon(
    BuildContext context,
    IconData iconPath,
    String label,
    bool setPadding,
    Color buttonColor,
    Color textColor,
    double elevation,
    double highlightElevation,
    double borderRadius,
    {required onPressed()}) {
  return MaterialButton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: MediaQuery.of(context).size.width / 6),
        Icon(iconPath, size: 20),
        SizedBox(width: MediaQuery.of(context).size.width / 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: poppinsFont),
        ),
      ],
    ),
    padding:
        setPadding ? EdgeInsets.symmetric(vertical: 15.0) : EdgeInsets.all(0.0),
    color: buttonColor,
    textColor: textColor,
    elevation: elevation,
    highlightElevation: highlightElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    onPressed: () {
      onPressed();
    },
  );
}

Widget buildErrorNotificationWithOption(BuildContext context,
    String errorMessage, String option, Color backgroundColor, bool showOption,
    {focusNode, @required onOptionTap}) {
  return Material(
    shadowColor: Colors.grey,
    elevation: 6,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
    child: Column(
      children: [
        Container(
          color: reddishColor,
          height: 2,
          width: 350,
        ),
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(errorMessage,
                    style: Theme.of(context).textTheme.bodyText2),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: showOption,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    child: Text(option, style: authScreensClickableLabelStyle),
                    onTap: () {
                      onOptionTap();
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Widget buildErrorNotification(String errorMessage, Color backgroundColor) {
  return Material(
    shadowColor: Colors.grey,
    elevation: 6,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: backgroundColor,
          height: 2,
          width: 350,
        ),
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorMessage,
                  style: normalTextStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Stack buildHeaderIcons(IconData icon, int itemCount, bool isDarkMode,
    {required Function onTap}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned(
        child: InkWell(
          child: Icon(
            icon,
            size: getProportionateScreenWidth(26),
            color: isDarkMode ? Colors.white70 : Colors.white,
          ),
          onTap: () => onTap(),
        ),
      ),
      Positioned(
        top: -SizeConfig.screenHeight * 0.005,
        right: -SizeConfig.screenHeight * 0.005,
        child: InkWell(
          child: Container(
            width: SizeConfig.screenHeight * 0.018,
            height: SizeConfig.screenHeight * 0.018,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.red[800] : Colors.red,
              borderRadius: BorderRadius.all(
                Radius.elliptical(
                  SizeConfig.screenHeight * 0.09,
                  SizeConfig.screenHeight * 0.09,
                ),
              ),
            ),
            child: Center(
              child: Text(
                '$itemCount',
                style: TextStyle(
                    fontSize: SizeConfig.screenHeight * 0.010,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          onTap: () => onTap(),
        ),
      ),
    ],
  );
}

Widget buildIconButtonOutline(String icon, String text, bool isDarkMode,
    {@required onPressed}) {
  return TextButton(
    style: ButtonStyle(
        shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: isDarkMode ? Colors.white70 : Colors.white,
          width: 1.5,
        ),
      ),
    )),
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenHeight * 0.008,
          vertical: SizeConfig.screenHeight * 0.003),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: getProportionateScreenWidth(20),
            height: getProportionateScreenWidth(20),
            color: isDarkMode ? Colors.white70 : Colors.white,
          ),
          SizedBox(
            width: SizeConfig.screenHeight * 0.010,
          ),
          Text(
            text,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.white,
              fontSize: SizeConfig.screenHeight * 0.016,
            ),
          ),
        ],
      ),
    ),
    onPressed: () => onPressed(),
  );
}

Widget buildButtonOutline(String text, Color borderColor, Color textColor,
    {@required onPressed}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: borderColor,
              width: 1.5,
            ),
          ),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: SizeConfig.screenHeight * 0.009),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 13.0,
              ),
            ),
          ],
        ),
      ),
      onPressed: () => onPressed(),
    ),
  );
}

Widget buildIconButtonForToolbar(
    BuildContext context,
    IconData iconData,
    String label,
    bool setPadding,
    Color buttonColor,
    Color textColor,
    double elevation,
    double highlightElevation,
    double borderRadius,
    {required onPressed()}) {
  return MaterialButton(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 20,
        ),
        SizedBox(
          width: 14,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: poppinsFont),
        ),
      ],
    ),
    padding: setPadding
        ? EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0)
        : EdgeInsets.all(0.0),
    color: buttonColor,
    textColor: textColor,
    elevation: elevation,
    highlightElevation: highlightElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    onPressed: () {
      onPressed();
    },
  );
}

Widget buildInputWithIcon(
  TextEditingController controller,
  TextCapitalization capitalization,
  TextInputType textInputType,
  TextInputAction textInputAction,
  Color tintColor,
  double borderRadius,
  Color enabledBorderSideColor,
  Color focusBorderSideColor,
  Color borderSideColor,
  Color fillColor,
  focusNode,
  String hint, {
  required IconData iconData,
  @required onChange,
  @required onSubmit,
}) {
  return TextField(
    autofocus: false,
    controller: controller,
    textCapitalization: capitalization,
    keyboardType: textInputType,
    textInputAction: textInputAction,
    cursorColor: tintColor,
    style: TextStyle(
      fontSize: SizeConfig.screenHeight * 0.013,
      fontFamily: poppinsFont,
      color: tintColor,
    ),
    textAlignVertical: TextAlignVertical.bottom,
    decoration: InputDecoration(
      prefixIcon: Icon(
        iconData,
        color: tintColor.withOpacity(0.6),
        size: SizeConfig.screenHeight * 0.028,
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusBorderSideColor, width: 1)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusBorderSideColor, width: 1)),
      fillColor: fillColor,
      filled: true,
      hintText: hint,
      hintStyle: TextStyle(
          fontSize: SizeConfig.screenHeight * 0.014,
          color: tintColor.withOpacity(0.4)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: focusBorderSideColor, width: 0)),
    ),
    focusNode: focusNode,
    onChanged: (v) {
      onChange(v);
    },
    onSubmitted: (v) {
      onSubmit(v);
    },
  );
}

Widget buildReadOnlyRatingBar(
  double initialRating,
  double rateSize,
  Color ratingColor,
) {
  return RatingBar.builder(
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      itemSize: rateSize,
      unratedColor: ratingColor.withOpacity(0.2),
      allowHalfRating: true,
      itemCount: 5,
      itemBuilder: (context, _) => Icon(
            Icons.star,
            color: ratingColor,
          ),
      onRatingUpdate: (rating) {
        print(rating);
      });
}

Widget buildAppBar(BuildContext context, String title,
    {required Function onBackPress}) {
  return AppBar(
    backgroundColor: isDarkMode(context) ? darkGreyColor : Colors.white,
    title: Text(
      title,
      style: Theme.of(context).textTheme.subtitle1?.copyWith(
          fontWeight: Theme.of(context).textTheme.subtitle2?.fontWeight),
    ),
    leading: InkWell(
      child: Icon(
        Icons.keyboard_backspace,
        color: isDarkMode(context)
            ? Colors.white70
            : Colors.black.withOpacity(0.8),
        size: getProportionateScreenWidth(18),
      ),
      onTap: () => onBackPress(),
    ),
    centerTitle: true,
    elevation: 3,
    shadowColor: Colors.black.withOpacity(0.4),
  );
}

Widget buildNavigationItem(String image, String title) {
  return Container(
    padding: new EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
    margin: EdgeInsets.only(left: 6.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image,
          width: 32,
          height: 32,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(title),
        ),
      ],
    ),
  );
}

Widget buildDialogWithAnimation(
  
  
  BuildContext context, String successmessage, String buttonText, {@required onTap}){
      return Stack(children: [
        Dialog(
          child: Container(
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  Text(
                    successmessage,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: Text(
                      buttonText,
                      style: homeScreensClickableLabelStyle,
                    ),
                    onTap: () {
                      onTap();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ]);

  }
  



Widget buildDialog(
    BuildContext context, String message, String buttonText, String topIcon,
    {@required onTap}) {
  return Stack(children: [
    Dialog(
      child: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Text(
                  buttonText,
                  style: homeScreensClickableLabelStyle,
                ),
                onTap: () {
                  onTap();
                },
              ),
            ],
          ),
        ),
      ),
    ),
    Center(
      child: SvgPicture.asset(
        topIcon,
        height: 60,
        width: 60,
      ),
    )
  ]);
}

Widget buildProductGridView(
  BuildContext context,
  productList,
  ScrollController scrollController,
  Axis scrollDirection,
  bool isLoading, {
  @required heroTagPrefix,
  required onCartTap(i, b),
  required onFavoriteTap(i),
  required onProductSelected(i),
}) {
  return Column(
    children: [
      Container(
        height: scrollDirection == Axis.vertical
            ? null
            : getProportionateScreenWidth(250),
        width: double.infinity,
        child: ScrollConfiguration(
          behavior: RemoveScrollingGlowEffect(),
          child: GridView.count(
            scrollDirection: scrollDirection,
            crossAxisCount: scrollDirection == Axis.vertical ? 2 : 1,
            childAspectRatio: scrollDirection == Axis.vertical ? 0.75 : 1.55,
            crossAxisSpacing: scrollDirection == Axis.vertical ? 6 : 0,
            mainAxisSpacing: scrollDirection == Axis.vertical ? 6 : 2,
            shrinkWrap: true,
            controller: scrollController,
            children: List.generate(productList.length, (index) {
              return isLoading
                  ? shimmerLoading(context)
                  : buildSingleProduct(
                      context: context,
                      product: productList[index],
                      isDarkMode: isDarkMode(context),
                      heroTagPrefix: heroTagPrefix,
                      onCartTap: (b) => onCartTap(index, b),
                      onProductSelected: () {
                        onProductSelected(index);
                      });
            }),
          ),
        ),
      ),
    ],
  );
}

void buildConfirmationDialog(
    BuildContext context, String titleText, String detailText,
    {@required onOkPress, @required onCancelPress}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: titleText != null ? Text(titleText) : null,
      content: Text(
        detailText,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: [
        TextButton(
          onPressed: () {
            onOkPress();
          },
          child: Text(
            'Ok',
            style: TextStyle(fontSize: 14, fontFamily: poppinsFont),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onCancelPress();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.subtitle1?.fontSize,
              fontFamily: Theme.of(context).textTheme.subtitle1?.fontFamily,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

Shimmer shimmerLoading(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[200] ?? Colors.grey, // provide a default color here
    highlightColor: Colors.grey[350] ?? Colors.grey, // provide a default color here
    child: Center(
      child: Text(
        loadingTitle,
        style: Theme.of(context).textTheme.headline6,
      ),
    ),
  );
}


Widget buildRating(int starCount, double ratingValue, bool isDarkMode) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(12),
      vertical: getProportionateScreenWidth(6),
    ),
    child: Row(
      children: [
        Text(
          '$starCount',
          style: TextStyle(
            fontFamily: poppinsFont,
            fontSize: SizeConfig.screenHeight * 0.016,
          ),
        ),
        SizedBox(
          width: getProportionateScreenWidth(4),
        ),
        Icon(
          Icons.star,
          size: getProportionateScreenWidth(14),
          color: isDarkMode ? Colors.yellow[800] : Colors.amber,
        ),
        SizedBox(
          width: getProportionateScreenWidth(10),
        ),
        SizedBox(
          width: SizeConfig.screenWidth / 1.5,
          child: LinearProgressIndicator(
            value: ratingValue,
            color: primaryColor,
            backgroundColor: isDarkMode ? Colors.white24 : Colors.blueGrey[50],
          ),
        )
      ],
    ),
  );
}

Widget buildReviewComments(
  BuildContext context,
  ProductReview productReview,
) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(12),
    ),
    child: Container(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productReview.reviewerName,
                style: Theme.of(context).textTheme.subtitle2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                width: getProportionateScreenWidth(6),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(1.5),
                ),
                child: Row(
                  children: [
                    Text(
                      '${productReview.rating}',
                      style: TextStyle(
                        fontFamily: poppinsFont,
                        color: Colors.white,
                        fontSize: SizeConfig.screenHeight * 0.014,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(
                      Icons.star,
                      size: getProportionateScreenWidth(10),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                productReview.date,
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(
            height: getProportionateScreenWidth(12),
          ),
          Text(
            productReview.reviewComment,
            style: Theme.of(context).textTheme.bodyText2,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(),
        ],
      ),
    ),
  );
}

TextStyle loweWeightTextStyle = TextStyle(
  fontSize: SizeConfig.screenHeight * 0.012,
  fontFamily: poppinsFont,
  color: Colors.black.withOpacity(0.4),
);

TextStyle normalTextStyle = TextStyle(
  fontSize: SizeConfig.screenHeight * 0.016,
  fontFamily: poppinsFont,
  color: Colors.black.withOpacity(0.7),
);

TextStyle authScreensClickableLabelStyle = TextStyle(
  fontFamily: poppinsFont,
  color: primaryColor,
  fontSize: SizeConfig.screenHeight * 0.016,
  decoration: TextDecoration.underline,
);

TextStyle homeScreensClickableLabelStyle = TextStyle(
  fontFamily: poppinsFont,
  color: primaryColor,
  fontSize: SizeConfig.screenHeight * 0.014,
  fontWeight: FontWeight.w600,
  decoration: TextDecoration.none,
);

TextStyle ticketScreensClickableLabelStyle = TextStyle(
  fontFamily: poppinsFont,
  color: primaryColor,
  fontSize: SizeConfig.screenHeight * 0.018,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.none,
);

