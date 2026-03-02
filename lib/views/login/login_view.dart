import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bmta_app/core/theme/app_theme.dart';
import 'package:bmta_app/views/main_scaffold.dart';
import 'package:bmta_app/views/feed/post_detail_view.dart';
import 'signup_view.dart';

/// SCR-001: 로그인 화면 UI
///
/// - 프로토타입 전반의 톤&매너(Connect Blue, 타원형 카드, 8px 그리드)를 따른다.
/// - 이번 작업에서는 Firebase Auth / 전역 상태 관리는 구현하지 않는다.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Firebase Auth 에러 메시지 한글화
  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return '등록되지 않은 이메일입니다';
      case 'wrong-password':
        return '비밀번호가 잘못되었습니다';
      case 'invalid-email':
        return '올바른 이메일 형식이 아닙니다';
      case 'user-disabled':
        return '비활성화된 계정입니다';
      case 'too-many-requests':
        return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요';
      case 'operation-not-allowed':
        return '이 작업은 허용되지 않습니다';
      case 'network-request-failed':
        return '네트워크 연결을 확인해주세요';
      default:
        return '로그인에 실패했습니다: ${e.message ?? e.code}';
    }
  }

  Future<void> _onLoginPressed() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이메일과 비밀번호를 입력하세요'),
          ),
        );
      }
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 성공 메시지
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인되었습니다'),
          ),
        );

        // 리턴 경로 확인 (RouteSettings arguments에서)
        final args = ModalRoute.of(context)?.settings.arguments;
        Map<String, dynamic>? returnData;

        if (args is Map<String, dynamic>) {
          returnData = args;
        }

        // 리턴 경로가 있으면 해당 경로로, 없으면 MainScaffold로
        if (returnData != null &&
            returnData['postId'] != null &&
            returnData['postTitle'] != null &&
            returnData['postContent'] != null) {
          // 상세페이지로 복귀
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailView(
                postId: returnData!['postId'] as String,
                postTitle: returnData['postTitle'] as String,
                postContent: returnData['postContent'] as String,
              ),
            ),
            (route) => route.isFirst, // 첫 화면(MainScaffold)까지만 유지
          );
        } else {
          // MainScaffold로 이동
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScaffold(),
            ),
            (route) => false, // 모든 이전 라우트 제거
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getFirebaseAuthErrorMessage(e);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류가 발생했습니다: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radii = context.radii;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.x2, // 16
              ),
              child: Column(
                children: [
                  SizedBox(height: spacing.x4), // 32
                  _Header(spacing: spacing),
                  SizedBox(height: spacing.x4),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: spacing.x4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _LoginCard(
                            spacing: spacing,
                            radii: radii,
                            colorScheme: colorScheme,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            obscurePassword: _obscurePassword,
                            isLoading: _isLoading,
                            onTogglePasswordVisibility: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            onLoginPressed: _onLoginPressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.spacing,
  });

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(spacing.x0_5), // 4
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'BMTA',
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(width: spacing.x1), // 8
        Text(
          '모든 타는 곳의 이야기',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.spacing,
    required this.radii,
    required this.colorScheme,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onLoginPressed,
  });

  final AppSpacing spacing;
  final AppRadii radii;
  final ColorScheme colorScheme;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing.x3), // 24
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radii.rMd,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.06),
            offset: const Offset(0, 12),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LoginTitle(spacing: spacing),
          SizedBox(height: spacing.x3), // 24
          _LabeledField(
            label: '이메일',
            spacing: spacing,
            child: TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(LucideIcons.mail),
                hintText: '이메일 주소를 입력하세요',
              ),
            ),
          ),
          SizedBox(height: spacing.x2), // 16
          _LabeledField(
            label: '비밀번호',
            spacing: spacing,
            child: TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(LucideIcons.lock),
                suffixIcon: IconButton(
                  onPressed: onTogglePasswordVisibility,
                  icon: Icon(
                    obscurePassword
                        ? LucideIcons.eyeOff
                        : LucideIcons.eye,
                  ),
                ),
                hintText: '비밀번호를 입력하세요',
              ),
            ),
          ),
          SizedBox(height: spacing.x2), // 16
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // ignore: avoid_print
                print('비밀번호 찾기 클릭');
              },
              child: const Text('비밀번호를 잊으셨나요?'),
            ),
          ),
          SizedBox(height: spacing.x3), // 24
          SizedBox(
            height: 56, // 7 * 8
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onLoginPressed,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(LucideIcons.logIn),
              label: Text(isLoading ? '처리 중...' : '이메일로 로그인'),
            ),
          ),
          SizedBox(height: spacing.x2), // 16
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignupView()),
              );
            },
            icon: const Icon(LucideIcons.userPlus),
            label: const Text('처음 오셨나요? 회원가입'),
          ),
        ],
      ),
    );
  }
}

class _LoginTitle extends StatelessWidget {
  const _LoginTitle({
    required this.spacing,
  });

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이동 중에도 끊기지 않는 이야기',
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.x1), // 8
        Text(
          '이메일로 로그인하고 전국의 타는 곳 이야기와 연결돼 보세요.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.spacing,
    required this.child,
  });

  final String label;
  final AppSpacing spacing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: spacing.x0_5, // 4
            bottom: spacing.x0_5,
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

