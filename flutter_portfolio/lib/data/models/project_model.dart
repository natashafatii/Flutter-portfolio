// lib/models/project_model.dart
class Project {
  final String title;
  final String description;
  final String shortDescription;
  final String? imageAssetPath;
  final List<String> technologies;
  final String repoUrl;
  final String? liveDemoUrl;
  final String date;
  final ProjectCategory category;
  final Map<String, dynamic>? metrics;

  Project({
    required this.title,
    required this.description,
    required this.shortDescription,
    this.imageAssetPath,
    required this.technologies,
    required this.repoUrl,
    this.liveDemoUrl,
    required this.date,
    required this.category,
    this.metrics,
  });
}

enum ProjectCategory { flutter, dataScience, fullStack, all }