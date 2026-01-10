class User {
  String? userId;
  String? userEmail;
  String? userName;
  String? userPhone;
  String? userPassword;
  String? userImage;
  String? userRegdate;

  User(
      {this.userId,
      this.userEmail,
      this.userName,
      this.userPhone,
      this.userPassword,
      this.userImage,
      this.userRegdate});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['email'];
    userName = json['name'];
    userPhone = json['phone'];
    userPassword = json['password'];
    userImage = json['image'];
    userRegdate = json['reg_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['email'] = userEmail;
    data['name'] = userName;
    data['phone'] = userPhone;
    data['password'] = userPassword;
    data['image'] = userImage;
    data['reg_date'] = userRegdate;
    return data;
  }
}
