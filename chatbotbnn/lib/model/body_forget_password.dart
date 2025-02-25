class BodyForgetPassword {
  String? passwordHash;
  String? newPassword;
  String? newConfirmPassword;
  String? username;
  String? userId;

  BodyForgetPassword(
      {this.passwordHash,
      this.newPassword,
      this.newConfirmPassword,
      this.username,
      this.userId});

  BodyForgetPassword.fromJson(Map<String, dynamic> json) {
    passwordHash = json['password_hash'];
    newPassword = json['new_password'];
    newConfirmPassword = json['new_confirm_password'];
    username = json['username'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password_hash'] = passwordHash;
    data['new_password'] = newPassword;
    data['new_confirm_password'] = newConfirmPassword;
    data['username'] = username;
    data['user_id'] = userId;
    return data;
  }
}
