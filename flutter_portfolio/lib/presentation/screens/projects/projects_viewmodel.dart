// screens/projects/projects_viewmodel.dart - COMPLETE UPDATED
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ProjectCategory { flutter, dataScience, fullStack, all }

class Project {
  final String id;
  final String title;
  final String description;
  final String shortDescription;
  final String? imageAssetPath;
  final List<String> technologies;
  final String repoUrl;
  final String? liveDemoUrl;
  final String? liveDashboardUrl;
  final String? demoVideoUrl;
  final List<String>? screenshots;
  final String date;
  final ProjectCategory category;
  final Map<String, dynamic>? metrics;
  final bool isFeatured;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.shortDescription,
    this.imageAssetPath,
    required this.technologies,
    required this.repoUrl,
    this.liveDemoUrl,
    this.liveDashboardUrl,
    this.demoVideoUrl,
    this.screenshots,
    required this.date,
    required this.category,
    this.metrics,
    this.isFeatured = false,
  });
}

class ProjectsViewModel extends ChangeNotifier {
  List<Project> _projects = [];
  ProjectCategory _selectedCategory = ProjectCategory.all;
  bool _isLoading = false;
  String? _error;

  List<Project> get projects => _selectedCategory == ProjectCategory.all
      ? _projects
      : _projects.where((p) => p.category == _selectedCategory).toList();

  List<Project> get featuredProjects =>
      _projects.where((p) => p.isFeatured).take(3).toList();

  bool get isLoading => _isLoading;
  String? get error => _error;
  ProjectCategory get selectedCategory => _selectedCategory;

