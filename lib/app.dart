import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/di/service_locator.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'features/finance/presentation/bloc/finance_bloc.dart';
import 'features/planner/presentation/bloc/planner_bloc.dart';

/// Widget principal de l'application
class App extends StatelessWidget {
  /// Constructeur
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter();
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>()..add(const AppStarted()),
        ),
        BlocProvider<ChatbotBloc>(
          create: (_) => getIt<ChatbotBloc>(),
        ),
        BlocProvider<PlannerBloc>(
          create: (_) => getIt<PlannerBloc>(),
        ),
        BlocProvider<FinanceBloc>(
          create: (_) => getIt<FinanceBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'GBC CoachIA',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
