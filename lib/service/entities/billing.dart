class Billing {
  Billing({
    required this.id,
  });

  int id;

  factory Billing.fromJson(Map<String, dynamic> json) => Billing(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
