// TODO Implement this library.import 'dart:convert';
import 'package:odoo_rpc/odoo_rpc.dart';
import '../OdooApiCall_DataMapping/LocationHistory.dart';
import '../screens/authentication/LoginScreen.dart';

  
//might need to import session id here, to get user id, to get to filter.
class LocationHistoryApi {
  
    static Future<List<LocationHistory>> getLocationHistory(OdooClient client, OdooSession session) async {
    var checkInData = await client.callKw({ //might need to be changed to widget.client.callkw later because of passing user id session.
      'model': 'website.supportzayd.ticket',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {}, //because by default odoo fields.char return False when its null, therefore we change the default return '' rather than false
        'domain': [
          ['check_in','!=',''],['check_out','!=',''],//['user_id','=',session.userId]
          ['user_id', '=', globalUserId]],
        'fields': [
          'id',
          'check_in',
          'check_out',
          'check_in_address',
          'check_out_address',
          //'check_in_lat',
          //'check_in_long',
          //'check_out_lat',
          //'check_out_long',
        ],
      },
    });


    List listTicket = [];
    listTicket = checkInData; 
    print('\nUser info: \n' +
    checkInData.toString()); 
    //listTicket =  fetchTicketData.map((json) => UnassignedLocationHistory.fromJson(json)).toList(); //convert our json data from odoo to list.
    
    //Add your data to stream
    
    //_streamController.add(data);
    return listTicket.map((json) => LocationHistory.fromJson(json)).toList();
  }

}