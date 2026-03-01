import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:bmta_app/core/theme/app_theme.dart';

/// SCR-002: 회원가입 화면 UI
///
/// - 로그인 화면과 동일한 디자인 시스템 적용
/// - 이메일 인증 및 유효성 검사 포함
/// - 이번 작업에서는 Firebase Auth 연동은 구현하지 않음
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  // Controllers
  final _emailController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _obscurePassword = true;
  bool _isEmailVerified = false;
  bool _isVerificationCodeSent = false;
  bool _isTermsAgreed = false;

  // Validation states
  bool _isEmailValid = false;
  bool _isVerificationCodeValid = false;
  bool _isNicknameValid = false;
  bool _isPasswordValid = false;

  // Touch states (터치 여부 추적)
  bool _emailTouched = false;
  bool _verificationCodeTouched = false;
  bool _nicknameTouched = false;
  bool _passwordTouched = false;

  @override
  void dispose() {
    _emailController.dispose();
    _verificationCodeController.dispose();
    _nicknameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 유효성 검사 함수들
  bool _validateEmail(String email) {
    if (email.isEmpty) return false;
    // 개선된 이메일 정규식
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  bool _validateVerificationCode(String code) {
    // Mock: 하드코딩된 인증번호와 비교
    return code.trim() == '123456';
  }

  bool _validateNickname(String nickname) {
    if (nickname.isEmpty) return false;
    // 한글/영문/숫자 조합, 2~10글자
    final regex = RegExp(r'^[가-힣a-zA-Z0-9]{2,10}$');
    return regex.hasMatch(nickname);
  }

  bool _validatePassword(String password) {
    if (password.length < 8) return false;
    // 영문과 숫자 조합 체크 (특수기호도 허용)
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }

  // 버튼 활성화 조건
  bool get _canSubmit {
    return _isEmailValid &&
        _isVerificationCodeValid &&
        _isNicknameValid &&
        _isPasswordValid &&
        _isTermsAgreed;
  }

  // 인증번호 발송
  void _sendVerificationCode() {
    final email = _emailController.text.trim();

    if (!_validateEmail(email)) {
      setState(() {
        _emailTouched = true;
        _isEmailValid = false;
      });
      return;
    }

    // Mock: 인증번호 발송
    setState(() {
      _isEmailValid = true;
      _isVerificationCodeSent = true;
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('인증번호 123456이 발송되었습니다'),
        ),
      );
    }
  }

  // 인증번호 확인
  void _verifyCode() {
    final code = _verificationCodeController.text.trim();

    setState(() {
      _verificationCodeTouched = true;
    });

    if (_validateVerificationCode(code)) {
      setState(() {
        _isVerificationCodeValid = true;
        _isEmailVerified = true;
      });
    } else {
      setState(() {
        _isVerificationCodeValid = false;
      });
    }
  }

  // 회원가입 완료
  void _onSignupPressed() {
    if (!_canSubmit) return;

    // TODO: Firebase 회원가입 로직 (다음 단계)
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원가입이 완료되었습니다. (UI 프로토타입 상태)'),
        ),
      );

      // 로그인 화면으로 돌아가기
      Navigator.pop(context);
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
                          _SignupCard(
                            spacing: spacing,
                            radii: radii,
                            colorScheme: colorScheme,
                            theme: theme,
                            emailController: _emailController,
                            verificationCodeController: _verificationCodeController,
                            nicknameController: _nicknameController,
                            passwordController: _passwordController,
                            obscurePassword: _obscurePassword,
                            isEmailVerified: _isEmailVerified,
                            isVerificationCodeSent: _isVerificationCodeSent,
                            isTermsAgreed: _isTermsAgreed,
                            isEmailValid: _isEmailValid,
                            isVerificationCodeValid: _isVerificationCodeValid,
                            isNicknameValid: _isNicknameValid,
                            isPasswordValid: _isPasswordValid,
                            emailTouched: _emailTouched,
                            verificationCodeTouched: _verificationCodeTouched,
                            nicknameTouched: _nicknameTouched,
                            passwordTouched: _passwordTouched,
                            canSubmit: _canSubmit,
                            onTogglePasswordVisibility: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            onEmailChanged: (value) {
                              setState(() {
                                _emailTouched = true;
                                _isEmailValid = _validateEmail(value);
                              });
                            },
                            onVerificationCodeChanged: (value) {
                              setState(() {
                                _verificationCodeTouched = true;
                                _isVerificationCodeValid = _validateVerificationCode(value);
                              });
                            },
                            onNicknameChanged: (value) {
                              setState(() {
                                _nicknameTouched = true;
                                _isNicknameValid = _validateNickname(value);
                              });
                            },
                            onPasswordChanged: (value) {
                              setState(() {
                                _passwordTouched = true;
                                _isPasswordValid = _validatePassword(value);
                              });
                            },
                            onTermsChanged: (value) {
                              setState(() {
                                _isTermsAgreed = value;
                              });
                            },
                            onSendVerificationCode: _sendVerificationCode,
                            onVerifyCode: _verifyCode,
                            onSignupPressed: _onSignupPressed,
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

/// Header 위젯 (로그인 화면과 동일)
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

/// 회원가입 카드 위젯
class _SignupCard extends StatelessWidget {
  const _SignupCard({
    required this.spacing,
    required this.radii,
    required this.colorScheme,
    required this.theme,
    required this.emailController,
    required this.verificationCodeController,
    required this.nicknameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isEmailVerified,
    required this.isVerificationCodeSent,
    required this.isTermsAgreed,
    required this.isEmailValid,
    required this.isVerificationCodeValid,
    required this.isNicknameValid,
    required this.isPasswordValid,
    required this.emailTouched,
    required this.verificationCodeTouched,
    required this.nicknameTouched,
    required this.passwordTouched,
    required this.canSubmit,
    required this.onTogglePasswordVisibility,
    required this.onEmailChanged,
    required this.onVerificationCodeChanged,
    required this.onNicknameChanged,
    required this.onPasswordChanged,
    required this.onTermsChanged,
    required this.onSendVerificationCode,
    required this.onVerifyCode,
    required this.onSignupPressed,
  });

  final AppSpacing spacing;
  final AppRadii radii;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final TextEditingController emailController;
  final TextEditingController verificationCodeController;
  final TextEditingController nicknameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isEmailVerified;
  final bool isVerificationCodeSent;
  final bool isTermsAgreed;
  final bool isEmailValid;
  final bool isVerificationCodeValid;
  final bool isNicknameValid;
  final bool isPasswordValid;
  final bool emailTouched;
  final bool verificationCodeTouched;
  final bool nicknameTouched;
  final bool passwordTouched;
  final bool canSubmit;
  final VoidCallback onTogglePasswordVisibility;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onVerificationCodeChanged;
  final ValueChanged<String> onNicknameChanged;
  final ValueChanged<String> onPasswordChanged;
  final ValueChanged<bool> onTermsChanged;
  final VoidCallback onSendVerificationCode;
  final VoidCallback onVerifyCode;
  final VoidCallback onSignupPressed;

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
          _SignupTitle(spacing: spacing),
          SizedBox(height: spacing.x3), // 24

          // 이메일 입력 필드 + 인증번호 발송 버튼
          _LabeledField(
            label: '이메일',
            spacing: spacing,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        enabled: !isEmailVerified,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: onEmailChanged,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.mail),
                          hintText: '이메일 주소를 입력하세요',
                          errorText: emailTouched && !isEmailValid
                              ? '올바른 이메일 형식을 입력하세요'
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.x1), // 8
                    OutlinedButton(
                      onPressed: isEmailVerified ? null : onSendVerificationCode,
                      child: const Text('인증번호 발송'),
                    ),
                  ],
                ),
                // 인증 완료 마이크로텍스트
                if (isEmailVerified)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.x0_5, left: spacing.x1),
                    child: Text(
                      '인증이 완료되었습니다.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                // 에러 메시지 (빨간색 텍스트)
                if (emailTouched && !isEmailValid && !isEmailVerified)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.x0_5, left: spacing.x1),
                    child: Text(
                      '올바른 이메일 형식을 입력하세요',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 인증번호 입력 필드 + 확인 버튼 (조건부 표시)
          if (isVerificationCodeSent) ...[
            SizedBox(height: spacing.x2), // 16
            _LabeledField(
              label: '인증번호',
              spacing: spacing,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: verificationCodeController,
                          enabled: !isEmailVerified,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          onChanged: onVerificationCodeChanged,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(LucideIcons.key),
                            hintText: '인증번호 6자리를 입력하세요',
                            counterText: '',
                            errorText: verificationCodeTouched &&
                                    !isVerificationCodeValid &&
                                    !isEmailVerified
                                ? '인증번호를 다시 확인해 주세요'
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.x1), // 8
                      OutlinedButton(
                        onPressed: isEmailVerified ? null : onVerifyCode,
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                  // 에러 메시지
                  if (verificationCodeTouched &&
                      !isVerificationCodeValid &&
                      !isEmailVerified)
                    Padding(
                      padding: EdgeInsets.only(top: spacing.x0_5, left: spacing.x1),
                      child: Text(
                        '인증번호를 다시 확인해 주세요',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          SizedBox(height: spacing.x2), // 16

          // 닉네임 입력 필드
          _LabeledField(
            label: '닉네임',
            spacing: spacing,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nicknameController,
                  maxLength: 10,
                  onChanged: onNicknameChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LucideIcons.user),
                    hintText: '닉네임을 입력하세요',
                    errorText: nicknameTouched && !isNicknameValid
                        ? '2~10자의 한글/영문/숫자만 사용 가능합니다'
                        : null,
                  ),
                ),
                // 에러 메시지
                if (nicknameTouched && !isNicknameValid)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.x0_5, left: spacing.x1),
                    child: Text(
                      '2~10자의 한글/영문/숫자만 사용 가능합니다',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: spacing.x2), // 16

          // 비밀번호 입력 필드
          _LabeledField(
            label: '비밀번호',
            spacing: spacing,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  onChanged: onPasswordChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LucideIcons.lock),
                    suffixIcon: IconButton(
                      onPressed: onTogglePasswordVisibility,
                      icon: Icon(
                        obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                      ),
                    ),
                    hintText: '비밀번호를 입력하세요',
                    errorText: passwordTouched && !isPasswordValid
                        ? '영문과 숫자 조합 8자 이상 입력하세요'
                        : null,
                  ),
                ),
                // 에러 메시지
                if (passwordTouched && !isPasswordValid)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.x0_5, left: spacing.x1),
                    child: Text(
                      '영문과 숫자 조합 8자 이상 입력하세요',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: spacing.x2), // 16

          // 이용약관 동의 체크박스
          Row(
            children: [
              Checkbox(
                value: isTermsAgreed,
                onChanged: (value) {
                  onTermsChanged(value ?? false);
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onTermsChanged(!isTermsAgreed);
                  },
                  child: Text(
                    '이용약관에 동의합니다 (필수)',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.x3), // 24

          // 회원가입 완료 버튼
          SizedBox(
            height: 56, // 7 * 8
            child: ElevatedButton.icon(
              onPressed: canSubmit ? onSignupPressed : null,
              icon: const Icon(LucideIcons.userPlus),
              label: const Text('회원가입 완료'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 회원가입 제목
class _SignupTitle extends StatelessWidget {
  const _SignupTitle({
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
          '이메일 인증으로 회원가입하고 전국의 타는 곳 이야기에 참여하세요.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// 라벨이 있는 입력 필드 (로그인 화면과 동일)
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
