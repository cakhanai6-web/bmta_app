import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'views/login/login_view.dart';
import 'views/main_scaffold.dart';

void main() async {
  // Flutter 엔진 초기화 보장
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ignore: avoid_print
    print('✅ BMTA: Firebase 연동 성공!');
  } catch (e) {
    // ignore: avoid_print
    print('❌ BMTA: Firebase 연동 실패 - $e');
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'BMTA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: authState.when(
        data: (user) {
          // 로그인 상태에 따라 화면 전환
          if (user != null) {
            return const MainScaffold();
          } else {
            return const LoginView();
          }
        },
        loading: () => Builder(
          builder: (context) {
            final spacing = context.spacing;
            final theme = Theme.of(context);
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: spacing.x2),
                    Text(
                      '인증 상태를 확인하는 중...',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        error: (error, stack) => Builder(
          builder: (context) {
            final spacing = context.spacing;
            final theme = Theme.of(context);
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(spacing.x3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.alertCircle,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      SizedBox(height: spacing.x2),
                      Text(
                        '인증 상태를 확인할 수 없습니다',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.x1),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: spacing.x3),
                      ElevatedButton(
                        onPressed: () {
                          // 앱 재시작 또는 에러 리포팅
                          // 현재는 단순히 다시 시도
                          ref.invalidate(authStateProvider);
                        },
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
