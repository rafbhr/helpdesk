import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';    
import '/OdooApiCall/ToCheckInTicketsApi.dart';

import '../OdooApiCall/ToCheckOutTicketsApi.dart';

    

    class CheckOutNotifier extends PagedNotifier<int,  ToCheckInOutSupportTicket> {
      
      CheckOutNotifier():
      super(
       
        load: (page, limit) =>  
        Future.delayed(Duration(seconds: 1), () =>
          ToCheckOutTicketsApi.getAllSupportTickets(page, limit),
        ),
        

        nextPageKeyBuilder: mysqlPagination
    
        /*Future.delayed(const Duration(seconds: 2), () {
            // This simulates a network call to an api that returns paginated posts
            return List.generate(
                20,
                (index) => ToCheckOutOutSupportTicket(
                    check_in: "My ${index + ((limit * page) - limit)} work",
                ));
          }),
          
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
          */
        );
    }

    //create a global provider as you would normally in riverpod:
    final  checkOutProvider = StateNotifierProvider<CheckOutNotifier, PagedState<int, ToCheckInOutSupportTicket>>
    ((_) => CheckOutNotifier());

    

    //NextPageKeyBuilder<int, dynamic> mysqlPagination2 = (List<dynamic> lastItems, int  offset, int  limit) {
	  //  return (lastItems.length == null || lastItems.length < limit) ? null :lastItems[lastItems.length - 1].ha); 
    //};
NextPageKeyBuilder<int, dynamic> mysqlPagination = (List<dynamic>? lastItems, int offset, int limit) {
  return (lastItems == null || lastItems.length < limit) ? null : (offset + limit);
};
