// lib/screens/home/widgets/skills_section.dart
import 'package:flutter/material.dart';

import '../../../../core/themes/text_styles.dart';
import 'skills_grid.dart';

class SkillsSection extends StatelessWidget {
  final bool isMobile;

  const SkillsSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tech Stack & Skills',
          style: AppTextStyles.headlineLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),
        SkillsGrid(isMobile: isMobile),
      ],
    );
  }
}