import 'package:fanfan/store/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageToken {
  token,
}

initialize() async {
  // 获取持久化缓存的实例
  final SharedPreferences storage = await SharedPreferences.getInstance();
  // 获取持久化存储的token
  final token = storage.getString(describeEnum(StorageToken.token)) ?? '';
  // token 不存在直接退出
  if (token.isEmpty) return;

  print(token);

  final userProfile = UserProfile();
  // 设置token
  userProfile.setToken(token);
  // 换用户信息
  userProfile.authorize();
}

Future<void> reinitialize(String? token) async {
  if ((token ?? '').isEmpty) return;

  // 获取持久化缓存的实例
  final SharedPreferences storage = await SharedPreferences.getInstance();
  // 存储 token
  storage.setString(describeEnum(StorageToken.token), token!);

  final userProfile = UserProfile();
  // 设置token
  userProfile.setToken(token);
  // 换用户信息
  userProfile.authorize();
}
