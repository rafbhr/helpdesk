


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';  
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import '/riverpod_class/checkin_notifier_api.dart';
import '/screens/authentication/LoginScreen.dart';
import '/widgets/TicketsListViewWidget.dart';

//final PagingController<int, ToCheckInOutSupportTicket> _pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 10,);
    
    class CheckInTab extends StatefulWidget {
      const CheckInTab({required Key key}) : super(key: key);

  @override
  State<CheckInTab> createState() => _CheckInTabState();
}

class _CheckInTabState extends State<CheckInTab> with AutomaticKeepAliveClientMixin{
      @override
      Widget build(BuildContext  context){
        super.build(context);
        

        return Scaffold(
          //appBar: AppBar(),
          body: SafeArea(

            child: RiverPagedBuilder<int, ToCheckInOutSupportTicket>(
            limit: 20,
            firstPageKey: 0,
            provider: checkInProvider,
            pullToRefresh: true,    
            enableInfiniteScroll: true, 
     
            
            itemBuilder: (context, item, index){
              return buildTicketList(item, globalClient, context,index );        
            },          
            pagedBuilder:(_pagingController,builder){
              //controller = PagingController(firstPageKey: , invisibleItemsThreshold: 5); //an attempt to change the threshold @hafizalwi ogos3     
              return PagedListView (
              
                pagingController: _pagingController, 
                builderDelegate: builder,             
                dragStartBehavior: DragStartBehavior.down,
                physics: ClampingScrollPhysics( parent: AlwaysScrollableScrollPhysics(),
                ),
                addAutomaticKeepAlives: true,
             
              );
            }
              
            ),
          ),
        );
      }
      
        @override
        // TODO: implement wantKeepAlive
        bool get wantKeepAlive => true;
}

    

