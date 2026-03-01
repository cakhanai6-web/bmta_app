# Firebase Authentication 연동 작업 계획

## 📋 작업 개요

**작업 ID**: Firebase Auth 연동  
**작업명**: Firebase Authentication을 연동하여 실제 회원가입, 로그인, 로그아웃 기능 구현  
**목표**: Firebase Authentication을 연동하여 실제 회원가입, 로그인, 로그아웃 기능을 구현하고, 앱 전체에서 사용자의 인증 상태에 따라 화면을 자동으로 전환한다.

---

## 🎯 작업 목표

1. Firebase Authentication 연동 (회원가입, 로그인, 로그아웃)
2. Riverpod을 사용한 전역 인증 상태 관리
3. 인증 상태에 따른 자동 화면 전환 (로그인 → 피드, 로그아웃 → 로그인)
4. 이메일 인증번호 Mock 처리 유지 (실제 발송은 추후 구현)

---

## 📁 변경/생성 파일 목록

### 생성 파일
- `lib/providers/auth_provider.dart` - Firebase Auth 상태 관리 (Riverpod)

### 수정 파일
- `lib/views/login/signup_view.dart` - Firebase 회원가입 연동
- `lib/views/login/login_view.dart` - Firebase 로그인 연동
- `lib/views/mypage/mypage_view.dart` - Firebase 로그아웃 연동
- `lib/main.dart` - 인증 상태에 따른 자동 라우팅
- `pubspec.yaml` - firebase_auth 패키지 추가

---

## ✅ 이번 작업에서 하는 것 (Do)

### 1. Firebase Auth 패키지 추가 (`pubspec.yaml`)

#### 1.1 의존성 추가
```yaml
dependencies:
  firebase_auth: ^5.3.1  # Firebase Authentication 패키지
```

**주의사항:**
- 기존 `firebase_core`는 이미 있음
- `flutter_riverpod`도 이미 있음
- `firebase_auth`만 추가하면 됨

### 2. 인증 상태 관리 Provider 구현 (`lib/providers/auth_provider.dart`)

#### 2.1 Riverpod Provider 생성
- `authStateChanges()` 스트림을 감시하는 Provider
- 사용자 로그인 상태를 실시간으로 파악
- `User?` 타입으로 반환 (로그인 시 User 객체, 로그아웃 시 null)

