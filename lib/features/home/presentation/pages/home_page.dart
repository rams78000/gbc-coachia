import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/app_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_theme.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeContent(),
    const Center(child: Text('Notifications')),
    const Center(child: Text('Settings')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        final displayName = user?.displayName ?? 'Entrepreneur';

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            displayName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRouter.profile),
                        child: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 24,
                          child: user?.photoURL != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.network(
                                    user!.photoURL!,
                                    fit: BoxFit.cover,
                                    width: 48,
                                    height: 48,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Text(
                                        displayName.isNotEmpty ? displayName[0] : 'U',
                                        style: const TextStyle(color: Colors.white),
                                      );
                                    },
                                  ),
                                )
                              : Text(
                                  displayName.isNotEmpty ? displayName[0] : 'U',
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                // AI Assistant quick access
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  child: InkWell(
                    onTap: () => context.push(AppRouter.chatbot),
                    borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                    child: Container(
                      padding: EdgeInsets.all(AppTheme.spacing(3)),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          SizedBox(width: AppTheme.spacing(2)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Business Assistant',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppTheme.spacing(1)),
                                Text(
                                  'Ask questions, get insights, and optimize your business',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Features section
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  child: Text(
                    'Features',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  mainAxisSpacing: AppTheme.spacing(2),
                  crossAxisSpacing: AppTheme.spacing(2),
                  children: [
                    FeatureCard(
                      title: 'Smart Planner',
                      description: 'Manage your schedule and tasks',
                      icon: Icons.calendar_today,
                      onTap: () => context.push(AppRouter.planner),
                    ),
                    FeatureCard(
                      title: 'Finance Tracker',
                      description: 'Track income and expenses',
                      icon: Icons.account_balance_wallet,
                      onTap: () => context.push(AppRouter.finance),
                    ),
                    FeatureCard(
                      title: 'Documents',
                      description: 'Create invoices and contracts',
                      icon: Icons.description,
                      onTap: () => context.push(AppRouter.documents),
                    ),
                    FeatureCard(
                      title: 'Dashboard',
                      description: 'View key business metrics',
                      icon: Icons.dashboard,
                      onTap: () => context.push(AppRouter.dashboard),
                    ),
                  ],
                ),

                // Quick actions
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacing(2)),
                  child: Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing(2)),
                    children: [
                      _buildQuickAction(
                        context,
                        title: 'New Task',
                        icon: Icons.add_task,
                        color: Colors.blue,
                        onTap: () => context.push(AppRouter.planner),
                      ),
                      _buildQuickAction(
                        context,
                        title: 'New Invoice',
                        icon: Icons.receipt_long,
                        color: Colors.green,
                        onTap: () => context.push(AppRouter.documents),
                      ),
                      _buildQuickAction(
                        context,
                        title: 'Add Expense',
                        icon: Icons.money_off,
                        color: Colors.red,
                        onTap: () => context.push(AppRouter.finance),
                      ),
                      _buildQuickAction(
                        context,
                        title: 'Ask AI',
                        icon: Icons.psychology,
                        color: AppColors.primary,
                        onTap: () => context.push(AppRouter.chatbot),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: AppTheme.spacing(4)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: AppTheme.spacing(2)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
        child: Container(
          width: 100,
          padding: EdgeInsets.all(AppTheme.spacing(2)),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              SizedBox(height: AppTheme.spacing(1)),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
