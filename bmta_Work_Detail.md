# **BMTA 기술 구현 상세 세부 지침**

AI가 프로젝트 초기 빌드 시 반드시 지켜야 할 기술적 예외 처리 및 상세 규격입니다.

BMTA 기술 구현 상세 지침 (v0.1.3)

본 문서는 AI가 BMTA 프로젝트의 코드를 작성할 때 준수해야 할 기술적 표준과 아키텍처 규격을 정의합니다.

### 1. 아키텍처 및 폴더 구조 (Architecture)

AI는 반드시 아래의 폴더 구조 내에서 파일을 생성하고 관리해야 합니다.

lib/core/: 공통 테마(app_theme.dart), 상수, 유틸리티 함수

lib/models/: 데이터 클래스 (모든 모델은 fromJson/toJson 포함)

lib/providers/: Riverpod 기반의 상태 관리자 클래스

lib/services/: Firebase(Auth, Firestore), 외부 API 연동 로직

lib/views/: UI 위젯 및 각 화면별 폴더 (예: views/login/, views/feed/)


### 2. 데이터베이스 및 명명 규칙 (Schema & Naming)

데이터베이스 필드명은 snake_case를 사용하며, 다음 규격을 우선합니다.

users: uid, email, nickname, points, is_verified, created_at

posts: post_id, author_id, transport_type, channel_type, title, content, boom_up_count, view_count, created_at


### 3. 전역 상태 관리 및 테마 (State & Theme)

상태 관리: flutter_riverpod 사용을 권장한다. (관심사 분리가 명확함)

디자인 상수:

모든 색상, 폰트 크기, 여백 값은 lib/core/theme/ 내부에 상수로 정의하여 사용한다.

하드코딩된 스타일(예: Color(0xFF...))을 개별 위젯에 직접 넣지 않는다.


### 4. 디자인 시스템 및 라이브러리 (Standardization)

아이콘: lucide_icons 패키지를 기본으로 사용합니다.

색상: Connect Blue (#2563EB), Mobility Amber (#F59E0B)를 app_theme.dart에서 참조합니다.

간격 시스템: 모든 여백과 크기는 8px 단위를 기준으로 합니다. (8.0, 16.0, 24.0 등)

검색 바(Search Bar)는 스크롤 시 상단에 고정이 되도록 구현하며, 리스트와 겹칠 때 가독성을 위해 배경색은 불투명한 테마색을 적용한다.


### 5. 주요 비즈니스 로직 (Core Logic)

포인트 검증: 쪽지 발송 전, 사용자의 포인트가 1,000P 이상인지 반드시 서버 및 클라이언트에서 이중 확인합니다.

실시간 갱신: 사용자 위치 실시간 정보는 30초 주기로 폴링(Polling)하며 클라이언트 캐싱을 적용합니다.


### 6.1 Firebase & 데이터 무결성 (Integrity)

포인트 차감 트랜잭션: 쪽지 발송 로직 구현 시, 반드시 Firebase Firestore Transaction을 사용한다. (네트워크 오류 등으로 포인트만 깎이고 쪽지가 안 가는 상황 방지)

BM Up 취소 로직: likes 카운트와 작성자의 points는 동기화되어야 한다. Cloud Functions를 사용하거나, 클라이언트에서 Batch 작성 시 이 두 데이터가 동시에 변경되도록 작성한다.

### 6.2 Firebase Storage 및 미디어 정책 (Media Policy)

저장 구조: `/posts/{uid}/{post_id}/{timestamp}_{file_name}` 경로 규칙을 준수한다.

최적화: 클라이언트단에서 이미지 업로드 전, 최대 해상도 1080px(가로 기준)로 리사이징 및 JPEG 압축(퀄리티 80%)을 수행하여 저장 용량을 최소화한다.

무결성: 게시글 삭제 시, 해당 `post_id`와 연결된 모든 Storage 파일을 삭제하는 트랜잭션 혹은 배치 작업을 포함해야 한다.

보안 규칙: - `write`: 인증된 사용자(auth != null)이며 본인의 UID 폴더일 경우에만 허용.
   - `read`: 모든 사용자에게 허용하되, 신고 누적된 사용자의 컨텐츠는 클라이언트에서 필터링함.


### 7. 에지 케이스 정의 (Edge Cases)

AI가 코드를 짤 때 다음 상황에 대한 기본 UI/UX를 반드시 포함하도록 한다.

네트워크 단절: 공공 API 호출 실패 시 "현재 정보를 가져올 수 없습니다"라는 스켈레톤 UI 또는 안내 문구 노출.

위치 권한 거부: 사용자가 GPS 권한을 거부했을 경우, '거리순 정렬' 대신 '최신순 기본 정렬'로 자동 전환.

포인트 부족: 쪽지 보내기 클릭 시 포인트가 1,000P 미만이면 즉시 '충전 팝업'으로 유도.


### 8. 보안 정책 상세 (Security)

CI/DI 인증: 본인인증 성공 시 리턴되는 CI값은 DB에 저장하되, 절대 클라이언트 앱 단에서 평문으로 조회되지 않도록 Security Rules를 설정한다.

익명성 유지: 게시글 상세 및 프로필 조회 시 유저의 email이나 real_name은 절대 노출되지 않아야 하며, 오직 nickname만 노출한다.


### 9. AI 작업 지침

모든 코드는 가독성이 좋아야 하며, 주요 함수에는 한글 주석을 포함합니다.

새로운 라이브러리 추가 시 반드시 pubspec.yaml 파일 수정을 먼저 보고합니다.