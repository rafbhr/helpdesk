class ResPartner {
  final num partner_latitude;
  final num partner_longitude;
  
  const ResPartner({
    required this.partner_latitude, required this.partner_longitude
  });
  static ResPartner fromJson(Map<String, dynamic> json) => ResPartner(

    partner_latitude: json['partner_latitude'] == null ? json ['partner_latitude'] = null : json['partner_latitude'], 
    partner_longitude: json['partner_longitude'] == null ? json ['partner_longitude'] = null : json['partner_longitude'], 
  );
}