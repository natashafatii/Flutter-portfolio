// screens/home/home_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';

class HomeViewModel extends ChangeNotifier {
  // Title animation
  final List<String> _titles = AppConstants.typingRoles;
  int _currentTitleIndex = 0;
  bool _showScrollIndicator = true;
  bool _isAnimating = true;

  // UI State
  bool _isHoveringContactButton = false;
  bool _isHoveringProjectsButton = false;
  final Map<int, bool> _hoveringSocialButtons = {};

  // Getters
  int get currentTitleIndex => _currentTitleIndex;
  bool get showScrollIndicator => _showScrollIndicator;
  bool get isAnimating => _isAnimating;
  bool get isHoveringContactButton => _isHoveringContactButton;
  bool get isHoveringProjectsButton => _isHoveringProjectsButton;
  List<String> get titles => _titles;

  // Personal info from AppConstants
  String get yourName => AppConstants.yourName;
  String get yourBio => AppConstants.yourBio;
  String get yourEmail => AppConstants.yourEmail;
  String get yourLocation => AppConstants.yourLocation;
  String get yourTagline => AppConstants.yourTagline;

  // Social media data
  List<Map<String, dynamic>> get socialPlatforms {
    return AppConstants.socialMedia.entries.map((entry) {
      return {
        'name': entry.key,
        'username': entry.value['username'],
        'url': entry.value['url'],
        'icon': entry.value['icon'],
        'color': entry.value['color'],
      };
    }).toList();
  }

  // Hover state management
  void setHoveringContactButton(bool hovering) {
    _isHoveringContactButton = hovering;
    notifyListeners();
  }

  void setHoveringProjectsButton(bool hovering) {
    _isHoveringProjectsButton = hovering;
    notifyListeners();
  }

  void setHoveringSocialButton(int index, bool hovering) {
    _hoveringSocialButtons[index] = hovering;
    notifyListeners();
  }

  bool isSocialButtonHovering(int index) => _hoveringSocialButtons[index] ?? false;

  // Title rotation
  void rotateTitle() {
    _currentTitleIndex = (_currentTitleIndex + 1) % _titles.length;
    notifyListeners();
  }

  void hideScrollIndicator() {
    _showScrollIndicator = false;
    notifyListeners();
  }

  // Social actions
  Future<void> launchSocial(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> sendEmail() async {
    final Uri emailLaunchUri = AppConstants.emailUri;
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  // Animation control
  void startAnimations() {
    if (_isAnimating) return;
    _isAnimating = true;
    notifyListeners();
  }

  void stopAnimations() {
    if (!_isAnimating) return;
    _isAnimating = false;
    notifyListeners();
  }

  // Data for UI sections
  List<Map<String, dynamic>> get stats => [
    {
      'value': '5+', // Updated to match your actual project count
      'label': 'Projects',
      'icon': Icons.rocket_launch,
      'color': Colors.blue,
    },
    {
      'value': AppConstants.yearsOfExperience,
      'label': 'Years Experience',
      'icon': Icons.timeline,
      'color': Colors.green,
    },
    {
      'value': '100%',
      'label': 'Client Satisfaction',
      'icon': Icons.emoji_events,
      'color': Colors.amber,
    },
    {
      'value': '24/7',
      'label': 'Support',
      'icon': Icons.support_agent,
      'color': Colors.purple,
    },
  ];

  // Skills grid using AppConstants
  List<Map<String, dynamic>> get skillsGrid {
    return AppConstants.skills.map((skill) {
      return {
        'name': skill,
        'icon': AppConstants.skillIcons[skill] ?? Icons.code_rounded,
        'level': AppConstants.skillLevels[skill] ?? 75,
        'color': AppConstants.skillColors[skill] ?? Colors.blueGrey,
      };
    }).toList();
  }

  // Launch project URL
  Future<void> launchProjectUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Clean up
  @override
  void dispose() {
    _hoveringSocialButtons.clear();
    super.dispose();
  }
}