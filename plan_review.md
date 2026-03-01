# Plan.md 검토 보고서

## 📋 검토 개요

**검토 대상**: `plan.md` (SCR-002 회원가입 화면 작업 계획)  
**검토 기준**: 
- 로직 문제 여부
- 향후 확장성 관점
- 프로젝트 구조 일관성
- 메뉴 설명서와의 일치 여부
- 작업 지침 준수 여부

---

## ✅ 잘 설계된 부분

### 1. 프로젝트 구조 일관성
- ✅ `lib/views/login/signup_view.dart` 경로가 기존 구조와 일치
- ✅ 로그인 화면(`login_view.dart`)과 동일한 패턴 사용
- ✅ `_LabeledField`, `_Header` 등 공통 위젯 재사용 계획

### 2. 디자인 시스템 준수
- ✅ Connect Blue (#2563EB) 컬러 사용
- ✅ 8px 간격 시스템 (`context.spacing`) 활용
- ✅ 16px 라운드 (`context.radii.rMd`) 적용
- ✅ `lucide_icons` 패키지 사용

### 3. 상태 관리 구조
- ✅ `TextEditingController` 적절히 사용
- ✅ `dispose()` 메서드로 리소스 정리 계획
- ✅ `setState`를 통한 상태 업데이트

---

## ⚠️ 발견된 문제점 및 개선 사항

### 🔴 심각한 문제 (즉시 수정 필요)

#### 1. 비밀번호 검증 규칙 불일치
**문제점:**
- Plan.md: 비밀번호 6자 이상 검증
- 메뉴 설명서: "비밀번호는 영문과 숫자 조합으로 8글자 이상(특수기호도 가능함)"

**영향:**
- 요구사항과 불일치로 인한 재작업 필요
- 보안 정책 위반 가능성

**해결 방안:**
```dart
// 수정 전
bool _validatePassword(String password) {
  return password.length >= 6;
}

// 수정 후
bool _validatePassword(String password) {
  if (password.length < 8) return false;
  // 영문과 숫자 조합 체크 (특수기호도 허용)
  final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
  final hasNumber = RegExp(r'[0-9]').hasMatch(password);
  return hasLetter && hasNumber;
}
```

#### 2. 이메일 정규식 패턴 문제
**문제점:**
```dart
RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
```
- 이 정규식은 일부 유효한 이메일을 거부할 수 있음
- 예: `user.name+tag@example.co.uk` 같은 형식 처리 불가

**해결 방안:**
```dart
// 더 포괄적인 이메일 정규식 사용
bool _validateEmail(String email) {
  final regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return email.isNotEmpty && regex.hasMatch(email);
}
```

또는 Flutter의 내장 검증 사용:
```dart
// 더 간단하고 안전한 방법
bool _validateEmail(String email) {
  return email.isNotEmpty && 
         email.contains('@') && 
         email.split('@').length == 2 &&
         email.split('@')[1].contains('.');
}
```

#### 3. 인증번호 입력 필드 레이아웃 문제
**문제점:**
- Plan.md에서 "이메일 입력 필드 우측에 인증번호 발송 버튼"이라고 했지만
- 실제 구현 시 레이아웃이 복잡해질 수 있음
- Row 내에서 TextField와 Button을 배치할 때 반응형 이슈 발생 가능

**해결 방안:**
```dart
// 더 나은 레이아웃 구조
Column(
  children: [
    Row(
      children: [
        Expanded(
          child: TextField(...), // 이메일 입력
        ),
        SizedBox(width: spacing.x1),
        OutlinedButton(...), // 인증번호 발송
      ],
    ),
    if (_isVerificationCodeSent)
      Row(
        children: [
          Expanded(
            child: TextField(...), // 인증번호 입력
          ),
          SizedBox(width: spacing.x1),
          OutlinedButton(...), // 확인
        ],
      ),
  ],
)
```

### 🟡 중간 문제 (개선 권장)

#### 4. 유효성 검사 타이밍 문제
**문제점:**
- Plan.md에서 `onChanged`로 실시간 검증을 하되, 초기에는 검증하지 않음
- 사용자가 입력을 시작하기 전에는 오류 메시지가 표시되지 않아야 함

**해결 방안:**
```dart
// 각 필드별로 "터치 여부" 상태 추가
bool _emailTouched = false;
bool _nicknameTouched = false;
bool _passwordTouched = false;

// onChanged에서
void _onEmailChanged(String value) {
  setState(() {
    _emailTouched = true;
    _isEmailValid = _validateEmail(value);
  });
}

// TextField의 errorText
errorText: _emailTouched && !_isEmailValid 
    ? '올바른 이메일 형식을 입력하세요' 
    : null,
```

#### 5. 인증번호 확인 후 상태 관리
**문제점:**
- Plan.md에서 인증 완료 후 "인증번호 입력란 비활성화"라고 했지만
- 사용자가 잘못 입력했다가 다시 수정할 수 있는 경우를 고려하지 않음

**해결 방안:**
```dart
// 인증 완료 후에도 재확인 가능하도록
bool _isEmailVerified = false;

void _verifyCode() {
  final code = _verificationCodeController.text.trim();
  
  if (_validateVerificationCode(code)) {
    setState(() {
      _isVerificationCodeValid = true;
      _isEmailVerified = true;
      // 인증번호 필드는 비활성화하지 않고 읽기 전용으로
    });
  } else {
    setState(() {
      _isVerificationCodeValid = false;
    });
  }
}
```

#### 6. 에러 메시지 표시 방식
**문제점:**
- Plan.md에서 `errorText`만 언급했지만, 메뉴 설명서에는 "빨간색 텍스트로 규칙 문구 노출"이라고 명시

**해결 방안:**
```dart
// TextField 아래에 별도 오류 메시지 위젯 추가
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    TextField(...),
    if (_emailTouched && !_isEmailValid)
      Padding(
        padding: EdgeInsets.only(top: spacing.x0_5, left: spacing.x1),
        child: Text(
          '올바른 이메일 형식을 입력하세요',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
  ],
)
```

### 🟢 경미한 문제 (선택적 개선)

#### 7. 닉네임 중복 체크 언급 부족
**문제점:**
- Plan.md에서 "서버 연동 전이므로 클라이언트 측 검증만 수행"이라고 했지만
- 향후 서버 연동 시 어떻게 확장할지 계획이 없음

**개선 제안:**
```dart
// 향후 확장을 고려한 구조
Future<bool> _checkNicknameAvailability(String nickname) async {
  // TODO: 서버 API 연동 시 구현
  // 현재는 클라이언트 측 검증만
  return _validateNickname(nickname);
}
```

#### 8. 약관 동의 체크박스 위치
**문제점:**
- Plan.md에서 약관 동의 체크박스 위치가 명확하지 않음
- 메뉴 설명서에는 "약관 동의 내용과 체크박스"라고 되어 있어 내용도 함께 표시해야 할 수 있음

**개선 제안:**
```dart
// 약관 내용을 접을 수 있는 형태로
ExpansionTile(
  title: Text('이용약관 및 개인정보 처리방침'),
  children: [
    // 약관 내용 (추후 추가)
  ],
  trailing: Checkbox(...),
)
```

---

## 🔮 향후 확장성 관점 검토

### ✅ 잘 고려된 부분

1. **Firebase 연동 준비**
   - Plan.md에서 "TODO: Firebase 회원가입 로직 (다음 단계)" 명시
   - 현재 구조가 Firebase Auth 연동에 적합함

2. **상태 관리 확장 가능성**
   - 현재는 `setState` 사용하지만, 향후 Riverpod으로 전환 가능한 구조
   - `TextEditingController`는 그대로 유지 가능

3. **유효성 검사 로직 분리**
   - 각 필드별 검증 함수가 분리되어 있어 테스트 및 확장 용이

### ⚠️ 확장성 개선 제안

#### 1. 유효성 검사 로직을 별도 클래스로 분리
**현재 구조:**
```dart
// SignupView 내부에 모든 검증 로직
bool _validateEmail(String email) { ... }
bool _validatePassword(String password) { ... }
```

**개선 제안:**
```dart
// lib/core/validators/signup_validator.dart
class SignupValidator {
  static bool validateEmail(String email) { ... }
  static bool validatePassword(String password) { ... }
  static bool validateNickname(String nickname) { ... }
  
  static String? emailError(String email) {
    if (email.isEmpty) return '이메일을 입력하세요';
    if (!_validateEmail(email)) return '올바른 이메일 형식을 입력하세요';
    return null;
  }
}
```

**장점:**
- 재사용 가능
- 테스트 용이
- 다른 화면(예: 이메일 변경)에서도 사용 가능

#### 2. 인증번호 발송 로직을 Service로 분리
**현재 구조:**
```dart
// SignupView 내부에 Mock 로직
void _sendVerificationCode() {
  // Mock 처리
}
```

**개선 제안:**
```dart
// lib/services/auth_service.dart
class AuthService {
  Future<String> sendVerificationCode(String email) async {
    // 현재: Mock 처리
    // 향후: 실제 이메일 발송 API 호출
    await Future.delayed(Duration(seconds: 1));
    return '123456';
  }
  
  Future<bool> verifyCode(String email, String code) async {
    // 현재: 하드코딩된 값과 비교
    // 향후: 서버에서 검증
    return code == '123456';
  }
}
```

**장점:**
- Mock → 실제 API 전환이 쉬움
- 다른 화면(이메일 변경 등)에서도 재사용
- 테스트 용이

#### 3. 폼 상태를 별도 클래스로 관리
**현재 구조:**
```dart
// 여러 bool 변수로 상태 관리
bool _isEmailValid = false;
bool _isVerificationCodeValid = false;
bool _isNicknameValid = false;
bool _isPasswordValid = false;
bool _isTermsAgreed = false;
```

**개선 제안:**
```dart
// lib/models/signup_form_state.dart
class SignupFormState {
  final String email;
  final String verificationCode;
  final String nickname;
  final String password;
  final bool isTermsAgreed;
  
  final bool isEmailVerified;
  final bool isVerificationCodeSent;
  
  // Validation states
  final bool isEmailValid;
  final bool isVerificationCodeValid;
  final bool isNicknameValid;
  final bool isPasswordValid;
  
  bool get canSubmit => 
    isEmailValid &&
    isVerificationCodeValid &&
    isNicknameValid &&
    isPasswordValid &&
    isTermsAgreed;
    
  SignupFormState copyWith({...}) { ... }
}
```

**장점:**
- 상태 관리가 명확해짐
- Riverpod으로 전환 시 용이
- 테스트 용이

#### 4. 네비게이션 로직 개선
**현재 구조:**
```dart
// login_view.dart에서 직접 Navigator.push
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const SignupView()),
  );
},
```

**개선 제안:**
```dart
// lib/core/routes/app_routes.dart
class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}

// 사용
Navigator.pushNamed(context, AppRoutes.signup);
```

**장점:**
- 라우팅 관리가 중앙화됨
- 딥링크 처리 용이
- 네비게이션 로직 테스트 용이

---

## 📝 메뉴 설명서와의 일치 여부

### ✅ 일치하는 부분
- 이메일 인증 플로우
- 닉네임 형식 (2~10자, 한글/영문/숫자)
- 약관 동의 필수
- 유효성 검사 및 오류 표시

### ❌ 불일치하는 부분

1. **비밀번호 규칙**
   - Plan.md: 6자 이상
   - 메뉴 설명서: 8자 이상 + 영문+숫자 조합

2. **인증 완료 후 UI 상태**
   - Plan.md: "인증번호 입력란 비활성화"
   - 메뉴 설명서: "인증번호와 이메일 입력필드는 전부 비활성화되고 인증이 완료되었습니다. 라는 마이크로텍스트 노출"
   - → Plan.md에 마이크로텍스트 표시가 명시되어 있지만, 이메일 필드 비활성화는 언급되지 않음

3. **회원가입 완료 후 동작**
   - Plan.md: "로그인 화면으로 돌아가기" (Navigator.pop)
   - 메뉴 설명서: "회원가입이 완료되었습니다. 라는 문구 노출되고 로그인 페이지로 이동"
   - → 일치하지만, 문구 표시 후 이동하는 타이밍이 명확하지 않음

---

## 🛠️ 작업 지침 준수 여부

### ✅ 준수하는 부분
- ✅ 폴더 구조: `lib/views/login/` 사용
- ✅ 디자인 시스템: Connect Blue, 8px 간격, 16px 라운드
- ✅ 아이콘: `lucide_icons` 패키지 사용
- ✅ 한글 주석 포함 계획

### ⚠️ 개선 필요 부분

1. **하드코딩된 스타일**
   - Plan.md에서 특별히 언급하지 않았지만, 작업 지침에 "하드코딩된 스타일을 개별 위젯에 직접 넣지 않는다"고 명시
   - → 모든 색상, 간격은 `app_theme.dart`에서 참조해야 함

2. **Riverpod 사용**
   - 작업 지침: "flutter_riverpod 사용을 권장"
   - Plan.md: 현재는 `setState` 사용, 향후 확장 고려 필요
   - → 현재 단계에서는 문제없지만, 향후 전환 계획 명시 필요

---

## 🎯 종합 개선 권장 사항

### 우선순위 1 (즉시 수정)
1. ✅ 비밀번호 검증 규칙을 8자 이상 + 영문+숫자 조합으로 변경
2. ✅ 이메일 정규식 패턴 개선
3. ✅ 인증 완료 후 이메일 필드도 비활성화 및 마이크로텍스트 표시

### 우선순위 2 (개선 권장)
4. ✅ 유효성 검사 타이밍 개선 (터치 여부 추적)
5. ✅ 에러 메시지 표시 방식 개선 (빨간색 텍스트)
6. ✅ 인증번호 입력 필드 레이아웃 구조 개선

### 우선순위 3 (향후 확장 고려)
7. ✅ 유효성 검사 로직을 별도 클래스로 분리
8. ✅ 인증번호 발송 로직을 Service로 분리
9. ✅ 폼 상태를 별도 클래스로 관리
10. ✅ 네비게이션 로직을 중앙화

---

## 📊 검토 결과 요약

| 항목 | 상태 | 비고 |
|------|------|------|
| 로직 문제 | ⚠️ | 비밀번호 규칙, 이메일 정규식 수정 필요 |
| 확장성 | ✅ | 기본 구조는 양호, 일부 개선 권장 |
| 프로젝트 구조 일관성 | ✅ | 기존 구조와 잘 일치 |
| 메뉴 설명서 일치 | ⚠️ | 비밀번호 규칙 불일치 |
| 작업 지침 준수 | ✅ | 대부분 준수, 하드코딩 주의 |

**전체 평가**: ⭐⭐⭐⭐ (4/5)
- 기본 구조와 계획은 잘 수립되어 있음
- 몇 가지 규칙 불일치와 확장성 개선 사항이 있으나, 전반적으로 양호
- 우선순위 1 항목만 수정하면 바로 구현 가능

---

**검토일**: 2026. 02. 25  
**검토자**: AI Assistant
