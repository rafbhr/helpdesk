import 'package:flutter/widgets.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import '/OdooApiCall_DataMapping/ResPartner.dart';
import '/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import '/OdooApiCall_DataMapping/ToCheckIn_ToCheckOut_SupportTicket.dart';
import '../OdooApiCall_DataMapping/SupportTicket.dart';
import '../screens/authentication/LoginScreen.dart';

  
//might need to import session id here, to get user id, to get to filter.
class AllTicketsApi {

  static Future <List<ToCheckInOutSupportTicket>> getAllSupportTickets() async{

    try{
      var fetchTicketData = await globalClient.callKw({
        'model': 'website.supportzayd.ticket',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {},
          'domain': [['state.name','!=','Staff Closed'], ['user_id', '=', globalUserId] // Add this line
          ],
          'fields':[],
        },
      });
      List listTicket = [];
      listTicket = fetchTicketData;
      print ('Get All Support Ticket: '+ fetchTicketData.toString());
      return listTicket.map((json) => ToCheckInOutSupportTicket.fromJson(json)).toList();
    } catch(e){
      return Future.error(e.toString());
    }
  }

  static Future<int> countOpenSupportTickets(OdooClient client) async {
    var fetchTicketData = await client.callKw({
      'model': 'website.supportzayd.ticket',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {},
        'domain': [['state.name','=','Staff Closed']],
        'fields': [
          'ticket_number',
          'state'
        ],
      },
    });
    List listTicket = [];
    listTicket = fetchTicketData;
    return listTicket.map((json) => SupportTicket.fromJson(json)).toList().length;
  }

  static Future<List<ResPartner>> getResPartner (String respartner_id) async {
    var fetchTicketData = await globalClient.callKw({
      'model': 'res.partner',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {},
        'domain': [['id','=',respartner_id]],
        'fields': [
          'partner_latitude',
          'partner_longitude'
        ],
      },
    });
    List listTicket = [];
    listTicket = fetchTicketData;
    print("lets find out the truth of respartner : "+ fetchTicketData.toString());
    return listTicket.map((json) => ResPartner.fromJson(json)).toList();
  }
}

