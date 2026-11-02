import 'portfolio_data.dart';

export 'portfolio_data.dart';

class PortfolioContent {
  // 기본 정보는 이곳에서 수정합니다. 연락처와 소개 영역에도 함께 반영됩니다.
  static const name = '이름을 입력하세요';
  static const role = '직무를 입력하세요';
  static const email = 'example@example.com';
  static const phone = '000-0000-0000';
  static const location = '활동 지역을 입력하세요';
  static const githubUrl = 'https://github.com/your-username';
  static const websiteUrl = 'https://example.com';
  static const resumeUrl = '';
  static const siteTitle = 'Portfolio Template';

  static const tagline = '나를 소개하는 한 문장을 입력하세요.';
  static const heroDescription =
      '관심 있는 분야와 하고 있는 일을 간단히 소개하세요.\n'
      '아래 내용은 모두 교체해서 사용할 수 있는 예시입니다.';
  static const contactMessage = '함께하고 싶은 일이 있다면 연락해 주세요.';

  static const List<MetaItem> introMeta = [
    MetaItem(label: '직무', value: role),
    MetaItem(label: '관심 분야', value: '관심 분야 1 / 관심 분야 2'),
    MetaItem(label: '활동 지역', value: location),
  ];

  // 항목을 삭제하거나 순서를 바꾸면 메뉴, 본문, 섹션 번호가 함께 바뀝니다.
  static const List<SectionIndexItem> sections = [
    SectionIndexItem(id: PortfolioSection.intro, label: '섹션 1'),
    SectionIndexItem(id: PortfolioSection.about, label: '섹션 2'),
    SectionIndexItem(id: PortfolioSection.capabilities, label: '섹션 3'),
    SectionIndexItem(id: PortfolioSection.caseStudies, label: '섹션 4'),
    SectionIndexItem(id: PortfolioSection.projects, label: '섹션 5'),
    SectionIndexItem(id: PortfolioSection.stack, label: '섹션 6'),
    SectionIndexItem(id: PortfolioSection.contact, label: '섹션 7'),
  ];

  static const List<String> aboutParagraphs = [
    '어떤 일을 하고 있는지, 어떤 분야에 관심이 있는지 소개하세요.',
    '지금까지의 경험이나 중요하게 생각하는 작업 방식을 자유롭게 적어 주세요.',
    '실제 경력이나 프로젝트 내용으로 교체하고, 필요 없는 문장은 삭제하면 됩니다.',
  ];

  static const List<Capability> capabilities = [
    Capability(
      navLabel: '역량 1',
      title: '첫 번째 역량',
      description: '잘하는 일과 그 일을 어떤 방식으로 수행하는지 설명하세요.',
      tools: ['도구 1', '도구 2'],
      experiences: ['관련 경험을 입력하세요.', '직접 맡았던 역할을 입력하세요.'],
    ),
    Capability(
      navLabel: '역량 2',
      title: '두 번째 역량',
      description: '문제를 해결할 때 활용하는 지식이나 접근 방법을 소개하세요.',
      tools: ['도구 3', '도구 4'],
      experiences: ['대표적인 작업을 입력하세요.', '그 과정에서 배운 점을 입력하세요.'],
    ),
    Capability(
      navLabel: '역량 3',
      title: '세 번째 역량',
      description: '협업이나 프로젝트 진행 과정에서 발휘하는 강점을 소개하세요.',
      tools: ['도구 5', '도구 6'],
      experiences: ['협업 경험을 입력하세요.', '기여한 내용을 입력하세요.'],
    ),
  ];

