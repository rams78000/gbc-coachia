import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/di/service_locator.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'features/documents/presentation/bloc/documents_bloc.dart';
import 'features/finance/presentation/bloc/finance_bloc.dart';
import 'features/planner/presentation/bloc/planner_bloc.dart';

/// Main app widget
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatbotBloc>(
          create: (context) => serviceLocator<ChatbotBloc>(),
        ),
        BlocProvider<PlannerBloc>(
          create: (context) => PlannerBloc(),
        ),
        BlocProvider<FinanceBloc>(
          create: (context) => FinanceBloc(),
        ),
        BlocProvider<DocumentsBloc>(
          create: (context) => DocumentsBloc(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRoutes.splash,
      ),
    );
  }
}
