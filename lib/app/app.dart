import 'package:flutter/material.dart';
import 'package:just_portfolio/app/theme/app_theme.dart';
import 'package:just_portfolio/features/home/data/portfolio_content.dart';
import 'package:just_portfolio/features/home/presentation/pages/brand_home_page.dart';

class AppBrandSite extends StatelessWidget {
  const AppBrandSite({super.key, this.content = PortfolioContent.data});

  final PortfolioData content;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: content.siteTitle,
      theme: AppTheme.dark(),
      home: BrandHomePage(content: content),
    );
  }
}
