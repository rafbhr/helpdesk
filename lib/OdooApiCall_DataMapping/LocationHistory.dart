class LocationHistory {

  final String ticket_id;
  final String check_in;
  final String check_out;
  final String check_in_address;
  final String check_out_address;
  //final String check_in_lat;
  //final String check_in_long;
  //final String check_out_lat;
  //final String check_out_long;


  const LocationHistory({
   required this.check_in,
   required this.check_in_address,
   required this.check_out,
   required this.check_out_address,
   required this.ticket_id,
   });

  static LocationHistory fromJson(Map<String, dynamic> json) => LocationHistory(
    // if it returns false, because idontknow, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String
      ticket_id: json['id'].toString(), 
      check_in :json['check_in'] == false ? json['check_in'] = '' : json['check_in'].toString(),    
      check_out : json['check_out'] == false ? json['check_out'] = '' : json['check_out'].toString(), 
      check_in_address: json['check_in_address'] == false ? json['check_in_address'] = '' : json['check_in_address'].toString(), 
      check_out_address: json['check_out_address'] == false ? json['check_out_address'] = '' : json['check_out_address'].toString(),
  );   
}


