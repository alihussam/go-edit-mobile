class MetaData {
  int totalDocuments;
  int page;
  int limit;

  MetaData({this.totalDocuments, this.page, this.limit});

  MetaData.fromJson(Map<String, dynamic> json) {
    print(json);
    totalDocuments = json['totalDocuments'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDocuments'] = this.totalDocuments;
    data['page'] = this.page;
    data['limit'] = this.limit;
    return data;
  }
}
