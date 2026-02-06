import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:bmta_app/core/theme/app_theme.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // 실제 Firebase Auth 연동은 금지되어 있으므로,
    // 현재는 콘솔 로그와 간단한 SnackBar만 노출한다.
    // ignore: avoid_print
    print('로그인 시도: email=$email, length=${password.length}');

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('로그인 버튼이 눌렸습니다. (UI 프로토타입 상태)'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(context.spacing.x2),
        ),
      );
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(LucideIcons.helpCircle),
          color: theme.colorScheme.outline,
          tooltip: '도움말',
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
    required this.onTogglePasswordVisibility,
    required this.onLoginPressed,
  });

  final AppSpacing spacing;
  final AppRadii radii;
  final ColorScheme colorScheme;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
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
              onPressed: onLoginPressed,
              icon: const Icon(LucideIcons.logIn),
              label: const Text('이메일로 로그인'),
            ),
          ),
          SizedBox(height: spacing.x2), // 16
          OutlinedButton.icon(
            onPressed: () {
              // ignore: avoid_print
              print('회원가입 클릭');
            },
            icon: const Icon(LucideIcons.userPlus),
            label: const Text('처음 오셨나요? 회원가입'),
          ),
          SizedBox(height: spacing.x3), // 24
          _LoginHint(spacing: spacing),
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
          '이동 중에도\n끊기지 않는 이야기',
          style: theme.textTheme.titleLarge?.copyWith(
            height: 1.1,
          ),
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

class _LoginHint extends StatelessWidget {
  const _LoginHint({
    required this.spacing,
  });

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(spacing.x2), // 16
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.04),
        borderRadius: theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape! as RoundedRectangleBorder).borderRadius
            : BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.info,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: spacing.x1), // 8
          Expanded(
            child: Text(
              '로그인은 이메일 인증 기반으로 진행되며, 실제 서비스에서는 이메일 인증 절차가 추가됩니다.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

