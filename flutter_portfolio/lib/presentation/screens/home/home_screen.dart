// screens/home/home_screen.dart - CLEANED VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../services/theme_service.dart';
import '../../../core/themes/text_styles.dart';
import '../../../core/utils/responsive.dart';

import 'home_viewmodel.dart';
import '../projects/projects_viewmodel.dart';
import 'widgets/skills_section.dart';
import 'widgets/project_card.dart'; // ADD THIS IMPORT

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(
          create: (context) => ProjectsViewModel()..loadLocalProjects(),
        ),
      ],
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Auto-rotate titles
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final viewModel = Provider.of<HomeViewModel>(context, listen: false);
        _rotateTitle(viewModel);
      }
    });

    // Hide scroll indicator after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Provider.of<HomeViewModel>(context, listen: false).hideScrollIndicator();
      }
    });
  }

  void _rotateTitle(HomeViewModel viewModel) {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        viewModel.rotateTitle();
        _rotateTitle(viewModel);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final projectsViewModel = Provider.of<ProjectsViewModel>(context);
    final isMobile = Responsive.isMobile(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Animated Background
          Positioned.fill(
            child: AnimatedContainer(
              duration: 1000.ms,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.05),
                    theme.colorScheme.surface,
                  ],
                ),
              ),
            ),
          ),

          // Floating Particles
          if (!isMobile) ...[
            for (int i = 0; i < 8; i++)
              Positioned(
                top: 100 + i * 80,
                left: (i % 3) * (size.width / 3),
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ).animate(
                  onPlay: (controller) => controller.repeat(),
                ).scale(delay: (i * 200).ms, duration: 2000.ms),
              ),
          ],

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Section
              SliverAppBar(
                expandedHeight: isMobile ? size.height * 0.7 : size.height * 0.8,
                floating: false,
                pinned: true,
                snap: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final availableHeight = constraints.maxHeight;
                    final showSocialLinks = availableHeight > 500 && !isMobile;

                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: SizedBox(
                        height: availableHeight,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 60,
                              left: isMobile ? 20 : 80,
                              right: isMobile ? 20 : 80,
                              bottom: 40,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Greeting with floating animation
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary.withOpacity(0.2),
                                        theme.colorScheme.secondary.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: theme.colorScheme.primary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: theme.colorScheme.primary,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Hello, Welcome!',
                                        style: AppTextStyles.labelLarge.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .slideX(begin: -1, duration: 800.ms, curve: Curves.easeOutCubic)
                                    .fadeIn(duration: 800.ms),

                                const SizedBox(height: 20),

                                // Name with gradient text
                                ShaderMask(
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary,
                                        theme.colorScheme.secondary,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    homeViewModel.yourName,
                                    style: AppTextStyles.displayLarge.copyWith(
                                      fontWeight: FontWeight.w800,
                                      height: 0.9,
                                      fontSize: isMobile ? 48 : 64,
                                    ),
                                  ),
                                )
                                    .animate()
                                    .scaleXY(
                                  begin: 0.8,
                                  end: 1,
                                  duration: 1000.ms,
                                  curve: Curves.elasticOut,
                                )
                                    .fadeIn(duration: 1000.ms),

                                const SizedBox(height: 12),

                                // Animated rotating title
                                AnimatedSwitcher(
                                  duration: 500.ms,
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.5),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    homeViewModel.titles[homeViewModel.currentTitleIndex],
                                    key: ValueKey(homeViewModel.currentTitleIndex),
                                    style: AppTextStyles.headlineMedium.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isMobile ? 20 : 28,
                                      shadows: [
                                        Shadow(
                                          color: theme.colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Bio with typewriter effect simulation
                                SizedBox(
                                  width: isMobile ? double.infinity : size.width * 0.5,
                                  child: Text(
                                    homeViewModel.yourBio,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                                      height: 1.6,
                                      fontSize: isMobile ? 14 : 16,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                      .animate(
                                    onPlay: (controller) => controller.forward(),
                                  )
                                      .fadeIn(duration: 1200.ms, delay: 300.ms),
                                ),

                                const SizedBox(height: 32),

                                // Animated CTA Buttons - Use Column for better control on mobile
                                isMobile
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    FilledButton.icon(
                                      onPressed: () => Navigator.pushNamed(context, '/projects'),
                                      icon: const Icon(Icons.rocket_launch_outlined),
                                      label: const Text('Explore Projects'),
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton.icon(
                                      onPressed: () => Navigator.pushNamed(context, '/contact'),
                                      icon: const Icon(Icons.contact_mail_outlined),
                                      label: const Text('Get In Touch'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    // Primary CTA with hover effect
                                    MouseRegion(
                                      onEnter: (_) => homeViewModel.setHoveringProjectsButton(true),
                                      onExit: (_) => homeViewModel.setHoveringProjectsButton(false),
                                      cursor: SystemMouseCursors.click,
                                      child: FilledButton.icon(
                                        onPressed: () => Navigator.pushNamed(context, '/projects'),
                                        icon: const Icon(Icons.rocket_launch_outlined),
                                        label: const Text('Explore Projects'),
                                        style: FilledButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 18,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                          shadowColor: theme.colorScheme.primary.withOpacity(0.3),
                                        ),
                                      )
                                          .animate()
                                          .scale(
                                        delay: 1000.ms,
                                        duration: 600.ms,
                                        curve: Curves.elasticOut,
                                      ),
                                    ),

                                    // Secondary CTA with outline
                                    MouseRegion(
                                      onEnter: (_) => homeViewModel.setHoveringContactButton(true),
                                      onExit: (_) => homeViewModel.setHoveringContactButton(false),
                                      cursor: SystemMouseCursors.click,
                                      child: OutlinedButton.icon(
                                        onPressed: () => Navigator.pushNamed(context, '/contact'),
                                        icon: const Icon(Icons.contact_mail_outlined),
                                        label: const Text('Get In Touch'),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 18,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          side: BorderSide(
                                            color: theme.colorScheme.primary.withOpacity(0.5),
                                            width: 1.5,
                                          ),
                                        ),
                                      )
                                          .animate()
                                          .scale(
                                        delay: 1100.ms,
                                        duration: 600.ms,
                                        curve: Curves.elasticOut,
                                      ),
                                    ),

                                    // Download Resume Button
                                    FilledButton.tonalIcon(
                                      onPressed: () {
                                        // TODO: Implement resume download
                                      },
                                      icon: const Icon(Icons.download_outlined),
                                      label: const Text('Download CV'),
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                    )
                                        .animate()
                                        .scale(
                                      delay: 1200.ms,
                                      duration: 600.ms,
                                      curve: Curves.elasticOut,
                                    ),
                                  ],
                                ),

                                // Social Links - Only show if enough space
                                if (showSocialLinks) ...[
                                  const SizedBox(height: 40),
                                  Row(
                                    children: [
                                      Text(
                                        'Connect with me:',
                                        style: AppTextStyles.labelLarge.copyWith(
                                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      ...homeViewModel.socialPlatforms.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final platform = entry.value;
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: Tooltip(
                                            message: platform['name'] as String,
                                            child: MouseRegion(
                                              onEnter: (_) => homeViewModel.setHoveringSocialButton(index, true),
                                              onExit: (_) => homeViewModel.setHoveringSocialButton(index, false),
                                              child: Material(
                                                borderRadius: BorderRadius.circular(12),
                                                color: homeViewModel.isSocialButtonHovering(index)
                                                    ? (platform['color'] as Color).withOpacity(0.1)
                                                    : theme.colorScheme.surface,
                                                elevation: 2,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(12),
                                                  onTap: () => homeViewModel.launchSocial(platform['url'] as String),
                                                  child: Container(
                                                    padding: const EdgeInsets.all(12),
                                                    child: Icon(
                                                      platform['icon'] as IconData,
                                                      size: 20,
                                                      color: homeViewModel.isSocialButtonHovering(index)
                                                          ? platform['color'] as Color
                                                          : theme.colorScheme.primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                              .animate()
                                              .fadeIn(delay: (1300 + index * 100).ms),
                                        );
                                      }),
                                    ],
                                  ),
                                ],

                                // Add flexible space at the bottom if needed
                                if (availableHeight > 700) SizedBox(height: availableHeight * 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                actions: [
                  // Theme Toggle with Neumorphic Design
                  Container(
                    margin: const EdgeInsets.only(right: 20, top: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(2, 2),
                        ),
                        BoxShadow(
                          color: theme.colorScheme.surface.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(-2, -2),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.surface,
                      child: IconButton(
                        icon: AnimatedSwitcher(
                          duration: 300.ms,
                          child: Icon(
                            themeService.isDarkMode
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            key: ValueKey(themeService.isDarkMode),
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        onPressed: themeService.toggleTheme,
                        tooltip: themeService.isDarkMode
                            ? 'Switch to Light'
                            : 'Switch to Dark',
                      ),
                    ),
                  ),
                ],
              ),

              // Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 80,
                    vertical: 40,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.secondary.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile ? 2 : 4,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                        childAspectRatio: isMobile ? 1.2 : 1.5,
                      ),
                      itemCount: homeViewModel.stats.length,
                      itemBuilder: (context, index) {
                        final stat = homeViewModel.stats[index];
                        final statColor = stat['color'] as Color;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    statColor.withOpacity(0.2),
                                    statColor.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: Icon(
                                stat['icon'] as IconData,
                                color: statColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              stat['value'] as String,
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: statColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              stat['label'] as String,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(delay: (1400 + index * 200).ms)
                            .slideY(
                          begin: 0.5,
                          duration: 600.ms,
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Featured Projects - USING SEPARATE WIDGET
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 80,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Featured Work',
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
                            ],
                          ),
                          FilledButton.icon(
                            onPressed: () => Navigator.pushNamed(context, '/projects'),
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Featured Projects List - USING SEPARATE WIDGET
                      if (projectsViewModel.featuredProjects.isNotEmpty)
                        Column(
                          children: projectsViewModel.featuredProjects
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final project = entry.value;

                            return ProjectCard( // USING SEPARATE WIDGET
                              project: project,
                              index: index,
                              isMobile: isMobile,
                            );
                          }).toList(),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: theme.colorScheme.surface,
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.code_off_rounded,
                                size: 48,
                                color: theme.colorScheme.primary.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No featured projects available',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Skills Section - USING SEPARATE WIDGET
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 80,
                    vertical: 40,
                  ),
                  child: SkillsSection(isMobile: isMobile),
                ),
              ),

              // CTA Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 80,
                    vertical: 60,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.1),
                          theme.colorScheme.secondary.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ready to Build Something Amazing?',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Let\'s collaborate and turn your ideas into reality with cutting-edge technology and innovative solutions.',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        FilledButton(
                          onPressed: () => Navigator.pushNamed(context, '/contact'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 22,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Start Conversation'),
                              SizedBox(width: 12),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Scroll Indicator
          if (homeViewModel.showScrollIndicator)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'Scroll to explore',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  )
                      .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                      .slideY(
                    duration: 1000.ms,
                    begin: 0.0,
                    end: 0.3,
                  ),
                ],
              ),
            ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/contact'),
        icon: const Icon(Icons.message),
        label: const Text('Hire Me'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      )
          .animate()
          .scale(
        delay: 1500.ms,
        duration: 800.ms,
        curve: Curves.elasticOut,
      )
          .slideY(
        begin: 1.0,
        end: 0.0,
        delay: 1500.ms,
        duration: 800.ms,
        curve: Curves.elasticOut,
      ),
    );
  }

}