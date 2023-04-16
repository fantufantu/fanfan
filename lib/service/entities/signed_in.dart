class SignedIn {
  SignedIn({
    required this.login,
  });

  String login;

  factory SignedIn.fromJson(Map<String, dynamic> json) => SignedIn(
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
      };
}
