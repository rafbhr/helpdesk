import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/screens/products/MyAttendanceScreen.dart';
import '/screens/products/MySubmitFormScreen.dart';
import '/screens/products/TicketDetailScreen.dart';
import '/util/Util.dart';
import '/widgets/Styles.dart';
import '/screens/products/CheckLocationPermission.dart';
import '../util/size_config.dart';

Widget buildTicketList(item, globalClient, context, index) {
  // print all tickets
  print('Submit Form Tab');
  print(item);
  print(item.ticket_number);
  print(item.subject);
  var avatarUrl;
  if (item.partner_id != null)
    avatarUrl =
        '${globalClient.baseURL}/web/image?model=res.partner&id=${item.partner_id}&field=image_medium'; //&unique=$unique';
  else
    avatarUrl = null;
  DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  DateTime input = inputFormat.parse(item.created_date);
  DateTime MYtimezone = input.add(Duration(hours: 8));
  String create_date = DateFormat("dd/MM/yyyy hh:mm:ss a").format(
      MYtimezone); //use this variable, because malaysia timezone is +8 hours from UTC. database gives u UTC time
  String respartner_id = item.partner_id != null
      ? item.partner_id
      : ''; //we need this to pass non null partner_id data to the attendance screen, to get the partner_latitude and longitude
  //field respartner_id is very important.

  String _buttonValue = 'SUBMIT FORM'; // Assign a default value
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: getProportionateScreenWidth(16),
      vertical: getProportionateScreenWidth(4),
    ),
    child: Card(
      elevation: 6,
      color: isDarkMode(context) ? darkGreyColor : Colors.white,
      shadowColor: Colors.grey.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      //create Inkwell to head the items
      child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row( // RenderFlex overflow error
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        avatarUrl != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(avatarUrl,
                                    headers: {
                                      "X-Openerp-Session-Id":
                                          globalClient.sessionId.id
                                    }),
                                onBackgroundImageError: null,
                                backgroundColor:
                                    Color.fromARGB(255, 150, 190, 223),
                                radius: getProportionateScreenWidth(35))
                            : CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 150, 190, 223),
                                radius: getProportionateScreenWidth(35)),
                        SizedBox(width: getProportionateScreenWidth(10)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: SizeConfig.screenWidth / 1.8,
                                  child: Text(
                                    '#${item.ticket_number} ${item.subject}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            fontWeight: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                ?.fontWeight),
                                  ),
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(5)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: SizeConfig.screenWidth / 1.8,
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child:
                                                  Icon(Icons.person, size: 20),
                                            ),
                                            TextSpan(
                                              text: ' ' + item.equipment_user,
                                              style:
                                                  ticketScreensClickableLabelStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                item.partner_name != ''
                                    ? Container(
                                        width: SizeConfig.screenWidth / 1.8,
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(Icons.business,
                                                    size: 20),
                                              ),
                                              TextSpan(
                                                text: ' ' +
                                                    item.partner_name
                                                        .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.copyWith(
                                                        //decoration:
                                                        //    TextDecoration.lineThrough,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Container(
                                  width: SizeConfig.screenWidth / 1.8,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child:
                                              Icon(Icons.date_range, size: 20),
                                        ),
                                        TextSpan(
                                          text: ' ' + create_date,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                //decoration:
                                                //    TextDecoration.lineThrough,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    ?.color,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: getProportionateScreenHeight(10)),
                                Container(
                                  width: SizeConfig.screenWidth / 2,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    text: TextSpan(
                                      children: [
                                        item.category_name != '' &&
                                                item.subcategory_name == ''
                                            ? TextSpan(
                                                text: '• ' + item.category_name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    ?.copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: orangeredColor),
                                              )
                                            : item.category_name != '' &&
                                                    item.subcategory_name != ''
                                                ? TextSpan(children: [
                                                    TextSpan(
                                                        text: '• ' +
                                                            item.category_name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2
                                                            ?.copyWith(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                color:
                                                                    orangeredColor)),
                                                    TextSpan(
                                                      text: ' ' +
                                                          '• ' +
                                                          item.subcategory_name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          ?.copyWith(),
                                                    )
                                                  ])
                                                : TextSpan(),
                                      ],
                                    ),
                                  ),
                                ),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.delete,
                          size: 22,
                          color: primaryColor,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                Divider(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenWidth(4),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_buttonValue == 'CHECK IN' || _buttonValue == 'CHECK OUT') {
                            checkLocationPermission(context); // Add this line
                            Navigator.push(
                                context,
                                OpenUpwardsPageRoute(
                                    child: MyAttendanceScreen(item, respartner_id),
                                    direction: AxisDirection.up))
                                .then((value) {
                              //setState((){
                              //});
                            });
                          } else if (_buttonValue == 'SUBMIT FORM' || _buttonValue == 'EDIT FORM') {
                            // TODO: This is supposed to execute instead of the one in MyToCheckInScreen file
                            Navigator.push(
                                context,
                                OpenUpwardsPageRoute(
                                    child: MySubmitFormScreen(item),
                                    direction: AxisDirection.up))
                                .then((value) {});
                          }
                        },
                        autofocus: true,
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.resolveWith<double>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return 16;
                            return 0;
                          }),
                          //shape: RectangularRangeSliderTrackShap
                          backgroundColor:
                              MaterialStateProperty.all<Color>(primaryColor),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    item.check_in == '' && item.check_out == '' && item.close_comment == ''
                                        ? _buttonValue = 'CHECK IN'
                                        : item.check_in != '' && item.check_out == '' && item.close_comment == ''
                                            ? _buttonValue = 'CHECK OUT'
                                            : item.check_in != '' && item.check_out != '' && item.close_comment == ''
                                                ? _buttonValue = 'SUBMIT FORM'
                                              : item.check_in != '' && item.check_out != '' && item.close_comment != ''  ?
                                        _buttonValue = 'EDIT FORM'
                                                : null,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(
                                      fontFamily: poppinsFont,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                    context,
                    OpenUpwardsPageRoute(
                        child: TicketDetailScreen(item, respartner_id),
                        direction: AxisDirection.left))
                .then((value) {});
          }),
    ),
    //),
  );
}
