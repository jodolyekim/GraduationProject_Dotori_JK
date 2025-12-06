🌰 Dotori (도토리) — AI 기반 경계선 지능인 지원 플랫폼  
Graduation Project by 김재경

1. 개
Dotori는 "경계선 지능인을 비롯한 다양한 문해력/이해력/판단력이 부족한 사람들을 위한 디지털 접근성 보조 어플리케이션"입니다.  
AI 기반 요약, 역할극 시뮬레이션, AI 생성물 탐지, 퀴즈 학습, 활동 분석 등을 통해  
사용자가 일상 속에서 더 잘 이해하고, 소통하고, 스스로 판단할 수 있도록 돕습니다.

위 어플은 AWS를 이용하여 서버를 클라우드에서 구동중입니다.
실제 어플을 다운받아 이용해보실 수 있으시며, Android 환경에서만 우선 지원됩니다.
https://drive.google.com/file/d/1rGDJrvyqPaqW07xOdAbO6ECpxdYu-neq/view?usp=sharing


<img width="150" height="145" alt="image" src="https://github.com/user-attachments/assets/91571692-12a1-49e2-91cf-c0b93c0c99db" />

또한 실제 플레이 영상 링크를 함께 첨부합니다.
https://youtube.com/shorts/NgJFljrtfVs?feature=share

2.전체 디렉토리 구조

레포 루트에는 두 개의 주요 프로젝트가 있습니다.

