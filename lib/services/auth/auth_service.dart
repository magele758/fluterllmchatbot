import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';
import '../../config/app_config.dart';
import '../storage/local_storage.dart';

/// Service for handling user authentication
class AuthService {
  /// Validate authentication token
  Future<bool> validateToken() async {
    try {
      // 直接返回false，强制进入登录页面
      return false;

      // 以下是原代码
      /*
      final token = await LocalStorage.getToken();
      if (token == null) return false;

      // Implement actual token validation with WeChat API
      // This is a placeholder for demo purposes
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
      */
    } catch (e) {
      debugPrint('Token validation error: $e');
      return false;
    }
  }

  /// Login with WeChat
  Future<User?> loginWithWeChat() async {
    try {
      // Implement actual WeChat login with SDK
      // This is a placeholder for demo purposes
      await Future.delayed(const Duration(seconds: 1));

      // Simulate WeChat login response
      final mockWeChatUser = {
        'id': 'wx_${_generateRandomString(10)}',
        'name': 'WeChat User',
        'avatar': 'https://via.placeholder.com/150',
      };

      // Create user from WeChat data
      final user = User.fromWechat(
        id: mockWeChatUser['id']!,
        name: mockWeChatUser['name']!,
        avatarUrl: mockWeChatUser['avatar'],
        wechatUserId: mockWeChatUser['id']!,
      );

      // Save auth token
      await LocalStorage.saveToken(_generateRandomString(32));

      return user;
    } catch (e) {
      debugPrint('WeChat login error: $e');
      return null;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      // Implement actual WeChat logout
      // This is a placeholder for demo purposes
      await Future.delayed(const Duration(milliseconds: 500));

      // Clear token and user data
      await LocalStorage.clearUserData();
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  /// Generate a random string for mock IDs and tokens
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}