import 'package:flutter/material.dart';
import 'package:portfolio_flutter/presentation/screens/projects/projects_viewmodel.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'services/theme_service.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeService(),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final viewModel = ProjectsViewModel();
            viewModel.loadLocalProjects();
            return viewModel;
          },
        ),
      ],
      child: const PortfolioApp(),
    ),
  );
}