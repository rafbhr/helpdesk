


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';  
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import '/riverpod_class/checkout_notifier_api.dart';
import '/screens/authentication/LoginScreen.dart';
import '/widgets/TicketsListViewWidget.dart';

//final PagingController<int, ToCheckInOutSupportTicket> _pagingController = PagingController(firstPageKey: 0, invisibleItemsThreshold: 10,);
    
class CheckOutTab extends StatefulWidget {
  const CheckOutTab({required Key key}) : super(key: key);

  @override
  State<CheckOutTab> createState() => _CheckOutTabState();
}

class _CheckOutTabState extends State<CheckOutTab> with AutomaticKeepAliveClientMixin{
      @override
      Widget build(BuildContext  context){
        super.build(context);
        return Scaffold(
          //appBar: AppBar(),
          body: SafeArea(
            child: RiverPagedBuilder<int, ToCheckInOutSupportTicket>(
            limit: 20,
            firstPageKey: 0,
            provider: checkOutProvider,
            pullToRefresh: true,    
            enableInfiniteScroll: true, 
            
            itemBuilder: (context, item, index){
              return buildTicketList(item, globalClient, context,index );                                    
            /*return ListTile(
              //leading: Image.network(item.image),
              title: Text(item.ticket_id+"\nmyindex:" +index.toString())
            );*/        
            },
         
            pagedBuilder:(_pagingController,builder){
              //controller = PagingController(firstPageKey: , invisibleItemsThreshold: 5); //an attempt to change the threshold @hafizalwi ogos3     
              return PagedListView (
              
                pagingController: _pagingController, 
                builderDelegate: builder,             
                dragStartBehavior: DragStartBehavior.down,
                physics: ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),               
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

    

