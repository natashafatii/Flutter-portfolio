import 'package:flutter/material.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/projects/projects_screen.dart';
import '../presentation/screens/projects/project_detail_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/projects':
        return MaterialPageRoute(builder: (_) => const ProjectsScreen());
      case '/project-detail':
        final String projectId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProjectDetailScreen(projectId: projectId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}