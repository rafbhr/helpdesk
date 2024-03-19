import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import '/colors/Colors.dart';
import '/constant/Constants.dart';
import '/riverpod_class/checkin_notifier_api.dart';
import '/riverpod_class/checkout_notifier_api.dart';
import '/riverpod_class/submitform_notifier.dart';
import '/screens/authentication/LoginScreen.dart';
import '/screens/products/MyAttendanceScreen.dart';
import '/screens/products/TicketDetailScreen.dart';
import '/util/RemoveGlowEffect.dart';
import '/util/Util.dart';
import '/util/size_config.dart';
import '/widgets/Styles.dart';
import '/widgets/TicketsListViewWidget.dart';

//final PagingController<int, ToCheckInOutSupportTicket> _pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 10,);

class SubmitFormTab extends StatefulWidget {
  const SubmitFormTab({Key? key}) : super(key: key);

  @override
  State<SubmitFormTab> createState() => _SubmitFormTabState();
}

class _SubmitFormTabState extends State<SubmitFormTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      //appBar: AppBar(),
      body: SafeArea(
        child: RiverPagedBuilder<int, ToCheckInOutSupportTicket>(
            limit: 20,
            firstPageKey: 0,
            provider: submitFormProvider,
            pullToRefresh: true,
            enableInfiniteScroll: true,
            itemBuilder: (context, item, index) {
              return buildTicketList(item, globalClient, context, index);
              /*return ListTile(
              //leading: Image.network(item.image),
              title: Text(item.ticket_id+"\nmyindex:" +index.toString())
            );*/
            },
            pagedBuilder: (_pagingController, builder) {
              //controller = PagingController(firstPageKey: , invisibleItemsThreshold: 5); //an attempt to change the threshold @hafizalwi ogos3
              return PagedListView(
                pagingController: _pagingController,
                builderDelegate: builder,
                dragStartBehavior: DragStartBehavior.down,
                physics: ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
              );
            }),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
