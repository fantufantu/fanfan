class Registered {
  Registered({
    required this.register,
  });

  String register;

  factory Registered.fromJson(Map<String, dynamic> json) => Registered(
        register: json["register"],
      );

  Map<String, dynamic> toJson() => {
        "register": register,
      };
}