  // Get project by ID
  Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void selectCategory(ProjectCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void loadLocalProjects() {
    _isLoading = true;
    notifyListeners();

    _projects = [
      // 1. CrimeScope AI
      Project(
        id: '1',
        title: "CrimeScope AI",
        shortDescription: "Advanced crime prediction system with 91.6% accuracy",
        description: "A production-ready web application that predicts urban crime patterns using machine learning. Leverages Random Forest models to forecast crime categories and arrest probabilities with 91.6% accuracy, providing actionable insights to law enforcement.",
        imageAssetPath: "assets/images/projects/crime_scope.png",
        technologies: ["Python", "Flask", "Scikit-learn", "SQLite", "Power BI", "JavaScript"],
        repoUrl: "https://github.com/natashafatii/crime-prediction-system",
        liveDemoUrl: null,
        liveDashboardUrl: "https://crime-scope-dashboard.example.com",
        demoVideoUrl: "https://drive.google.com/file/d/1B_-3Pd3gCkZc36b1UCjjgostx2kXf2kJ/view",
        screenshots: [
          "assets/images/projects/crime_scope_1.png",
          "assets/images/projects/crime_scope_2.png",
          "assets/images/projects/crime_scope_3.png",
          "assets/images/projects/crime_scope_4.png",
          "assets/images/projects/crime_scope_5.png",
        ],
        date: "2025",
        category: ProjectCategory.dataScience,
        metrics: {"accuracy": "91.6%", "arrest_accuracy": "99.98%"},
        isFeatured: true,
      ),

      // 2. Task Management App
      Project(
        id: '2',
        title: "Task Management App",
        shortDescription: "Flutter & Firebase task management with real-time sync",
        description: "A Flutter-based Task Management App designed to help users organize, track, and manage tasks efficiently. Features Firebase integration, state management with Provider, light/dark theming, and clean architecture.",
        imageAssetPath: "assets/images/projects/task_app.png",
        technologies: ["Flutter", "Dart", "Firebase", "Firestore", "Provider", "Clean Architecture"],
        repoUrl: "https://github.com/natashafatii/Task_Management_app_flutter",
        liveDemoUrl: null,
        liveDashboardUrl: null,
        demoVideoUrl: "https://drive.google.com/file/d/1l7_nndBYTHD1VFvAS0GOzWTMFhpqELuS/view",
        screenshots: null,
        date: "2025",
        category: ProjectCategory.flutter,
        isFeatured: true,
      ),

      // 3. Dashboard Integration
      Project(
        id: '3',
        title: "Dashboard Integration",
        shortDescription: "Next.js + Power BI interactive data visualization",
        description: "A Next.js web application with embedded interactive Power BI dashboards. Visualizes project management data including timelines, task status, and team workloads with interactive filters.",
        imageAssetPath: "assets/images/projects/dashboard.png",
        technologies: ["Next.js", "React", "Power BI", "JavaScript", "Tailwind CSS"],
        repoUrl: "https://github.com/natashafatii/DashBoard_integration",
        liveDemoUrl: "http://localhost:3000/dashboard",
        liveDashboardUrl: "https://app.powerbi.com/view?r=eyJrIjoiY2JhZjM2NzMtNzUxMS00ZjBjLWFiNGYtZGIwMzU0NDk2NzZlIiwidCI6IjkwMWQ5YTk5LTI3NTgtNGM5ZS1iNWM3LTI2MWM2OTIwZmQzNyIsImMiOjl9",
        demoVideoUrl: "https://drive.google.com/file/d/10KlGiRwwu9in7K_eQ8wFt8vfHXiQNKDv/view", // UPDATED
        screenshots: null,
        date: "2025",
        category: ProjectCategory.fullStack,
        isFeatured: true,
      ),

      // 4. Reddit Sentiment Analysis - NEW PROJECT
      Project(
        id: '4',
        title: "Reddit Sentiment Analysis",
        shortDescription: "NLP pipeline for Reddit post classification & sentiment analysis",
        description: "A complete end-to-end Natural Language Processing pipeline for sentiment analysis and topic classification of Reddit posts. Features data collection via PRAW API, preprocessing with NLTK, sentiment analysis using VADER & TextBlob, and an interactive Power BI dashboard.",
        imageAssetPath: "assets/images/projects/reddit_sentiment.png",
        technologies: ["Python", "PRAW", "NLTK", "VADER", "TextBlob", "Power BI", "Pandas"],
        repoUrl: "https://github.com/natashafatii/reddit-post-classification",
        liveDemoUrl: null,  // <-- This is null
        liveDashboardUrl: "https://app.powerbi.com/view?r=eyJrIjoiY2JhZjM2NzMtNzUxMS00ZjBjLWFiNGYtZGIwMzU0NDk2NzZlIiwidCI6IjkwMWQ5YTk5LTI3NTgtNGM5ZS1iNWM3LTI2MWM2OTIwZmQzNyIsImMiOjl9",
        demoVideoUrl: null,
        screenshots: null,
        date: "2025",
        category: ProjectCategory.dataScience,
        metrics: {"model_agreement": "85%", "positive_sentiment": "42%"},
        isFeatured: true,
      ),

      // 5. Recipe Recommendation Graph RAG
      Project(
        id: '5',
        title: "Recipe Recommendation Graph RAG",
        shortDescription: "AI-powered recipe engine with Neo4j & RAG architecture",
        description: "A comprehensive recipe recommendation and question-answering system built with Neo4j graph database and Retrieval-Augmented Generation (RAG) architecture. Features multi-format document loading and hybrid retrieval.",
        imageAssetPath: "assets/images/projects/recipe_rag.png",
        technologies: ["Python", "Neo4j", "LangChain", "FAISS", "OpenAI GPT-4", "BM25"],
        repoUrl: "https://github.com/natashafatii/Recipe-recommendation-graph-rag",
        liveDemoUrl: null,
        liveDashboardUrl: null,
        demoVideoUrl: null,
        screenshots: null,
        date: "2025",
        category: ProjectCategory.dataScience,
        metrics: {"precision": "0.95", "faithfulness": "0.94"},
      ),

      // 6. Car Price Prediction
      Project(
        id: '6',
        title: "Car Price Prediction",
        shortDescription: "ML system for used car valuation with live Gradio interface",
        description: "A Machine Learning-based Car Price Prediction System that predicts resale prices based on brand, model year, engine size, mileage, and other features. Deployed with a live web interface using Gradio on Hugging Face Spaces.",
        imageAssetPath: "assets/images/projects/car_prediction.png",
        technologies: ["Python", "Scikit-learn", "Gradio", "Pandas", "Hugging Face"],
        repoUrl: "https://github.com/natashafatii/car-price-prediction",
        liveDemoUrl: "https://Natashaa0-car-price.hf.space",
        liveDashboardUrl: null,
        demoVideoUrl: null,
        screenshots: null,
        date: "2025",
        category: ProjectCategory.dataScience,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> launchProjectUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}