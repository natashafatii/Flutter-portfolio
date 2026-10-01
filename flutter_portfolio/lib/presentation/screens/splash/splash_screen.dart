import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_flutter/core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  bool _showEnterButton = false;
  bool _isImageTapped = false;
  bool _isButtonPressed = false;
  double _imageScale = 1.0;
  double _parallaxOffsetX = 0.0;
  double _parallaxOffsetY = 0.0;
  double _mouseX = 0.0;
  double _mouseY = 0.0;
  int _loadingDotsIndex = 0;

  // For typing animation - USING AppConstants
  List<String> titles = AppConstants.typingRoles;
  int currentTitleIndex = 0;
  String displayedTitle = '';
  int charIndex = 0;
  bool isDeleting = false;
  Timer? _dotsTimer;
  Timer? _mouseTracker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Start typing animation
    _startTypingAnimation();

    // Start animated dots
    _startDotsAnimation();

    // Start mouse tracking for smoother parallax
    _startMouseTracking();

    // Show enter button after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _showEnterButton = true);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache images for better performance
    _precacheImages();
  }

  void _precacheImages() {
    precacheImage(const AssetImage(AppConstants.profileImagePath), context);
  }

  void _startTypingAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      _type();
    });
  }

  void _startDotsAnimation() {
    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _loadingDotsIndex = (_loadingDotsIndex + 1) % 4;
        });
      }
    });
  }

  void _startMouseTracking() {
    // Smooth mouse tracking for parallax effect
    _mouseTracker = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          // Smooth interpolation for parallax effect
          _parallaxOffsetX += (_mouseX - _parallaxOffsetX) * 0.1;
          _parallaxOffsetY += (_mouseY - _parallaxOffsetY) * 0.1;
        });
      }
    });
  }

  void _type() {
    if (!mounted) return;

    final currentTitle = titles[currentTitleIndex];

    if (!isDeleting && charIndex < currentTitle.length) {
      // Typing forward
      setState(() {
        displayedTitle = currentTitle.substring(0, charIndex + 1);
        charIndex++;
      });
      Future.delayed(const Duration(milliseconds: 100), _type);
    } else if (isDeleting && charIndex > 0) {
      // Deleting
      setState(() {
        displayedTitle = currentTitle.substring(0, charIndex - 1);
        charIndex--;
      });
      Future.delayed(const Duration(milliseconds: 50), _type);
    } else {
      // Switch modes or titles
      if (!isDeleting) {
        // Pause at the end of typing
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() => isDeleting = true);
            _type();
          }
        });
      } else {
        // Move to next title
        setState(() {
          isDeleting = false;
          currentTitleIndex = (currentTitleIndex + 1) % titles.length;
        });
        Future.delayed(const Duration(milliseconds: 500), _type);
      }
    }
  }

  void _navigateToHome() {
    // Cancel timers before navigating
    _dotsTimer?.cancel();
    _mouseTracker?.cancel();
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _onImageTap() {
    if (!_isImageTapped) {
      _isImageTapped = true;
      _dotsTimer?.cancel(); // Stop dots animation
      _mouseTracker?.cancel(); // Stop mouse tracking
      setState(() => _imageScale = 1.2);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _imageScale = 1.0);
        }
      });

      Future.delayed(const Duration(milliseconds: 500), _navigateToHome);
    }
  }

  void _onButtonPressed() {
    if (!_isButtonPressed) {
      _isButtonPressed = true;
      _dotsTimer?.cancel(); // Stop dots animation
      _mouseTracker?.cancel(); // Stop mouse tracking
      _navigateToHome();
    }
  }

  void _onSocialLinkTap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onMouseHover(PointerHoverEvent event, Size size) {
    if (!mounted) return;

    // Calculate normalized mouse position (0 to 1)
    final mouseX = event.position.dx / size.width;
    final mouseY = event.position.dy / size.height;

    // Store mouse position for smooth tracking
    setState(() {
      _mouseX = (mouseX - 0.5) * 0.15; // Increased parallax effect
      _mouseY = (mouseY - 0.5) * 0.15;
    });
  }

  void _onMouseExit() {
    if (!mounted) return;
    setState(() {
      _mouseX = 0.0;
      _mouseY = 0.0;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _dotsTimer?.cancel();
    _mouseTracker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 768;
    final bool isDesktop = size.width > 1024;

    final Color primaryColor = theme.colorScheme.primary;
    final Color secondaryColor = theme.colorScheme.secondary;
    final Color surfaceColor = theme.colorScheme.surface;
    final Color onSurfaceColor = theme.colorScheme.onSurface;
    final Color onPrimaryColor = theme.colorScheme.onPrimary;

    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
            event.isKeyPressed(LogicalKeyboardKey.space)) {
          _onButtonPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: surfaceColor,
        body: Semantics(
          label: '${AppConstants.appName} Splash Screen - ${AppConstants.yourName}, ${AppConstants.yourTagline}', // REPLACED
          child: Stack(
            children: [
              // Animated background gradient with parallax
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(_parallaxOffsetX * -10, _parallaxOffsetY * -10),
                  child: AnimatedContainer(
                    duration: 3000.ms,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.5,
                        colors: [
                          primaryColor.withOpacity(0.1),
                          surfaceColor,
                        ],
                        stops: const [0.2, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              if (isDesktop)
                Positioned.fill(
                  child: RepaintBoundary(
                    child: Transform.translate(
                      offset: Offset(_parallaxOffsetX * 5, _parallaxOffsetY * 5),
                      child: Stack(
                        children: List.generate(20, (index) {
                          final parallaxFactor = 0.5 + (index % 3) * 0.3;
                          return Positioned(
                            left: (index * 97) % size.width,
                            top: (index * 73) % size.height,
                            child: Transform.translate(
                              offset: Offset(
                                _parallaxOffsetX * 8 * parallaxFactor,
                                _parallaxOffsetY * 8 * parallaxFactor,
                              ),
                              child: Container(
                                width: 2 + (index % 4).toDouble(),
                                height: 2 + (index % 4).toDouble(),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.2 + (index % 5) * 0.05),
                                  shape: BoxShape.circle,
                                ),
                              ).animate(
                                onPlay: (controller) => controller.repeat(reverse: true),
                              ).scale(
                                delay: (index * 150).ms,
                                duration: 2500.ms + (index * 100).ms,
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1.2, 1.2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),

              // Main Content
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 80,
                    vertical: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side - Text content
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Greeting text with subtle parallax
                            Transform.translate(
                              offset: Offset(_parallaxOffsetX * 2, _parallaxOffsetY * 2),
                              child: Semantics(
                                label: 'Greeting message',
                                child: Text(
                                  "Hello, It's Me",
                                  style: GoogleFonts.montserrat(
                                    fontSize: isMobile ? 24 : 32,
                                    fontWeight: FontWeight.w300,
                                    color: onSurfaceColor.withOpacity(0.8),
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms)
                                  .slide(
                                begin: const Offset(-0.5, 0),
                                end: Offset.zero,
                                duration: 800.ms,
                                curve: Curves.easeOut,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Name with gradient effect and parallax
                            Transform.translate(
                              offset: Offset(_parallaxOffsetX * 3, _parallaxOffsetY * 3),
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(bounds);
                                },
                                child: Semantics(
                                  label: 'My name is ${AppConstants.yourName}',
                                  child: Text(
                                    AppConstants.yourName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: isMobile ? 42 : 56,
                                      fontWeight: FontWeight.w800,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 300.ms)
                                  .slide(
                                begin: const Offset(-0.3, 0),
                                end: Offset.zero,
                                duration: 800.ms,
                                delay: 300.ms,
                                curve: Curves.easeOut,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Animated title with cursor and parallax
                            Transform.translate(
                              offset: Offset(_parallaxOffsetX * 1.5, _parallaxOffsetY * 1.5),
                              child: Semantics(
                                label: 'My profession is $displayedTitle',
                                child: SizedBox(
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'And I\'m a ',
                                        style: GoogleFonts.inter(
                                          fontSize: isMobile ? 22 : 28,
                                          fontWeight: FontWeight.w500,
                                          color: onSurfaceColor.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Animated title text
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: isMobile ? size.width * 0.5 : 400,
                                        ),
                                        child: Text(
                                          displayedTitle,
                                          style: GoogleFonts.inter(
                                            fontSize: isMobile ? 22 : 28,
                                            fontWeight: FontWeight.w700,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      // Blinking cursor
                                      Container(
                                        width: 3,
                                        height: 35,
                                        color: primaryColor,
                                        margin: const EdgeInsets.only(left: 5),
                                      )
                                          .animate(
                                        onPlay: (controller) => controller.repeat(),
                                      )
                                          .fade(duration: 800.ms),
                                    ],
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 600.ms),
                            ),

                            const SizedBox(height: 30),

                            // Description with subtle parallax
                            Transform.translate(
                              offset: Offset(_parallaxOffsetX * 1, _parallaxOffsetY * 1),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: isMobile ? double.infinity : 600,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: isMobile ? 16 : 18,
                                      color: onSurfaceColor.withOpacity(0.7),
                                      height: 1.6,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text:
                                        "I'm a Web Designer with extensive experience for over 3 years. ",
                                      ),
                                      TextSpan(
                                        text:
                                        "My expertise is to create and design websites, Frontend design, and many more...",
                                        style: TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 900.ms),
                            ),

                            const SizedBox(height: 20),

                            // Social Links (GitHub & LinkedIn) with parallax
                            if (_showEnterButton)
                              Transform.translate(
                                offset: Offset(_parallaxOffsetX * 2, _parallaxOffsetY * 2),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => _onSocialLinkTap(AppConstants.githubUrl),
                                      icon: Icon(
                                        Icons.code,
                                        color: onSurfaceColor.withOpacity(0.6),
                                        size: 24,
                                      ),
                                      tooltip: 'GitHub Profile',
                                    ),
                                    IconButton(
                                      onPressed: () => _onSocialLinkTap(AppConstants.linkedinUrl),
                                      icon: Icon(
                                        Icons.work,
                                        color: onSurfaceColor.withOpacity(0.6),
                                        size: 24,
                                      ),
                                      tooltip: 'LinkedIn Profile',
                                    ),
                                    if (AppConstants.yourEmail.isNotEmpty)
                                      IconButton(
                                        onPressed: () async {
                                          // Using AppConstants.emailUri - REPLACED
                                          if (await canLaunchUrl(AppConstants.emailUri)) {
                                            await launchUrl(AppConstants.emailUri);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.email,
                                          color: onSurfaceColor.withOpacity(0.6),
                                          size: 24,
                                        ),
                                        tooltip: 'Send Email',
                                      ),
                                  ],
                                )
                                    .animate()
                                    .fadeIn(duration: 800.ms, delay: 1200.ms),
                              ),

                            const SizedBox(height: 30),

                            // Enter button with keyboard hint and parallax
                            AnimatedOpacity(
                              opacity: _showEnterButton ? 1.0 : 0.0,
                              duration: 500.ms,
                              child: Transform.translate(
                                offset: Offset(_parallaxOffsetX * 3, _parallaxOffsetY * 3),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSlide(
                                      offset: _showEnterButton
                                          ? Offset.zero
                                          : const Offset(0, 0.5),
                                      duration: 600.ms,
                                      curve: Curves.easeOutBack,
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Focus(
                                          autofocus: true,
                                          child: ElevatedButton.icon(
                                            onPressed: _onButtonPressed,
                                            icon: const Icon(Icons.arrow_forward_rounded),
                                            label: const Text(
                                              'Explore Portfolio',
                                              style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 40,
                                                vertical: 20,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              backgroundColor: primaryColor,
                                              foregroundColor: onPrimaryColor,
                                              elevation: 8,
                                              shadowColor: primaryColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Press Enter or Click to continue',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: onSurfaceColor.withOpacity(0.5),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Enhanced animated dots loading indicator
                            if (!_showEnterButton)
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        for (int i = 0; i < 4; i++)
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 4),
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(
                                                i == _loadingDotsIndex ? 1.0 : 0.3,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          )
                                              .animate(
                                            delay: (i * 150).ms,
                                            onPlay: (controller) => controller.repeat(),
                                          )
                                              .scale(
                                            duration: 600.ms,
                                            begin: const Offset(1.0, 1.0),
                                            end: const Offset(1.3, 1.3),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          'Loading portfolio',
                                          style: TextStyle(
                                            color: onSurfaceColor.withOpacity(0.6),
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        // Animated ellipsis
                                        Text(
                                          List.filled((_loadingDotsIndex % 4), '.')
                                              .join(''),
                                          style: TextStyle(
                                            color: primaryColor.withOpacity(0.7),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Right side - Image (hidden on mobile) with ORIGINAL design
                      if (!isMobile)
                        Expanded(
                          child: Center(
                            child: MouseRegion(
                              onHover: (event) => _onMouseHover(event, size),
                              onExit: (_) => _onMouseExit(),
                              child: Transform.translate(
                                offset: Offset(_parallaxOffsetX * 20, _parallaxOffsetY * 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Pulse animation container with ORIGINAL design
                                    Container(
                                      width: 400,
                                      height: 400,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            primaryColor.withOpacity(0.2),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: AnimatedScale(
                                          scale: _imageScale,
                                          duration: 300.ms,
                                          curve: Curves.easeInOut,
                                          child: GestureDetector(
                                            onTap: _onImageTap,
                                            child: Hero(
                                              tag: 'profileImage',
                                              child: Semantics(
                                                label: 'Profile picture of ${AppConstants.yourName}',
                                                child: Container(
                                                  width: 340,
                                                  height: 340,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: primaryColor.withOpacity(0.5),
                                                      width: 4,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: primaryColor.withOpacity(0.3),
                                                        blurRadius: 30,
                                                        spreadRadius: 10,
                                                        offset: Offset(
                                                          _parallaxOffsetX * 5,
                                                          _parallaxOffsetY * 5,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipOval(
                                                    child: Image.asset(
                                                      AppConstants.profileImagePath, // REPLACED
                                                      width: 340,
                                                      height: 340,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (context, error, stackTrace) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                primaryColor,
                                                                secondaryColor,
                                                              ],
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                            ),
                                                          ),
                                                          child: Icon(
                                                            Icons.person,
                                                            size: 120,
                                                            color: onPrimaryColor,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                        .animate(
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true),
                                    )
                                        .scale(
                                      duration: 2000.ms,
                                      begin: const Offset(0.95, 0.95),
                                      end: const Offset(1.05, 1.05),
                                    )
                                        .animate()
                                        .fadeIn(duration: 1000.ms, delay: 500.ms),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Mobile view image (at bottom) with ORIGINAL design
              if (isMobile)
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _onImageTap,
                      child: Semantics(
                        label: 'Profile picture of ${AppConstants.yourName}',
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor.withOpacity(0.5),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              AppConstants.profileImagePath, // REPLACED
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [primaryColor, secondaryColor],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: onPrimaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms, delay: 1200.ms)
                        .slide(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                      duration: 800.ms,
                      delay: 1200.ms,
                    ),
                  ),
                ),

              // Bottom copyright with parallax
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Transform.translate(
                  offset: Offset(_parallaxOffsetX * 5, _parallaxOffsetY * 5),
                  child: AnimatedOpacity(
                    opacity: _showEnterButton ? 1.0 : 0.0,
                    duration: 500.ms,
                    child: Column(
                      children: [
                        Text(
                          '${AppConstants.appName} v${AppConstants.appVersion}', // REPLACED
                          style: TextStyle(
                            fontSize: 12,
                            color: onSurfaceColor.withOpacity(0.5),
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Made with ❤️ using Flutter',
                          style: TextStyle(
                            fontSize: 11,
                            color: onSurfaceColor.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}