//we call the class name tocheckinout because this is the base for api call including checkin and checkout call.

class ToCheckInOutSupportTicket {
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
  final String equipment_user;
  final String reported_by;
  final String contact_num;
  final String email;
  final String department;
  final String address;
  final String category_name;
  final String subcategory_name;
  final String problem_name;
  final String open_case;
  final String itemname;
  final String close_comment;
  final String cmform_number;

  const ToCheckInOutSupportTicket({
    required this.ticket_number, required this.ticket_id, required this.assigned_user,
    required this.check_in, required this.check_out, required this.check_in_address, required this.check_out_address,
    required this.subject, required this.created_date, required this.rating, required this.partner_name, required this.partner_id,
    required this.equipment_location, required this.equipment_user, required this.reported_by,required this.contact_num,
    required this.email, required this.department,required this.address,
    required this.category_name, required this.subcategory_name, required this.problem_name,
    required this.open_case, required this.itemname, required this.close_comment, required this.cmform_number
  });

  static ToCheckInOutSupportTicket fromJson(Map<String, dynamic> json) => ToCheckInOutSupportTicket(
    // if it returns false, because odoo is weird in handling json, odoo return false for null in JSON, 
    //then set it as ' ', otherwise, set it as its normal value, which is usually String  
    ticket_number : json['ticket_number'] == false ? json['ticket_number'] = '' : json['ticket_number'].toString(), 
    ticket_id : json['id'].toString(),
    assigned_user: json['user_id'] == false ? json['user_id'] = 'false' : json['user_id'].toString(),
    check_in: json['check_in'] == false ? json['check_in'] = '' : json['check_in'],
    check_out: json['check_out'] == false ? json['check_out'] = '' : json['check_out'],
    check_in_address: json['check_in_address'] == false ? json ['check_in_address'] = '' : json['check_in_address'].toString(),
    check_out_address: json['check_out_address'] == false ? json ['check_out_address'] = '' : json['check_out_address'].toString(),
    created_date: json['create_date'] == false ? json['create_date'] = '' : json['create_date'].toString(),
    subject: json['subject'] == false ? json['subject'] = '' : json['subject'].toString(),
    rating: json['rating'] == null ? json['rating'] = '0' : json['rating'].toString(),
    partner_id: json['partner_id'] == false || json['partner_id'] == null  ? '' : json['partner_id'][0].toString(),
    partner_name: json['partner_id'] == false || json['partner_id'] == null ? '' : json['partner_id'][1].toString(),
    equipment_location: json['equipment_location'] == false ? json['equipment_location'] = '' : json['equipment_location'].toString(),
    equipment_user: json['user'] == false ? json['user'] = '' : json['user'].toString(),
    reported_by: json['person_name'] == false ? json['person_name'] = '' : json['person_name'].toString(),
    contact_num: json['contact_num'] == false ? json['contact_num'] = '' : json['contact_num'].toString(),
    email: json['email'] == false ? json['email'] = '' : json['email'].toString(),
    department: json['department'] == false ? json['department'] = '' : json['department'].toString(),
    address: json['address'] == false ? json['address'] = '' : json['address'].toString(),
    category_name: json['category'] == false || json['category'] == null || json['category'].length < 2 ? '' : json['category'][1].toString(),
    subcategory_name: json['sub_category_id'] == false || json['sub_category_id'] == null || json['sub_category_id'].length < 2 ? '' : json['sub_category_id'][1].toString(),
    problem_name: json['problem'] == false || json['problem'] == null || json['problem'].length < 2 ? '' : json['problem'][1].toString(),
    open_case : json['open_case'] == false || json ['open_case'] == null ? json ['open_case'] = '' : json ['open_case'].toString(),
    itemname : json['item'] == false || json ['item'] == null || json ['item'].length < 2 ? '' : json ['item'][1].toString(),
    close_comment : json['close_comment'] == false || json ['close_comment'] == null ? json ['close_comment'] = '' : json ['close_comment'].toString(),
    cmform_number : json['cmform'] == false || json ['cmform'] == null ? json ['cmform'] = '' : json ['cmform'].toString(),
  );   
}