class SupportTicket{
  final String ticket_number;
  final String ticket_id;
  final String assigned_user;
  final String check_in;
  final String check_out;
  final String check_in_address;
  final String check_out_address;
  final String subject;
  final String created_date;
  final String rating;
  final String partner_name;
  final String partner_id;
  final String equipment_location;

  
  const SupportTicket({
  
    required this.ticket_number, required this.ticket_id, required this.assigned_user,
    required this.check_in, required this.check_out, required this.check_in_address, required this.check_out_address,
    required this.subject, required this.created_date, required this.rating, required this.partner_name, required this.partner_id,
    required this.equipment_location,

  });
  static SupportTicket fromJson(Map<String, dynamic> json) => SupportTicket(
    // if it returns false, because idontknow, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String  

    ticket_number : json['ticket_number'] == false ? json['ticket_number'] = '' : json['ticket_number'].toString(), 
    ticket_id : json['id'].toString(),
    assigned_user: json['user_id'] == false ? json['user_id'] = '' : json['user_id'][1].toString(),
    check_in: json['check_in'].toString(),
    check_out: json['check_out'].toString(),
    check_in_address: json['check_in_address'].toString(),
    check_out_address: json['check_out_address'].toString(),
    created_date: json['create_date'] == false ? json['create_date'] = '' : json['create_date'].toString(),
    subject: json['subject'] == false ? json['subject'] = '' : json['subject'].toString(),
    rating: json['rating'] == null ? json['rating'] = '0' : json['rating'].toString(),
    partner_id: json['partner_id'] == false || json['partner_id'] == null  ? '' : json['partner_id'][0].toString(),
    partner_name: json['partner_id'] == false || json['partner_id'] == null ? '' : json['partner_id'][1].toString(),

    equipment_location: json['equipment_location'] == null ? json['equipment_location'] = 'Not Defined' : json['equipment_location'].toString(),

  );
}