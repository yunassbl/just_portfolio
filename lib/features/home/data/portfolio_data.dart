enum ProjectCategory {
  all('전체'),
  mobileApp('앱'),
  web('웹'),
  automation('자동화'),
  experiment('기타');

  const ProjectCategory(this.label);

  final String label;
}

enum PortfolioSection {
  intro,
  about,
  capabilities,
  caseStudies,
  projects,
  stack,
  contact,
}

class SectionIndexItem {
  const SectionIndexItem({required this.id, required this.label});

  final PortfolioSection id;
  final String label;
}

class MetaItem {
  const MetaItem({required this.label, required this.value});

  final String label;
  final String value;
}

class Capability {
  const Capability({
    required this.navLabel,
    required this.title,
    required this.description,
    required this.tools,
    required this.experiences,
  });

  final String navLabel;
  final String title;
  final String description;
  final List<String> tools;
  final List<String> experiences;
}

class CaseStudy {
  const CaseStudy({
    required this.number,
    required this.title,
    required this.summary,
    required this.status,
    required this.platform,
    required this.role,
    required this.problem,
    required this.analysis,
    required this.decision,
    required this.implementation,
    required this.validation,
    required this.result,
  });

  final String number;
  final String title;
  final String summary;
  final String status;
  final String platform;
  final String role;
  final String problem;
  final String analysis;
  final String decision;
  final String implementation;
  final String validation;
  final String result;
}

class ProjectItem {
  const ProjectItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.year,
    required this.status,
    required this.description,
    required this.role,
    required this.techStack,
    required this.highlights,
    required this.githubUrl,
    required this.demoUrl,
    required this.storeUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final ProjectCategory category;
  final String year;
  final String status;
  final String description;
  final String role;
  final List<String> techStack;
  final List<String> highlights;
  final String githubUrl;
  final String demoUrl;
  final String storeUrl;
}

class TechStackGroup {
  const TechStackGroup({required this.title, required this.items});

  final String title;
  final List<String> items;
}

class ContactItem {
  const ContactItem({required this.label, required this.value});

  final String label;
  final String value;
}

class PortfolioData {
  const PortfolioData({
    this.siteTitle = '',
    this.name = '',
    this.role = '',
    this.tagline = '',
    this.heroDescription = '',
    this.introMeta = const [],
    this.sections = const [],
    this.aboutParagraphs = const [],
    this.capabilities = const [],
    this.caseStudies = const [],
    this.projects = const [],
    this.techStackGroups = const [],
    this.contacts = const [],
    this.contactMessage = '',
    this.creditLine1 = '',
    this.creditLine2 = '',
  });

  final String siteTitle;
  final String name;
  final String role;
  final String tagline;
  final String heroDescription;
  final List<MetaItem> introMeta;
  final List<SectionIndexItem> sections;
  final List<String> aboutParagraphs;
  final List<Capability> capabilities;
  final List<CaseStudy> caseStudies;
  final List<ProjectItem> projects;
  final List<TechStackGroup> techStackGroups;
  final List<ContactItem> contacts;
  final String contactMessage;
  final String creditLine1;
  final String creditLine2;
}
