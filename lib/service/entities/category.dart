class Category {
  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  /// 分类id
  int id;

  /// 分类名称
  String name;

  /// 分类icon
  String icon;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
      };
}
