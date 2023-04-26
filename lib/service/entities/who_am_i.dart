class WhoAmI {
  WhoAmI({
    required this.id,
    required this.username,
    required this.emailAddress,
    this.avatar,
  });

  int id;
  String username;
  String emailAddress;
  String? avatar;

  factory WhoAmI.fromJson(Map<String, dynamic> json) => WhoAmI(
        id: json["id"],
        username: json["username"],
        emailAddress: json["emailAddress"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "emailAddress": emailAddress,
        "avatar": avatar,
      };

  /// 用户名简称
  get nickname {
    return '用户 ${username.substring(0, 6)}';
  }
}
