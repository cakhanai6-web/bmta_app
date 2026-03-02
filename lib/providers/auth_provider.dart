import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase Auth 상태를 실시간으로 감시하는 Provider
/// 
/// - 로그인 시: User 객체 반환
/// - 로그아웃 시: null 반환
/// - 로딩/에러 상태도 자동 처리
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
