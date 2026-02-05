import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  final SharedPreferences _prefs;

  OnboardingRepository(this._prefs);

  bool isOnboardingComplete() {
    return _prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(_onboardingCompleteKey, true);
  }
}
