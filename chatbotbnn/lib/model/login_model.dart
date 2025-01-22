class LoginModel {
  String? userId;
  String? username;
  String? email;
  String? passwordHash;
  String? fullName;
  String? picture;
  String? role;
  int? active;
  String? token;

  LoginModel(
      {this.userId,
      this.username,
      this.email,
      this.passwordHash,
      this.fullName,
      this.picture,
      this.role,
      this.active,
      this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    email = json['email'];
    passwordHash = json['password_hash'];
    fullName = json['full_name'];
    picture = json['picture'];
    role = json['role'];
    active = json['active'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['password_hash'] = passwordHash;
    data['full_name'] = fullName;
    data['picture'] = picture;
    data['role'] = role;
    data['active'] = active;
    data['token'] = token;
    return data;
  }
}
