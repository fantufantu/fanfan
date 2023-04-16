class Application {
  /// 单例
  static Application? _instance;

  factory Application() => _instance ??= Application._internal();

  Application._internal();
}
