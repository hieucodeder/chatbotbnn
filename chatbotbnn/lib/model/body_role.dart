class BodyRole {
  int? pageIndex;
  String? pageSize;
  String? role;
  String? searchText;

  BodyRole({this.pageIndex, this.pageSize, this.role, this.searchText});

  BodyRole.fromJson(Map<String, dynamic> json) {
    pageIndex = json['page_index'];
    pageSize = json['page_size'];
    role = json['role'];
    searchText = json['search_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page_index'] = pageIndex;
    data['page_size'] = pageSize;
    data['role'] = role;
    data['search_text'] = searchText;
    return data;
  }
}
