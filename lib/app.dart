import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/di/service_locator.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'features/chatbot/presentation/bloc/chatbot_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatbotBloc>(
          create: (context) => serviceLocator<ChatbotBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'GBC CoachIA',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: serviceLocator<AppRouter>().router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
