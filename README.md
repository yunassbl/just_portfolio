# 포트폴리오 템플릿

어두운 배경, 넓은 여백, 절제된 스크롤 전환을 사용하는 Flutter Web 템플릿입니다.
이름, 직무, 소개, 프로젝트, 연락처를 본인의 내용으로 교체해 사용할 수 있습니다.
기본 문구와 프로젝트는 모두 작성 안내용 예시이며, 실제 인물의 이력이나 성과가 아닙니다.

## 내 정보로 바꾸기

먼저 `lib/features/home/data/portfolio_content.dart` 상단의 값만 수정하세요.

```dart
static const name = '이름을 입력하세요';
static const role = '직무를 입력하세요';
static const email = 'example@example.com';
static const phone = '000-0000-0000';
static const location = '활동 지역을 입력하세요';
static const githubUrl = 'https://github.com/your-username';
static const websiteUrl = 'https://example.com';
static const resumeUrl = '';
```

이름과 직무는 첫 화면과 메뉴에, 이메일과 전화번호는 연락처에 반영됩니다.
전화번호는 국가번호를 포함해 입력할 수 있습니다. 예시의 0으로만 된 번호는 전화 링크를 활성화하지 않습니다.
필요 없는 연락처는 해당 값을 빈 문자열로 두면 화면에서 숨겨집니다.

같은 파일에서 나머지 내용도 수정할 수 있습니다.

| 항목 | 수정할 값 |
| --- | --- |
| 첫 화면 문구 | `tagline`, `heroDescription`, `introMeta` |
| 자기소개 | `aboutParagraphs` |
| 역량 | `capabilities` |
| 대표 사례 | `caseStudies` |
| 프로젝트 | `projects` |
| 기술·도구 | `techStackGroups` |
| 마지막 인사와 크레딧 | `contactMessage`, `creditLine1`, `creditLine2` |

프로젝트마다 고유한 `id`를 사용하세요. 링크를 빈 문자열로 두면 해당 링크는 표시하지 않습니다.
프로젝트가 없거나 선택한 카테고리가 비어 있어도 안내 문구가 표시됩니다.
이미지는 기본적으로 placeholder이며 실제 프로필이나 프로젝트 이미지가 포함되어 있지 않습니다.

## 섹션 이름과 순서 바꾸기

콘텐츠 파일의 `sections` 목록을 수정하세요. 기본 메뉴 이름은 `섹션 1`부터 `섹션 7`까지입니다.
`id`는 섹션 종류이고, `label`은 메뉴와 본문 제목입니다.

```dart
static const List<SectionIndexItem> sections = [
  SectionIndexItem(id: PortfolioSection.intro, label: '시작'),
  SectionIndexItem(id: PortfolioSection.about, label: '소개'),
  SectionIndexItem(id: PortfolioSection.projects, label: '프로젝트'),
  SectionIndexItem(id: PortfolioSection.contact, label: '연락처'),
];
```

목록에서 항목을 삭제하거나 순서를 바꾸면 메뉴, 본문, 번호가 함께 바뀝니다.
각 `id`는 한 번만 사용하세요. 프로젝트나 연락처 섹션을 빼면 첫 화면의 해당 이동 버튼도 숨겨집니다.
데스크톱과 모바일 모두 자유 스크롤이며, 섹션 높이를 강제로 고정하지 않습니다.

## 실행과 검증

검증된 버전은 **Flutter 3.47.8 stable / Dart 3.13.7**이며, 자동화에서도 같은 버전을 사용합니다.
현재 `pubspec.lock`의 최소 조건은 Flutter 3.44.0 이상과 Dart 3.13.0 이상입니다. 재현 가능한 실행을 위해 검증된 버전을 권장합니다.

```sh
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
flutter build web --release
```

기능 테스트는 `test/fixtures/portfolio_fixtures.dart`의 고정 데이터를 사용합니다.
소개나 연락처, 프로젝트 같은 예시 콘텐츠를 수정할 때 테스트 데이터를 함께 고칠 필요는 없습니다.
`test/portfolio_content_test.dart`는 실제 콘텐츠의 섹션·프로젝트 ID 중복과 모바일·데스크톱 렌더링 오류를 검사합니다.
사용하지 않는 연락처나 프로젝트를 비우고 섹션을 삭제·재정렬하는 것은 허용되지만, ID는 중복되면 안 됩니다.

