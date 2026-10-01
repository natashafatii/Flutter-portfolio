// lib/screens/projects/projects_screen.dart - BETTER FIXED VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/themes/text_styles.dart';
import '../../../core/utils/responsive.dart';
import 'projects_viewmodel.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Header
          SliverAppBar(
            expandedHeight: isMobile ? 200 : 250,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.1),
                      theme.colorScheme.secondary.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 60,
                    left: isMobile ? 24 : 80,
                    right: isMobile ? 24 : 80,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Portfolio',
                        style: AppTextStyles.headlineLarge.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.5, end: 0),
                      const SizedBox(height: 12),
                      Text(
                        'A showcase of my work across Flutter development, Data Science, and Full-Stack applications',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 600.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Category Filter Chips
          SliverToBoxAdapter(
            child: Consumer<ProjectsViewModel>(
              builder: (context, viewModel, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 80,
                    vertical: 20,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryChip(
                          label: 'All Projects',
                          category: ProjectCategory.all,
                          isSelected: viewModel.selectedCategory == ProjectCategory.all,
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'Flutter Apps',
                          category: ProjectCategory.flutter,
                          isSelected: viewModel.selectedCategory == ProjectCategory.flutter,
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'Data Science & AI',
                          category: ProjectCategory.dataScience,
                          isSelected: viewModel.selectedCategory == ProjectCategory.dataScience,
                        ),
                        const SizedBox(width: 12),
                        _CategoryChip(
                          label: 'Full-Stack',
                          category: ProjectCategory.fullStack,
                          isSelected: viewModel.selectedCategory == ProjectCategory.fullStack,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Projects Grid - UPDATED WITH BETTER LAYOUT
          Consumer<ProjectsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              }

              if (viewModel.projects.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.code_off_rounded,
                          size: 64,
                          color: theme.colorScheme.primary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No projects in this category',
                          style: AppTextStyles.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 80,
                  vertical: 20,
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: isMobile ? 1.5 : 1.6, // Adjusted for better look
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return _ProjectCard(
                        project: viewModel.projects[index],
                        index: index,
                      );
                    },
                    childCount: viewModel.projects.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Category Chip Widget
class _CategoryChip extends StatelessWidget {
  final String label;
  final ProjectCategory category;
  final bool isSelected;

  const _CategoryChip({
    required this.label,
    required this.category,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<ProjectsViewModel>(context, listen: false);

    return ChoiceChip(
      label: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        viewModel.selectCategory(category);
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
      ),
      elevation: isSelected ? 2 : 0,
    );
  }
}

// Project Card Widget - COMPLETELY REVISED WITH FLEXIBLE LAYOUT
class _ProjectCard extends StatelessWidget {
  final Project project;
  final int index;

  const _ProjectCard({
    required this.project,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = Provider.of<ProjectsViewModel>(context, listen: false);

    Color getCategoryColor() {
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

    IconData getCategoryIcon() {
      switch (project.category) {
        case ProjectCategory.flutter:
          return Icons.smartphone;
        case ProjectCategory.dataScience:
          return Icons.psychology;
        case ProjectCategory.fullStack:
          return Icons.layers;
        default:
          return Icons.code;
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: theme.colorScheme.surface,
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
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Date Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      getCategoryIcon(),
                      color: getCategoryColor(),
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      project.date,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: getCategoryColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Project Title
              Text(
                project.title,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: 20),

              // Description (Limited)
              Expanded(
                child: Text(
                  project.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    height: 1.4,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 20),

              // Technology Tags (Limited to 3)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.technologies.take(3).map((tech) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tech,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
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

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => viewModel.launchProjectUrl(project.repoUrl),
                      icon: const Icon(Icons.code, size: 18),
                      label: const Text('Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getCategoryColor(),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (project.liveDemoUrl != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => viewModel.launchProjectUrl(project.liveDemoUrl!),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Demo'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: getCategoryColor(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 200).ms).slideY(
      begin: 0.5,
      duration: 600.ms,
      curve: Curves.easeOut,
    );
  }
}