#### 2.2 구현 구조
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase Auth 상태를 실시간으로 감시하는 Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
```

#### 2.3 사용 방법
- `ConsumerWidget` 또는 `Consumer`를 사용하여 인증 상태 구독
- `ref.watch(authStateProvider)`로 현재 인증 상태 확인
- 로딩, 에러, 데이터 상태 모두 처리

### 3. 회원가입 기능 연동 (`lib/views/login/signup_view.dart`)

#### 3.1 기존 UI 유지
- 현재 구현된 UI는 그대로 유지
- 유효성 검사 로직도 그대로 유지
- Mock 인증번호 처리도 그대로 유지

#### 3.2 Firebase 회원가입 로직 추가
- `_onSignupPressed()` 메서드에 Firebase Auth 연동
- `FirebaseAuth.instance.createUserWithEmailAndPassword()` 사용
- 회원가입 성공 시:
  - `user.updateDisplayName(nickname)`으로 닉네임 저장
  - 성공 메시지 표시
  - 자동으로 로그인 상태가 되어 MainScaffold로 이동 (authStateProvider가 처리)
- 회원가입 실패 시:
  - 에러 메시지를 SnackBar로 표시
  - 중복 이메일 등의 에러는 간단한 메시지로 처리

#### 3.3 구현 예시
```dart
Future<void> _onSignupPressed() async {
  if (!_canSubmit) return;

  try {
    // Firebase 회원가입
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // 닉네임을 displayName에 저장
    await credential.user?.updateDisplayName(_nicknameController.text.trim());
    await credential.user?.reload();

    // 성공 메시지
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('회원가입이 완료되었습니다'),
        ),
      );
    }

    // authStateProvider가 자동으로 상태를 감지하여 MainScaffold로 이동
  } on FirebaseAuthException catch (e) {
    // 에러 처리
    String errorMessage = '회원가입에 실패했습니다';
    if (e.code == 'email-already-in-use') {
      errorMessage = '이미 사용 중인 이메일입니다';
    } else if (e.code == 'weak-password') {
      errorMessage = '비밀번호가 너무 약합니다';
    }

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
  }
}
```

### 4. 로그인 기능 연동 (`lib/views/login/login_view.dart`)

#### 4.1 기존 UI 유지
- 현재 구현된 UI는 그대로 유지
- 입력 필드와 버튼 구조 유지

#### 4.2 Firebase 로그인 로직 추가
- `_onLoginPressed()` 메서드에 Firebase Auth 연동
- `FirebaseAuth.instance.signInWithEmailAndPassword()` 사용
- 로그인 성공 시:
  - 자동으로 MainScaffold로 이동 (authStateProvider가 처리)
- 로그인 실패 시:
  - 에러 메시지를 SnackBar로 표시
  - 잘못된 이메일/비밀번호 등의 에러 처리

#### 4.3 구현 예시
```dart
Future<void> _onLoginPressed() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('이메일과 비밀번호를 입력하세요'),
      ),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // 성공 메시지 (선택적)
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('로그인되었습니다'),
        ),
      );
    }

    // authStateProvider가 자동으로 상태를 감지하여 MainScaffold로 이동
  } on FirebaseAuthException catch (e) {
    String errorMessage = '로그인에 실패했습니다';
    if (e.code == 'user-not-found') {
      errorMessage = '등록되지 않은 이메일입니다';
    } else if (e.code == 'wrong-password') {
      errorMessage = '비밀번호가 잘못되었습니다';
    } else if (e.code == 'invalid-email') {
      errorMessage = '올바른 이메일 형식이 아닙니다';
    }

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
  }
}
```

### 5. 로그아웃 기능 연동 (`lib/views/mypage/mypage_view.dart`)

#### 5.1 로그아웃 버튼 수정
- `_LogoutButton` 위젯의 `onPressed` 콜백 수정
- `FirebaseAuth.instance.signOut()` 호출
- 로그아웃 성공 시:
  - 자동으로 LoginView로 이동 (authStateProvider가 처리)

#### 5.2 구현 예시
```dart
// _LogoutButton 위젯 수정
TextButton(
  onPressed: () async {
    try {
      await FirebaseAuth.instance.signOut();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그아웃되었습니다'),
          ),
        );
      }

      // authStateProvider가 자동으로 상태를 감지하여 LoginView로 이동
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그아웃 중 오류가 발생했습니다: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  },
  child: Text('로그아웃'),
)
```

### 6. 자동 라우팅 구현 (`lib/main.dart`)

#### 6.1 MyApp을 ConsumerWidget으로 변경
- `StatelessWidget` → `ConsumerWidget`으로 변경
- `authStateProvider`를 구독하여 인증 상태 확인

#### 6.2 인증 상태에 따른 화면 전환
- 로그인 상태 (`user != null`): `MainScaffold` 표시
- 로그아웃 상태 (`user == null`): `LoginView` 표시
- 로딩 상태: 로딩 인디케이터 표시

#### 6.3 구현 구조
```dart
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
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Text('오류가 발생했습니다: $error'),
          ),
        ),
      ),
    );
  }
}
```

---

## ❌ 이번 작업에서 하지 않는 것 (Do NOT)

1. ❌ 실제 이메일 인증번호 발송
   - 인증번호 발송은 Mock 처리 유지 ("123456"으로 입력 시 인증 완료)
   - 실제 메일 발송 서버 연동은 추후 구현

2. ❌ 소셜 로그인 (Google, Apple)
   - 이메일 인증 방식에만 집중
   - 소셜 로그인은 추후 구현

3. ❌ 복잡한 에러 핸들링
   - 중복 이메일 등의 에러는 간단한 SnackBar로만 표시
   - 상세한 에러 페이지나 재시도 로직은 추후 구현

4. ❌ 닉네임 중복 체크 (서버 연동)
   - Firebase Auth의 displayName은 중복 허용
   - 서버 측 닉네임 중복 체크는 추후 구현

5. ❌ 이메일 인증 강제
   - Firebase Auth의 `emailVerified` 체크는 추후 구현
   - 현재는 이메일 인증번호 Mock 처리만 수행

---

## 🏗️ 구현 상세 계획

### Step 1: Firebase Auth 패키지 추가

#### 1.1 pubspec.yaml 수정
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Firebase: 백엔드 인프라
  firebase_core: ^3.8.1
  firebase_auth: ^5.3.1  # 추가

  # 상태 관리: Riverpod
  flutter_riverpod: ^2.5.1
  
  # ... 기타 의존성
```

