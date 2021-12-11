class Meta {
  int statusCode;
  String statusMsg;

  Meta({required this.statusCode, required this.statusMsg});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(statusCode: json['statusCode'], statusMsg: json['statusMsg']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['statusMsg'] = this.statusMsg;
    return data;
  }
}
