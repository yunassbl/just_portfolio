import 'package:just_portfolio/features/home/data/portfolio_data.dart';

const fixtureSections = [
  SectionIndexItem(id: PortfolioSection.intro, label: '테스트 시작'),
  SectionIndexItem(id: PortfolioSection.about, label: '테스트 소개'),
  SectionIndexItem(id: PortfolioSection.capabilities, label: '테스트 역량'),
  SectionIndexItem(id: PortfolioSection.caseStudies, label: '테스트 사례'),
  SectionIndexItem(id: PortfolioSection.projects, label: '테스트 프로젝트'),
  SectionIndexItem(id: PortfolioSection.stack, label: '테스트 도구'),
  SectionIndexItem(id: PortfolioSection.contact, label: '테스트 연락처'),
];

const fixtureProjects = [
  ProjectItem(
    id: 'fixture-app',
    title: '고정 앱 프로젝트',
    subtitle: '앱 테스트',
    category: ProjectCategory.mobileApp,
    year: '2026',
    status: '테스트',
    description: '펼치기 동작을 확인하는 고정된 프로젝트 설명입니다.',
    role: '테스트 역할',
    techStack: ['도구 A'],
    highlights: ['고정 기능'],
    githubUrl: '',
    demoUrl: 'https://example.com',
    storeUrl: '',
  ),
  ProjectItem(
    id: 'fixture-web',
    title: '고정 웹 프로젝트',
    subtitle: '웹 테스트',
    category: ProjectCategory.web,
    year: '2026',
    status: '테스트',
    description: '카테고리와 선택 변경을 확인하는 고정된 설명입니다.',
    role: '테스트 역할',
    techStack: ['도구 B'],
    highlights: ['고정 기능'],
    githubUrl: '',
    demoUrl: '',
    storeUrl: '',
  ),
];

const fixtureCapabilities = [
  Capability(
    navLabel: '고정 역량',
    title: '테스트 역량 제목',
    description: '고정된 역량 설명입니다.',
    tools: ['테스트 도구'],
    experiences: ['테스트 경험'],
  ),
];

const fixtureContacts = [
  ContactItem(label: '고정 이메일', value: 'fixture@example.com'),
  ContactItem(label: '고정 전화번호', value: '+1 202 555 0123'),
];

PortfolioData fixtureData({
  List<SectionIndexItem> sections = fixtureSections,
  List<ProjectItem> projects = fixtureProjects,
  List<Capability> capabilities = fixtureCapabilities,
  List<ContactItem> contacts = fixtureContacts,
}) => PortfolioData(
  siteTitle: '고정 테스트 사이트',
  name: '테스트 이름',
  role: '테스트 직무',
  tagline: '고정 데이터로 화면을 검증합니다.',
  heroDescription: '수정 가능한 예시 콘텐츠와 별개인 테스트 설명입니다.',
  introMeta: const [MetaItem(label: '고정 항목', value: '고정 값')],
  sections: sections,
  aboutParagraphs: const ['고정된 소개 문단입니다.'],
  capabilities: capabilities,
  caseStudies: const [
    CaseStudy(
      number: 'TEST 01',
      title: '고정 사례',
      summary: '테스트 사례 설명',
      status: '테스트',
      platform: '테스트 환경',
      role: '테스트 역할',
      problem: '고정 문제',
      analysis: '고정 분석',
      decision: '고정 방향',
      implementation: '고정 구현',
      validation: '고정 검증',
      result: '고정 결과',
    ),
  ],
  projects: projects,
  techStackGroups: const [
    TechStackGroup(title: '고정 분야', items: ['도구 A']),
  ],
  contacts: contacts,
  contactMessage: '고정된 연락 안내입니다.',
  creditLine1: 'TEST CREDITS',
  creditLine2: 'FIXTURE DATA',
);
