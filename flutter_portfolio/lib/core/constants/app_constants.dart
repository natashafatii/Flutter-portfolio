// core/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // =============== PERSONAL INFORMATION ===============
  static const String yourName = 'Natasha Fatima';
  static const String yourTitle = 'Flutter Developer';
  static const String yourEmail = 'natashafatima53@gmail.com';
  static const String yourLocation = 'Lahore, Pakistan';
  static const String yourTagline = 'Building beautiful experiences with Flutter';
  static const String yourBio = 'Passionate Flutter developer with expertise in creating modern, responsive applications.';

  // =============== SOCIAL LINKS ===============
  static const String githubUrl = 'https://github.com/natashafatii';
  static const String linkedinUrl = 'https://www.linkedin.com/in/natasha-fatima-3223b0282/';
  // Optional: Add if you have them
  // static const String twitterUrl = 'https://twitter.com/yourusername';
  // static const String instagramUrl = 'https://instagram.com/yourusername';

  // =============== APP INFORMATION ===============
  static const String appName = 'Portfolio';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A showcase of my Flutter development skills and projects';
  static const String appDeveloper = 'Natasha Fatima';

  // =============== ASSET PATHS ===============
  static const String profileImagePath = 'assets/images/profile.jpeg';
  // static const String resumePdfPath = 'assets/documents/resume.pdf';
  // static const String backgroundImagePath = 'assets/images/background.jpg';

  // =============== PRE-FORMATTED URIS ===============
  static Uri get emailUri => Uri(scheme: 'mailto', path: yourEmail);
  static Uri get githubUri => Uri.parse(githubUrl);
  static Uri get linkedinUri => Uri.parse(linkedinUrl);
  // static Uri get twitterUri => Uri.parse(twitterUrl);

  // =============== SKILLS/TECHNOLOGIES ===============
  static const List<String> skills = [
    'Flutter',
    'Dart',
    'Firebase',
    'UI/UX Design',
    'Responsive Design',
    'REST APIs',
    'Git',
    'Clean Architecture',
  ];

  // =============== TYPING ANIMATION ROLES ===============
  static const List<String> typingRoles = [
    'Flutter Developer',
    'Web Designer',
    'UI/UX Designer'
  ];

  // =============== EXPERIENCE ===============
  static const String yearsOfExperience = '3+';
  static const String availability = 'Available for freelance projects';

  // =============== DESIGN CONSTANTS ===============
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // =============== SEO/META TAGS (For Web) ===============
  static const String metaKeywords = 'Flutter, Mobile Development, App Developer, Portfolio, Natasha Fatima';
  static const String metaDescription = 'Portfolio of Natasha Fatima - Flutter Developer specializing in creating beautiful mobile applications.';

  // =============== CONTACT INFO MAP ===============
  static const Map<String, String> contactInfo = {
    'email': yourEmail,
    'location': yourLocation,
    // 'phone': '+92 XXX XXXXXXX',
  };

  // =============== ICON CONSTANTS ===============
  static const IconData responsiveDesignIcon = Icons.device_hub_rounded;
  static const IconData gitIcon = Icons.developer_board_rounded;

  // Skill icons with consistent mapping
  static const Map<String, IconData> skillIcons = {
    'Flutter': Icons.flutter_dash_rounded,
    'Dart': Icons.code_rounded,
    'Firebase': Icons.cloud_rounded,
    'UI/UX Design': Icons.design_services_rounded,
    'Responsive Design': Icons.device_hub_rounded,
    'REST APIs': Icons.api_rounded,
    'Git': Icons.developer_board_rounded,
    'Clean Architecture': Icons.architecture_rounded,
    // Additional skills can be added here
    'State Management': Icons.settings_ethernet_rounded,
    'Testing': Icons.bug_report_rounded,
    'CI/CD': Icons.build_rounded,
  };

  // Skill colors (brand colors for each technology)
  static const Map<String, Color> skillColors = {
    'Flutter': Color(0xFF02569B),        // Flutter blue
    'Dart': Color(0xFF00B4AB),           // Dart teal
    'Firebase': Color(0xFFFFCA28),       // Firebase yellow
    'UI/UX Design': Color(0xFFFF6B6B),   // Coral red
    'Responsive Design': Color(0xFF4ECDC4), // Turquoise
    'REST APIs': Color(0xFF45B7D1),      // Sky blue
    'Git': Color(0xFFF1502F),            // Git orange
    'Clean Architecture': Color(0xFF96CEB4), // Mint green
  };

  // Skill proficiency levels (0-100)
  static const Map<String, int> skillLevels = {
    'Flutter': 95,
    'Dart': 90,
    'Firebase': 85,
    'UI/UX Design': 80,
    'Responsive Design': 85,
    'REST APIs': 85,
    'Git': 90,
    'Clean Architecture': 80,
  };

  // =============== PROJECT CATEGORIES ===============
  static const List<String> projectCategories = [
    'All',
    'Flutter',
    'Mobile',
    'Web',
    'UI/UX',
    'Open Source',
  ];

  // =============== SOCIAL MEDIA HANDLES ===============
  static const Map<String, dynamic> socialMedia = {
    'GitHub': {
      'username': '@natashafatii',
      'url': githubUrl,
      'icon': Icons.code,
      'color': Colors.black,
    },
    'LinkedIn': {
      'username': 'Natasha Fatima',
      'url': linkedinUrl,
      'icon': Icons.business_center,
      'color': Color(0xFF0077B5),
    },
    'Email': {
      'username': yourEmail,
      'url': 'mailto:$yourEmail',
      'icon': Icons.email,
      'color': Color(0xFFEA4335),
    },
  };
}