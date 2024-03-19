// TODO Implement this library.import 'dart:convert';
import 'package:odoo_rpc/odoo_rpc.dart';
import '/OdooApiCall_DataMapping/ResPartner.dart';
import '/screens/authentication/LoginScreen.dart';
import '../OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';

  
//might need to import session id here, to get user id, to get to filter.
class ToCheckInTicketsApi {

    static Future <List<ToCheckInOutSupportTicket>> getAllSupportTickets(int offset, int limit) async{
    var fetchTicketData = await globalClient.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
      'model': 'website.supportzayd.ticket',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
        //'domain': [ ['check_in','=','']],
        'domain': [['check_in','=',null],['check_out','=',null], ['user_id', '=', globalUserId]],
        'fields': [],
        'order':'create_date desc', //still testing
        'offset':offset, //should change (increase/decrease one way) over time
         'limit':limit,
      },
    });
    
    print ("offset"+ offset.toString());
    print ("limit"+ limit.toString());
    List listTicket = [];
    listTicket = fetchTicketData; //fetchticketdata(var dynamic) is assigned to List, 
    //print('\nUser info: \n' +
    //  fetchTicketData.toString()); //TODO this is for testing only, delete later
    //listTicket =  fetchTicketData.map((json) => UnassignedUnassignedSupportTicket.fromJson(json)).toList(); //convert our json data from odoo to list.
    return listTicket.map((json) => ToCheckInOutSupportTicket.fromJson(json)).toList();
  }

    static Future<List<ResPartner>> getResPartner (String respartner_id) async {
    var fetchTicketData = await globalClient.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
        'domain': [['id','=',respartner_id]],
        'fields': [
          'partner_latitude',
          'partner_longitude'
        ],
      },
    });
    List listTicket = [];
    listTicket = fetchTicketData; //fetchticketdata(var dynamic) is assigned to List, 
    print("lets find out the truth of respartner : "+ fetchTicketData.toString());
    //listTicket =  fetchTicketData.map((json) => ClosedClosedSupportTicket.fromJson(json)).toList(); //convert our json data from odoo to list.
    return listTicket.map((json) => ResPartner.fromJson(json)).toList();
  }
}

//now we will put all this API call into a riverpod provider, because, well, riverpod gives us good caching right? which is what we need? im not sure tho.