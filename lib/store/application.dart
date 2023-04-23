import 'package:flutter/foundation.dart';

class Application with ChangeNotifier, DiagnosticableTreeMixin {
  /// 单例
  static Application? _instance;

  /// 应用初始化完成
  bool _isReady = false;

  get isReady {
    return _isReady;
  }

  factory Application() => _instance ??= Application._internal();

  Application._internal();

  ready() {
    _isReady = true;

    // 消息触达
    notifyListeners();
  }
}
