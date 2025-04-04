import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/theme/app_colors.dart';
import 'config/di/service_locator.dart';
import 'config/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/documents/presentation/bloc/document_bloc.dart';
import 'features/finance/presentation/bloc/finance_bloc.dart';
import 'features/planner/presentation/bloc/planner_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider<ChatbotBloc>(
          create: (context) => serviceLocator<ChatbotBloc>(),
        ),
        BlocProvider<PlannerBloc>(
          create: (context) => serviceLocator<PlannerBloc>(),
        ),
        BlocProvider<FinanceBloc>(
          create: (context) => serviceLocator<FinanceBloc>(),
        ),
        BlocProvider<DocumentBloc>(
          create: (context) => serviceLocator<DocumentBloc>(),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) => serviceLocator<DashboardBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'GBC CoachIA',
        theme: AppColors.lightTheme,
        darkTheme: AppColors.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
