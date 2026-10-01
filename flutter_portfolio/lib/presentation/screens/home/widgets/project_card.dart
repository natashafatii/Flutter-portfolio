// lib/screens/home/widgets/project_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../core/themes/text_styles.dart';
import '../../projects/projects_viewmodel.dart';
import '../../projects/project_detail_screen.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final int index;
  final bool isMobile;

  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectsViewModel = Provider.of<ProjectsViewModel>(context, listen: false);

    Color getProjectColor() {
      switch (project.category) {
        case ProjectCategory.flutter:
          return const Color(0xFF02569B);
        case ProjectCategory.dataScience:
          return const Color(0xFF4CAF50);
        case ProjectCategory.fullStack:
          return const Color(0xFFFF9800);
        default:
          return theme.colorScheme.primary;
      }
    }

    IconData getProjectIcon() {
      switch (project.category) {
        case ProjectCategory.flutter:
          return Icons.flutter_dash_rounded;
        case ProjectCategory.dataScience:
          return Icons.psychology_rounded;
        case ProjectCategory.fullStack:
          return Icons.layers_rounded;
        default:
          return Icons.code_rounded;
      }
    }

    String getCategoryLabel() {
      switch (project.category) {
        case ProjectCategory.flutter:
          return 'Flutter App';
        case ProjectCategory.dataScience:
          return 'Data Science';
        case ProjectCategory.fullStack:
          return 'Full-Stack';
        default:
          return 'Project';
      }
    }

    final projectColor = getProjectColor();
    final projectIcon = getProjectIcon();
    final categoryLabel = getCategoryLabel();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailScreen(projectId: project.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        projectColor.withOpacity(0.2),
                        projectColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    projectIcon,
                    color: projectColor,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 24),

                // Project Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: projectColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          categoryLabel,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: projectColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Project Title
                      Text(
                        project.title,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Short Description
                      Text(
                        project.shortDescription,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),

                      // Technology Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.technologies.take(3).map((tech) {
                          return Chip(
                            label: Text(tech),
                            backgroundColor: projectColor.withOpacity(0.1),
                            labelStyle: AppTextStyles.labelSmall.copyWith(
                              color: projectColor,
                            ),
                          );
                        }).toList(),
                      ),

                      // Show "+X more" if there are more than 3 technologies
                      if (project.technologies.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '+${project.technologies.length - 3} more',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // View Button
                if (!isMobile)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailScreen(projectId: project.id),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (1600 + index * 300).ms)
        .slideX(
      begin: 0.5,
      duration: 600.ms,
      curve: Curves.easeOut,
    );
  }
}