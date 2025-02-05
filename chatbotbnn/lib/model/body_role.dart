class BodyRole {
  int? pageIndex;
  String? pageSize;
  String? searchText;
  String? userId;

  BodyRole({this.pageIndex, this.pageSize, this.searchText, this.userId});

  BodyRole.fromJson(Map<String, dynamic> json) {
    pageIndex = json['page_index'];
    pageSize = json['page_size'];
    userId = json['user_id'];
    searchText = json['search_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_index'] = pageIndex;
    data['page_size'] = pageSize;
    data['user_id'] = userId;
    data['search_text'] = searchText;
    return data;
  }
}
