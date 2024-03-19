import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '/screens/authentication/LoginScreen.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class ClassAttendanceProvider extends ChangeNotifier{
  String checkInTime = '';
  String checkOutTime = '';
  //String checkInMalaysiaTime;
  updateCheckInWithTicketId(String ticketId, /*String time*/String latitude, String longitude, String address) async {
    String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()); //change to utc because odoo database accepts understand datetime from odoo as UTC format only
    await globalClient.callKw({
    'model': 'website.supportzayd.ticket',
    'method': 'write',
    'args': [ 
      [int.parse(ticketId)], //update check_in data using ticket id                    
        {
          'check_in': time,
          'check_in_lat' : latitude,
          'check_in_long' : longitude,
          'check_in_address' : address,         
        },
    ],
    'kwargs': {},
    });
    //now convert it back to normal MYT hours from UTC               
    //either way we will have to add 8 hours to convert to Malaysia Time (KL)
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime UTC = inputFormat.parse(time); // MYT here refers to malaysiatimezone(kualalumpur)
    // debug line // print ("MYT before add"+ UTC.toString());
    DateTime MYT = UTC.add(Duration(hours:8));
    checkInTime = MYT.toString().substring(0,19);
    notifyListeners();
  }

  updateCheckOutWithTicketId(String ticketId, /*String time*/String latitude, String longitude, String address) async {
    String time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc()); //change to utc because odoo database accepts understand datetime from odoo as UTC format only
    await globalClient.callKw({
    'model': 'website.supportzayd.ticket',
    'method': 'write',
    'args': [ 
      [int.parse(ticketId)], //update check_in data using ticket id                    
        {
          'check_out': time,
          'check_out_lat' : latitude,
          'check_out_long' : longitude,
          'check_out_address' : address,         
        },
    ],
    'kwargs': {},
    });
    //now convert it back to normal MYT hours from UTC               
    //either way we will have to add 8 hours to convert to Malaysia Time (KL)
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime UTC = inputFormat.parse(time); // MYT here refers to malaysiatimezone(kualalumpur)
    // debug line // print ("MYT before add"+ UTC.toString());
    DateTime MYT = UTC.add(Duration(hours:8));
    checkOutTime = MYT.toString().substring(0,19);
    notifyListeners();
  }

  //fetched data comes from ticket screen, the parameter will be filled with fetched data
  updateFetchedCheckin(String fetchedCheckin){
    checkInTime = fetchedCheckin;
  }
  updateFetchedCheckout(String fetchedCheckout){
    checkInTime = fetchedCheckout;
  }
}
// Finally, we are using ChangeNotifierProvider to allow the UI to interact with
// our attendanceNotifier class.
final attendanceProvider = ChangeNotifierProvider.autoDispose<ClassAttendanceProvider>((ref) {
  return ClassAttendanceProvider();
});