```text
.
├── dotori_backend/          # Django Backend (REST API + AI 기능)
└── dotori_flutter_client/   # Flutter Frontend (Android / iOS / Web)

dotori_backend/
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── manage.py
├── project_tree.txt         # 백엔드 전체 구조 정리 파일
├── requirements.txt         # Python 패키지 목록
├── db.sqlite3               # 개발용 SQLite DB
│
├── apps/                    # 도메인별 Django 앱 모음
│   ├── dotori_accounts/     # 계정 · 프로필 · JWT 로그인
│   │   ├── jwt_views.py     # 커스텀 JWT 발급 + 로그인 로그 적재
│   │   ├── models.py        # User, Profile 등 계정 관련 모델
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   ├── views.py
│   │   └── __init__.py
│   │
│   ├── dotori_common/       # 공용 유틸
│   │   ├── utils.py
│   │   └── __init__.py
│   │
│   ├── dotori_detector/     # AI 생성물(텍스트/이미지/오디오/비디오) 탐지
│   │   ├── bitmind_client.py        # BitMind API 연동 (사용x)
│   │   ├── hf_client.py             # HuggingFace 관련(실험용/옵션/사용x)
│   │   ├── sightengine_client.py    # Sightengine API 연동
│   │   ├── utils_audio.py           # 사용(x)
│   │   ├── utils_image.py
│   │   ├── utils_image_local_ai.py  # 로컬 AI 기반 이미지 탐지(옵션)
│   │   ├── utils_text.py
│   │   ├── utils_video.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   └── __init__.py
│   │
│   ├── dotori_documents/    # 문서 기반 기능(확장 포인트)
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   └── __init__.py
│   │
│   ├── dotori_memberships/  # 멤버십 · 결제 로그 · 활동 로그 · 통계
│   │   ├── apps.py
│   │   ├── exceptions.py
│   │   ├── models.py              # Membership, Payment 등
│   │   ├── models_analytics.py    # QuizAttemptLog, RoleplayLog 등 분석용 모델
│   │   ├── serializers.py
│   │   ├── services.py
│   │   ├── views.py               # 멤버십 가입/변경
│   │   ├── views_admin_analytics.py  # 관리자용 통계
│   │   ├── views_analytics.py        # 사용자 개인 활동 분석
│   │   ├── views_stats.py            # 사용량 집계/통계 API
│   │   ├── urls.py
│   │   └── __init__.py
│   │
│   ├── dotori_quizzes/      # 사회성 퀴즈 기능
│   │   ├── admin.py
│   │   ├── consumers.py           # 실시간 기능(WebSocket, 필요 시)
│   │   ├── models.py              # Quiz, Choice 등
│   │   ├── selectors.py
│   │   ├── serializers.py
│   │   ├── services.py
│   │   ├── urls.py
│   │   ├── views.py
│   │   ├── fixtures/              # `quizzes_seed.json` (초기 데이터)
│   │   ├── management/
│   │   │   └── commands/
│   │   │       └── seed_quizzes.py  # 퀴즈 더미 데이터 로드 커맨드
│   │   └── tests/                 # 퀴즈 관련 테스트 코드
│   │
│   ├── dotori_roleplay/     # 역할극(롤플레이) 시나리오 + 대화 로그
│   │   ├── apps.py
│   │   ├── models.py
│   │   ├── openai_client.py  # GPT 기반 Roleplay 대화 생성
│   │   ├── scenarios.py      # 상황별 시나리오 프리셋
│   │   ├── serializers.py
│   │   ├── urls.py
│   │   ├── views.py
│   │   └── __init__.py
│   │
│   └── dotori_summaries/    # AI 요약 기능
│       ├── models.py
│       ├── serializers.py
│       ├── tasks.py         # Celery 비동기 작업
│       ├── urls.py
│       ├── utils_images.py  # 요약 결과 이미지 처리
│       ├── utils_io.py      # 파일 IO 유틸
│       ├── utils_openai.py  # OpenAI GPT 연동
│       ├── views.py
│       └── __init__.py
│
├── dotori_core/             # Django 프로젝트 설정/엔트리포인트
│   ├── __init__.py
│   ├── asgi.py              # ASGI 서버 엔트리
│   ├── celery.py            # Celery 설정
│   ├── middleware.py        # 공통 미들웨어
│   ├── routing.py           # Channels 라우팅
│   ├── settings.py          # Django 설정
│   └── urls.py              # 글로벌 URL 라우팅
│
├── media/                   # 업로드/생성 파일
│   ├── ai_images/           # AI 이미지 생성/탐지 샘플들
│   ├── profiles/            # 프로필 이미지
│   └── quizzes/             # 퀴즈용 이미지 리소스
│
└── templates/
    └── index.html           # 기본 랜딩 템플릿
dotori_flutter_client/
├── pubspec.yaml             # Flutter 의존성 정의
├── pubspec.lock
├── analysis_options.yaml
├── .gitignore
├── .metadata
├── .flutter-plugins
├── .flutter-plugins-dependencies
│
├── assets/
│   └── dotori_logo.png      # 도토리 로고 이미지
│
├── lib/
│   ├── config.dart          # API Base URL 등 환경설정
│   ├── main.dart            # Flutter 엔트리포인트
│   │
│   ├── screens/             # 실제 화면 단위 UI
│   │   ├── analytics/
│   │   │   ├── admin_analytics_screen.dart  # 관리자용 통계 화면
│   │   │   └── user_analytics_screen.dart   # 사용자 활동 분석 화면
│   │   │
│   │   ├── detector_audio_screen.dart       # 오디오 AI 탐지 UI
│   │   ├── detector_home_screen.dart        # 디텍터 홈(텍스트/이미지/영상 선택)
│   │   ├── detector_image_screen.dart       # 이미지 AI 탐지 UI
│   │   ├── detector_text_screen.dart        # 텍스트 AI 탐지 UI
│   │   ├── detector_video_screen.dart       # 비디오 AI 탐지 UI
│   │   │
│   │   ├── home_screen.dart                 # 메인 홈 화면 (기능 카드 모음)
│   │   ├── landing_screen.dart              # 랜딩 / 최초 소개 화면
│   │   ├── login_screen.dart                # 로그인
│   │   ├── register_screen.dart             # 회원가입
│   │   ├── splash_screen.dart               # 스플래시
│   │   │
│   │   ├── membership_overview_screen.dart  # 멤버십 플랜 전체 설명
│   │   ├── membership_screen.dart           # 현재 멤버십/결제 상태 화면
│   │   ├── my_page_screen.dart              # 마이페이지 (계정/설정/요약)
│   │   ├── point_screen.dart                # 포인트/사용량 화면
│   │   ├── quiz_screen.dart                 # 사회성 퀴즈 화면
│   │   ├── roleplay_screen.dart             # 역할극 대화 화면
│   │   ├── summary_screen.dart              # 텍스트 요약 결과 화면
│   │
│   ├── services/            # API 통신 및 비즈니스 로직
│   │   ├── api_client.dart              # 공통 HTTP 클라이언트
│   │   ├── auth_service.dart            # 로그인/회원 관련 API
│   │   ├── summary_service.dart         # 요약 API 래퍼
│   │   ├── detector_service.dart        # 디텍터 API 래퍼
│   │   ├── quiz_service.dart            # 퀴즈 API 래퍼
│   │   ├── roleplay_service.dart        # 역할극 API 래퍼
│   │   ├── membership_api_service.dart  # 멤버십 관련 REST API
│   │   ├── membership_service.dart      # 멤버십 상태/캐싱 로직
│   │   └── analytics_api_service.dart   # 사용량/통계 API
│   │
│   ├── theme/
│   │   └── app_theme.dart               # 공통 컬러/텍스트 스타일 정의
│   │
│   └── widgets/
│       ├── dotori_button.dart          # 커스텀 버튼 위젯
│       ├── feature_carousel.dart       # 기능 소개 캐러셀
│       ├── feature_carousel_item.dart  # 캐러셀 단일 아이템
│       ├── home_feature_card.dart      # 홈 화면 기능 카드
│       ├── home_section_title.dart     # 섹션 타이틀 위젯
│       └── result_card.dart            # 요약/퀴즈 결과 카드
│
├── android/                # Android 빌드 관련 (Gradle, Manifest 등)
├── ios/                    # iOS 빌드 관련 (Xcode 프로젝트)
├── linux/                  # Linux 데스크탑 타깃
├── macos/                  # macOS 데스크탑 타깃
├── windows/                # Windows 데스크탑 타깃
├── web/                    # Web 빌드 타깃 (index.html, manifest 등)
└── test/                   # Flutter 테스트 코드

3. 주요 기능 정리
1) AI 요약 (Summarization)

긴 글·대화 내용을 이해하기 쉬운 형태로 요약 후 어려운 단어를 즉각적으로 설명.
이미지 파일을 업로드 후 OCR 형태로 스캔하는 방식으로 사용 가능.

2) AI 생성물 탐지 (Detector)

텍스트 / 이미지 / 비디오가 AI 생성물인지 여부를 판별
비디오 탐지 기능은 추가 개발을 위해 구현했지만 현재까지는 불안정 상태.

3️) 역할극(Roleplay) 시뮬레이션

실제로 마주칠 수 있는 사회적 상황(거절, 부탁, 일상 대화 등)을 AI 채팅을 통해 학습.
사용자 반응을 바탕으로 상호작용하며 연습 가능

4️) 사회성 퀴즈(Quizzes)

이미지/상황 기반 퀴즈로 사회적 이해 능력 훈련
정답/오답 로그를 멤버십 포인트 / 분석결과와 연동

5️) 멤버십 & 포인트 시스템

Basic / Plus / Premium 3단계 플랜
실제 배포시 BM으로 활용하기 위한 구조 (테스트용에서는 결제 과정없이 선택 가능)
각 멤버십별 기능 사용 횟수 제한
사용자는 퀴즈와 롤플레이를 통해 포인트를 획득할 수 있고, 이 포인트를 이용하여 멤버십 구입 가능
(사용자 학습 독려)

6️) 활동 분석 (User & Admin Analytics)

사용자별 요약 사용량, 퀴즈 이력, 역할극 참여 내역 등 시각화
주차별로 사용량과 맞은 문제 수등을 이용하여 학습 관리와 독려.