색상과 기본 텍스트 스타일은 `lib/app/theme/app_theme.dart`에서 수정합니다.

## 글꼴

기본 영문 글꼴은 Flutter Web의 Roboto이며, 한글 등 지원하지 않는 문자는 렌더러의 자동 폴백을 사용합니다.
Pretendard나 Inter 파일을 기본으로 번들하거나 별도 웹폰트 CSS를 불러오지 않습니다.
다만 기본·폴백 글꼴의 네트워크 요청까지 없어지는 것은 아닙니다. 처음 표시하는 문자와 캐시 상태에 따라 요청량이 달라질 수 있습니다.
`web/index.html`의 `fonts.gstatic.com` preconnect는 이 기본·폴백 요청을 위한 설정입니다.

### 선택: Pretendard 사용하기

원하는 경우에만 [Pretendard 공식 배포본](https://github.com/orioncactus/pretendard/releases)에서 일반 Pretendard의 원본 OTF 파일과 해당 라이선스를 받아 등록하세요.
Pretendard Std는 한글용 버전이 아닙니다. 아래 경로는 등록 예시이며 실제 폰트 파일은 이 템플릿에 포함되어 있지 않습니다.

```text
assets/fonts/Pretendard-Regular.otf
assets/fonts/Pretendard-Medium.otf
assets/fonts/Pretendard-SemiBold.otf
assets/fonts/Pretendard-Bold.otf
assets/fonts/Pretendard-LICENSE.txt
```

폰트와 동봉된 라이선스 전문을 `Pretendard-LICENSE.txt`로 보존하고, 기존 `pubspec.yaml`의 `flutter:` 항목에 합쳐 등록합니다.
루트의 MIT `LICENSE`를 폰트 라이선스로 덮어쓰거나 `flutter:` 항목을 중복 생성하지 마세요.

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/fonts/Pretendard-LICENSE.txt
  fonts:
    - family: Pretendard
      fonts:
        - asset: assets/fonts/Pretendard-Regular.otf
          weight: 400
        - asset: assets/fonts/Pretendard-Medium.otf
          weight: 500
        - asset: assets/fonts/Pretendard-SemiBold.otf
          weight: 600
        - asset: assets/fonts/Pretendard-Bold.otf
          weight: 700
```

그다음 `AppTheme.dark()`의 `ThemeData`에서 `fontFamily: 'Roboto'`를 `fontFamily: 'Pretendard'`로 변경하세요.
폰트·라이선스 파일과 pubspec·테마 변경을 함께 커밋하면 Actions가 다시 검증하고 빌드합니다. 로컬에서 작업할 때는 `flutter pub get`도 실행하세요.
HTML에 CSS 링크만 추가하는 것으로 Flutter CanvasKit 글꼴 적용을 대신하지 마세요.

예시는 현재 사용하는 400/500/600/700 굵기입니다. 일부 굵기를 생략하면 표시가 달라질 수 있으므로 직접 확인하세요.
원본 파일의 라이선스 조건을 따르고, 선택 적용 후에는 데스크톱·모바일에서 글꼴·굵기·줄바꿈과 첫 화면 로딩을 확인하세요.
번들 크기만으로 로딩 시간이 몇 배 늘어난다고 단정할 수 없으며, 브라우저가 실제로 받은 바이트와 표시 시간을 따로 측정해야 합니다.

## 웹 제목과 설명

앱 내부 제목은 콘텐츠 파일의 `siteTitle`에서 바꿉니다.
정적 메타데이터는 다음 파일에서도 수정하세요.

- `web/index.html`: 페이지 제목, 설명, 언어, 모바일 표시 이름.
- `web/manifest.json`: 앱 이름, 설명, 아이콘, 테마 색상.

기본 아이콘은 Flutter 기본 아이콘입니다. 공개 전에 원하는 아이콘으로 교체하세요.
Flutter Web의 초기 로딩과 검색 노출 특성을 고려해 사용하세요.

## GitHub Pages에 배포하기

자동 검증과 배포는 `.github/workflows/portfolio.yml`에 포함되어 있습니다.
로컬에 Flutter를 설치하지 않아도 GitHub 웹에서 콘텐츠를 수정하고 커밋하면 검증과 배포를 진행할 수 있습니다.

### 처음 한 번 설정하기

1. 소스를 자신의 GitHub 저장소로 가져오고 기본 브랜치를 `main`으로 설정합니다.
2. 저장소의 Actions 사용을 허용합니다. Fork한 저장소라면 Actions 탭에서 워크플로우 실행을 활성화해야 할 수 있습니다.
3. 공개 저장소에서 `Settings → Pages → Build and deployment → Source`를 `GitHub Actions`로 설정합니다.
4. 콘텐츠 파일을 수정하고 `main`에 커밋합니다.
5. Actions 탭의 `Portfolio CI and Pages` 실행 결과와 `github-pages` 배포 주소를 확인합니다.

### 실행 조건

| 상황 | 실행 내용 |
| --- | --- |
| `main` 대상 PR | SDK 확인, 경로 검사, 의존성 설치, 분석, 테스트, 웹 빌드. 배포하지 않음 |
| 공개 저장소의 `main` push | 검증이 모두 성공한 경우 Pages 배포 |
| 비공개 저장소 | 검증은 실행하고 배포 산출물 업로드와 Pages 배포 job은 건너뜀 |
| Actions에서 수동 실행 | 선택한 브랜치에서 검증. 공개 저장소의 `main`을 선택한 경우에만 성공 후 배포 |

분석·테스트·빌드 중 하나라도 실패하면 새 버전을 배포하지 않습니다. 실패한 단계의 로그를 확인하세요.
섹션·프로젝트 ID 중복 같은 잘못된 콘텐츠 설정도 테스트 단계에서 차단합니다.
배포 job에만 Pages 쓰기와 ID 토큰 권한을 부여하며, 검증 job의 저장소 권한은 읽기 전용입니다.
별도의 개인 액세스 토큰을 입력할 필요는 없습니다.

GitHub Free의 비공개 저장소에서는 Pages를 사용할 수 없습니다.
공개 전에는 검증 job을 확인하고, 공개 전환과 Pages 설정 후 실제 배포를 확인하세요.
비공개 저장소의 Actions 실행은 계정의 사용량 한도와 정책을 따릅니다.

### 배포 경로 자동 처리

- 일반 저장소 `USERNAME/REPOSITORY_NAME`: `/REPOSITORY_NAME/`.
- 루트 사이트 저장소 `USERNAME/USERNAME.github.io`: `/`.

워크플로우가 `.github/scripts/base_href.sh`로 경로를 계산하므로 직접 입력할 필요가 없습니다.
이 자동 계산은 기본 `github.io` 주소용입니다. 별도 도메인을 연결할 때는 도메인과 base 경로 설정을 따로 확인하세요.

### 로컬에서 직접 빌드하기

루트 주소는 기본 빌드를 사용하고, 하위 경로는 다음처럼 지정합니다.

```sh
flutter build web --release --base-href /REPOSITORY_NAME/
```

배포 대상은 `build/web`입니다. 소스 폴더를 그대로 Pages에 게시하면 Flutter 앱이 실행되지 않습니다.

자동화의 SDK 버전을 바꿀 때는 워크플로우의 `FLUTTER_VERSION`, `DART_VERSION`과 이 문서의 검증 버전을 함께 변경하고 테스트·빌드를 다시 확인하세요.
워크플로우에서 직접 사용하는 Actions는 커밋 SHA로 고정되어 있습니다. 업데이트 시 해당 릴리스의 변경 내용도 확인하세요.

## 라이선스

이 프로젝트의 코드는 [MIT 라이선스](LICENSE)를 따릅니다.
개인·상업적 사용, 수정과 재배포가 가능하며, 원본 저작권 및 라이선스 고지를 유지해야 합니다.
외부 패키지와 추후 추가하는 폰트·이미지는 각각의 라이선스를 확인하세요.
