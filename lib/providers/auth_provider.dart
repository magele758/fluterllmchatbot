import 'package:flutter/material.dart';
import '../models/user.dart';

/// 简化的验证提供器，无需登录
class AuthProvider extends ChangeNotifier {
  /// 当前用户
  User? _currentUser;

  /// 初始化状态
  bool _isInitializing = false;

  /// 获取当前用户
  User? get currentUser => _currentUser;

  /// 检查是否已登录
  bool get isLoggedIn => _currentUser != null;

  /// 检查是否正在初始化
  bool get isInitializing => _isInitializing;

  /// 错误消息（保留为null，仅为兼容旧代码）
  String? get errorMessage => null;

  /// 构造函数
  AuthProvider() {
    _initAuthState();
  }

  /// 初始化认证状态
  void _initAuthState() {
    try {
      // 创建一个伪用户，包含所有必需参数
      final now = DateTime.now();
      _currentUser = User(
        id: 'local_user',
        name: 'AI User',
        email: 'user@example.com',
        preferences: UserPreferences(),
        createdAt: now,
        lastLoginAt: now,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('初始化错误: $e');
      // 出错时确保有默认用户
      final now = DateTime.now();
      _currentUser = User(
        id: 'local_user',
        name: 'AI User',
        email: 'user@example.com',
        preferences: UserPreferences(),
        createdAt: now,
        lastLoginAt: now,
      );
      notifyListeners();
    }
  }

  /// 兼容旧代码的登录方法（仅作为空实现）
  Future<bool> loginWithWeChat() async {
    return true;
  }

  /// 登出方法（仅作为空实现）
  Future<void> logout() async {
    // 空实现，保留接口兼容性
  }
}