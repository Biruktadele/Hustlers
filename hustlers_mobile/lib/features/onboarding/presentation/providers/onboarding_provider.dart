import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/onboarding_repository.dart';

// This provider will be overridden in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingRepository(prefs);
});

final onboardingControllerProvider = NotifierProvider<OnboardingController, bool>(() {
  return OnboardingController();
});

class OnboardingController extends Notifier<bool> {
  @override
  bool build() {
    final repository = ref.watch(onboardingRepositoryProvider);
    return repository.isOnboardingComplete();
  }

  Future<void> completeOnboarding() async {
    final repository = ref.read(onboardingRepositoryProvider);
    await repository.setOnboardingComplete();
    state = true;
  }
}
