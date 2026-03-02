import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../views/login/login_view.dart';

/// 로그인 가드 유틸리티 함수
/// 
/// 특정 기능 접근 시 로그인 여부를 확인하고,
/// 비로그인 상태일 경우 Alert 팝업을 표시한 후 LoginView로 이동시킵니다.
/// 
/// 반환값:
/// - `true`: 로그인 상태 (기능 사용 가능)
/// - `false`: 비로그인 상태 (Alert 팝업 표시됨)
Future<bool> checkLoginAndShowDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final authState = ref.read(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        // 비로그인 상태: Alert 팝업 표시
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('로그인 필요'),
            content: const Text('회원만 이용할 수 있는 서비스입니다. 로그인 페이지로 이동할게요.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
        return false;
      }
      return true; // 로그인 상태
    },
    loading: () {
      // 로딩 중이면 로그인하지 않은 것으로 간주 (안전한 선택)
      return false;
    },
    error: (_, __) {
      // 에러 발생 시 로그인하지 않은 것으로 간주 (안전한 선택)
      return false;
    },
  );
}
