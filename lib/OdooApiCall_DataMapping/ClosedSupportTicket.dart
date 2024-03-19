class ClosedSupportTicket {
  final String ticket_number;
  final String status;

  const ClosedSupportTicket({required this.ticket_number, required this.status});

  static ClosedSupportTicket fromJson(Map<String, dynamic> json) => ClosedSupportTicket(
      status :json['state'][1].toString(),    
      ticket_number : json['ticket_number'] == false ? json['ticket_number'] = '' : json['ticket_number'].toString(),
  );   
}