#### 1.2 패키지 설치
```bash
flutter pub get
```

### Step 2: Auth Provider 생성

#### 2.1 파일 생성
- `lib/providers/auth_provider.dart` 생성
- 폴더가 없으면 생성: `lib/providers/`

#### 2.2 Provider 구현
```dart
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
```

### Step 3: SignupView 수정

#### 3.1 Import 추가
```dart
import 'package:firebase_auth/firebase_auth.dart';
```

#### 3.2 _onSignupPressed 메서드 수정
- 기존 Mock 처리 로직 제거
- Firebase Auth `createUserWithEmailAndPassword()` 호출
- 닉네임을 `updateDisplayName()`으로 저장
- 에러 처리 추가

#### 3.3 로딩 상태 관리
- 회원가입 진행 중 로딩 인디케이터 표시
- 버튼 비활성화로 중복 요청 방지

### Step 4: LoginView 수정

#### 4.1 Import 추가
```dart
import 'package:firebase_auth/firebase_auth.dart';
```

#### 4.2 _onLoginPressed 메서드 수정
- 기존 Mock 처리 로직 제거
- Firebase Auth `signInWithEmailAndPassword()` 호출
- 에러 처리 추가

#### 4.3 로딩 상태 관리
- 로그인 진행 중 로딩 인디케이터 표시
- 버튼 비활성화로 중복 요청 방지

### Step 5: MypageView 수정

#### 5.1 Import 추가
```dart
import 'package:firebase_auth/firebase_auth.dart';
```

#### 5.2 _LogoutButton 수정
- `_LogoutButton`을 StatefulWidget으로 변경하거나
- 콜백 함수로 로그아웃 로직 구현
- `FirebaseAuth.instance.signOut()` 호출

### Step 6: Main.dart 수정