  static const List<CaseStudy> caseStudies = [
    CaseStudy(
      number: 'EXAMPLE 01',
      title: '사례 1',
      summary: '대표 사례를 한 문장으로 소개하세요.',
      status: '예시',
      platform: '작업 환경',
      role: '담당 역할',
      problem: '해결하려고 했던 문제나 프로젝트를 시작한 배경을 적어 주세요.',
      analysis: '문제를 이해하기 위해 확인한 자료와 조사 과정을 적어 주세요.',
      decision: '선택한 접근 방법과 그 이유를 적어 주세요.',
      implementation: '직접 실행하거나 구현한 내용을 적어 주세요.',
      validation: '결과를 어떤 방법으로 확인했는지 적어 주세요.',
      result: '확인된 성과와 배운 점을 적어 주세요. 수치는 실제 근거가 있을 때만 사용하세요.',
    ),
    CaseStudy(
      number: 'EXAMPLE 02',
      title: '사례 2',
      summary: '다른 경험이나 작업을 소개하세요.',
      status: '예시',
      platform: '작업 환경',
      role: '담당 역할',
      problem: '작업 전에 어떤 불편함이나 요구사항이 있었는지 적어 주세요.',
      analysis: '원인이나 요구사항을 파악한 과정을 적어 주세요.',
      decision: '여러 대안 중 선택한 방향을 적어 주세요.',
      implementation: '진행한 작업과 본인의 기여를 구분해 적어 주세요.',
      validation: '작업 이후 확인한 항목을 적어 주세요.',
      result: '실제 확인한 변화나 다음에 개선할 점을 적어 주세요.',
    ),
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      id: 'project-1',
      title: '프로젝트 1',
      subtitle: '앱 프로젝트 소개',
      category: ProjectCategory.mobileApp,
      year: 'YYYY',
      status: '예시',
      description: '프로젝트의 목적과 주요 기능을 소개하세요.',
      role: '담당 역할을 입력하세요.',
      techStack: ['기술 1', '기술 2'],
      highlights: ['주요 기능 1', '주요 기능 2'],
      githubUrl: '',
      demoUrl: '',
      storeUrl: '',
    ),
    ProjectItem(
      id: 'project-2',
      title: '프로젝트 2',
      subtitle: '웹 프로젝트 소개',
      category: ProjectCategory.web,
      year: 'YYYY',
      status: '예시',
      description: '누구를 위한 프로젝트인지, 어떤 경험을 제공하는지 설명하세요.',
      role: '담당 역할을 입력하세요.',
      techStack: ['기술 3', '기술 4'],
      highlights: ['주요 기능 1', '주요 기능 2'],
      githubUrl: '',
      demoUrl: '',
      storeUrl: '',
    ),
    ProjectItem(
      id: 'project-3',
      title: '프로젝트 3',
      subtitle: '자동화 프로젝트 소개',
      category: ProjectCategory.automation,
      year: 'YYYY',
      status: '예시',
      description: '반복 작업을 줄이거나 작업 흐름을 개선한 내용을 소개하세요.',
      role: '담당 역할을 입력하세요.',
      techStack: ['기술 5', '기술 6'],
      highlights: ['주요 기능 1', '주요 기능 2'],
      githubUrl: '',
      demoUrl: '',
      storeUrl: '',
    ),
    ProjectItem(
      id: 'project-4',
      title: '프로젝트 4',
      subtitle: '그 밖의 작업 소개',
      category: ProjectCategory.experiment,
      year: 'YYYY',
      status: '예시',
      description: '개인 작업이나 실험, 학습 결과물을 자유롭게 소개하세요.',
      role: '담당 역할을 입력하세요.',
      techStack: ['기술 7', '기술 8'],
      highlights: ['주요 기능 1', '주요 기능 2'],
      githubUrl: '',
      demoUrl: '',
      storeUrl: '',
    ),
  ];

  static const List<TechStackGroup> techStackGroups = [
    TechStackGroup(title: '분야 1', items: ['기술 1', '기술 2']),
    TechStackGroup(title: '분야 2', items: ['도구 1', '도구 2']),
    TechStackGroup(title: '분야 3', items: ['사용하는 서비스 1', '사용하는 서비스 2']),
  ];

  static const List<ContactItem> contacts = [
    ContactItem(label: '이메일', value: email),
    ContactItem(label: '전화번호', value: phone),
    ContactItem(label: 'GitHub', value: githubUrl),
    ContactItem(label: '웹사이트', value: websiteUrl),
    ContactItem(label: '이력서', value: resumeUrl),
  ];

  static const creditLine1 = 'BUILT WITH FLUTTER';
  static const creditLine2 = 'YOUR NAME / YOUR WORK';

  static const data = PortfolioData(
    siteTitle: siteTitle,
    name: name,
    role: role,
    tagline: tagline,
    heroDescription: heroDescription,
    introMeta: introMeta,
    sections: sections,
    aboutParagraphs: aboutParagraphs,
    capabilities: capabilities,
    caseStudies: caseStudies,
    projects: projects,
    techStackGroups: techStackGroups,
    contacts: contacts,
    contactMessage: contactMessage,
    creditLine1: creditLine1,
    creditLine2: creditLine2,
  );

  const PortfolioContent._();
}
