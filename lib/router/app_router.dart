import 'package:go_router/go_router.dart';
import 'package:expatrio/screens/onboarding_screen.dart';
import 'package:expatrio/screens/dashboard_screen.dart';
import 'package:expatrio/screens/quest_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/quest/:id',
        builder: (context, state) {
           final id = state.pathParameters['id']!;
           return QuestDetailScreen(questId: id);
        },
      ),
    ],
  );
}