#### 6.1 Import 추가
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/auth_provider.dart';
import 'views/login/login_view.dart';
import 'views/main_scaffold.dart';
```

#### 6.2 MyApp을 ConsumerWidget으로 변경
- `StatelessWidget` → `ConsumerWidget`
- `build` 메서드에 `WidgetRef ref` 파라미터 추가
- `ref.watch(authStateProvider)`로 인증 상태 구독

#### 6.3 화면 전환 로직
- `authStateProvider.when()` 사용
- 로그인 상태: `MainScaffold`
- 로그아웃 상태: `LoginView`
- 로딩 상태: `CircularProgressIndicator`
- 에러 상태: 에러 메시지 표시

---

## 🎨 UI/UX 고려사항

### 1. 로딩 상태 표시
- 회원가입/로그인 진행 중에는 버튼에 로딩 인디케이터 표시
- 또는 전체 화면에 로딩 오버레이 표시

### 2. 에러 메시지 표시
- SnackBar 사용 (app_theme.dart의 error 컬러 활용)
- 간단하고 명확한 메시지
- 예: "이미 사용 중인 이메일입니다", "비밀번호가 잘못되었습니다"

### 3. 성공 메시지
- 회원가입/로그인 성공 시 간단한 SnackBar 표시
- 자동으로 화면 전환되므로 메시지는 선택적

### 4. 디자인 시스템 준수
- 모든 메시지는 `app_theme.dart`의 컬러 사용
- 에러: `colorScheme.error`
- 성공: 기본 SnackBar 스타일

---

## 🧪 테스트 시나리오

### 시나리오 1: 회원가입 → 자동 로그인 → 피드 화면 진입
1. 앱 실행 → 로그인 화면 표시 확인
2. `[회원가입]` 버튼 클릭 → 회원가입 화면 이동
3. 이메일 입력: `test@example.com`
4. `[인증번호 발송]` 버튼 클릭 → Mock 처리 확인
5. 인증번호 입력: `123456`
6. `[확인]` 버튼 클릭 → 인증 완료 확인
7. 닉네임 입력: `테스트유저`
8. 비밀번호 입력: `password123` (8자 이상 + 영문+숫자)
9. 약관 동의 체크
10. `[회원가입 완료]` 버튼 클릭
11. Firebase 회원가입 성공 확인
12. 자동으로 MainScaffold(피드 화면)로 이동 확인
13. 로그인 상태 유지 확인

### 시나리오 2: 로그인 → 피드 화면 진입
1. 앱 실행 → 로그인 화면 표시
2. 이메일 입력: `test@example.com`
3. 비밀번호 입력: `password123`
4. `[이메일로 로그인]` 버튼 클릭
5. Firebase 로그인 성공 확인
6. 자동으로 MainScaffold(피드 화면)로 이동 확인

### 시나리오 3: 로그아웃 → 로그인 화면 복귀
1. 피드 화면에서 `[내정보]` 탭 클릭
2. `[로그아웃]` 버튼 클릭
3. Firebase 로그아웃 성공 확인
4. 자동으로 LoginView로 이동 확인
5. 로그인 상태 해제 확인

### 시나리오 4: 앱 재시작 시 로그인 상태 유지
1. 로그인 상태에서 앱 완전 종료
2. 앱 다시 실행
3. 로그인 화면 없이 바로 MainScaffold(피드 화면) 표시 확인
4. 이전 로그인 상태가 유지되는지 확인

### 시나리오 5: 에러 처리
1. 중복 이메일로 회원가입 시도
   - 에러 메시지: "이미 사용 중인 이메일입니다" 표시
   - 회원가입 실패 확인
2. 잘못된 비밀번호로 로그인 시도
   - 에러 메시지: "비밀번호가 잘못되었습니다" 표시
   - 로그인 실패 확인
3. 존재하지 않는 이메일로 로그인 시도
   - 에러 메시지: "등록되지 않은 이메일입니다" 표시
   - 로그인 실패 확인

---

## ✅ 완료 기준 체크리스트

- [ ] `pubspec.yaml`에 `firebase_auth` 패키지 추가 및 설치 완료
- [ ] `lib/providers/auth_provider.dart` 생성 및 구현 완료
- [ ] `signup_view.dart`에서 Firebase 회원가입 연동 완료
  - [ ] `createUserWithEmailAndPassword()` 호출
  - [ ] 닉네임을 `updateDisplayName()`으로 저장
  - [ ] 에러 처리 (중복 이메일 등)
- [ ] `login_view.dart`에서 Firebase 로그인 연동 완료
  - [ ] `signInWithEmailAndPassword()` 호출
  - [ ] 에러 처리 (잘못된 이메일/비밀번호 등)
- [ ] `mypage_view.dart`에서 Firebase 로그아웃 연동 완료
  - [ ] `signOut()` 호출
- [ ] `main.dart`에서 인증 상태에 따른 자동 라우팅 구현 완료
  - [ ] `ConsumerWidget`으로 변경
  - [ ] `authStateProvider` 구독
  - [ ] 로그인 상태: MainScaffold 표시
  - [ ] 로그아웃 상태: LoginView 표시
  - [ ] 로딩 상태: 로딩 인디케이터 표시
- [ ] 실제 이메일로 가입 후 로그인하면 '브타 피드' 화면으로 진입
- [ ] '내 정보'에서 [로그아웃]을 누르면 즉시 '로그인' 화면으로 이동
- [ ] 앱을 완전히 껐다 켜도, 이전에 로그인했다면 로그인 화면 없이 바로 피드가 나타남
- [ ] 이메일 인증번호 Mock 처리 유지 ("123456"으로 입력 시 인증 완료)
- [ ] 모든 에러 메시지는 SnackBar로 표시 (app_theme.dart의 error 컬러 사용)

---

## 📝 참고 사항

### 기존 개발된 내용
- ✅ `signup_view.dart`: UI 및 유효성 검사 완료 (Mock 처리)
- ✅ `login_view.dart`: UI 완료 (Mock 처리)
- ✅ `mypage_view.dart`: 로그아웃 버튼 UI 완료 (로직 미구현)
- ✅ `main.dart`: MainScaffold로 시작 (인증 체크 없음)
- ✅ `pubspec.yaml`: firebase_core, flutter_riverpod 이미 있음

### 이번 작업에서 변경할 부분
1. **signup_view.dart**: `_onSignupPressed()` 메서드에 Firebase Auth 연동
2. **login_view.dart**: `_onLoginPressed()` 메서드에 Firebase Auth 연동
3. **mypage_view.dart**: `_LogoutButton`의 `onPressed`에 Firebase Auth 연동
4. **main.dart**: `MyApp`을 `ConsumerWidget`으로 변경하고 인증 상태 구독
5. **auth_provider.dart**: 새로 생성

### 디자인 시스템
- **색상**: Connect Blue (#2563EB), Error Red (app_theme.dart 참조)
- **에러 메시지**: SnackBar 사용, `colorScheme.error` 배경색
- **성공 메시지**: 기본 SnackBar 스타일

### 코드 스타일
- Riverpod 패턴 준수
- Clean Code 원칙
- 한글 주석 포함 (주요 함수)
- 에러 처리는 간단하게 (복잡한 로직 제외)

---

## 🔄 작업 순서

1. `pubspec.yaml`에 `firebase_auth` 패키지 추가
2. `flutter pub get` 실행
3. `lib/providers/auth_provider.dart` 생성 및 구현
4. `lib/views/login/signup_view.dart` 수정 (Firebase 회원가입 연동)
5. `lib/views/login/login_view.dart` 수정 (Firebase 로그인 연동)
6. `lib/views/mypage/mypage_view.dart` 수정 (Firebase 로그아웃 연동)
7. `lib/main.dart` 수정 (인증 상태에 따른 자동 라우팅)
8. 테스트 및 검증

---

## 🚨 주의사항

### 1. 인증번호 Mock 처리 유지
- 이메일 인증번호 발송은 여전히 Mock 처리
- "123456" 입력 시 인증 완료로 처리
- 실제 이메일 발송은 추후 구현

### 2. 에러 처리 간소화
- 복잡한 에러 핸들링은 하지 않음
- SnackBar로 간단한 메시지만 표시
- 재시도 로직이나 상세 에러 페이지는 추후 구현

### 3. 닉네임 저장
- Firebase Auth의 `displayName`에 저장
- Firestore에 별도 저장은 추후 구현

### 4. 이메일 인증 강제
- Firebase Auth의 `emailVerified` 체크는 하지 않음
- Mock 인증번호만 확인

---

**작성일**: 2026. 02. 25  
**버전**: v2.0 (Firebase Auth 연동)
