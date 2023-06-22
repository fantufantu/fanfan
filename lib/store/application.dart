import 'package:flutter/foundation.dart';

class Application with ChangeNotifier, DiagnosticableTreeMixin {
  /// 单例
  static Application? _instance;

  factory Application() => _instance ??= Application._internal();

  Application._internal();
}
