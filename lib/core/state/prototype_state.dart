import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final prototypeStateProvider = ChangeNotifierProvider<PrototypeState>(
  (ref) => PrototypeState(),
);

class PrototypeState extends ChangeNotifier {
  // Steps 28–36 are scripted UI simulations. Keep no chatbot model,
  // configuration, training, prompt, or test-result state here.
  String parentName = 'Parent';
  String learnerName = 'Max';
  String ageRange = '6–11 yr';
  String language = 'English';
  bool parentApproved = false;
  int completedSteps = 0;
  int honey = 128;
  int xp = 340;
  final Set<String> ownedAccessories = {'Moon Glasses', 'Rocket Pack'};
  String equippedAccessory = 'Rocket Pack';

  bool get courseStarted => completedSteps > 0;
  double get progress => completedSteps / 36;

  void setParentName(String value) {
    parentName = value.trim();
    notifyListeners();
  }

  void saveLearner({
    required String nickname,
    required String age,
    required String preferredLanguage,
  }) {
    learnerName = nickname.trim();
    ageRange = age;
    language = preferredLanguage;
    notifyListeners();
  }

  void approveParent() {
    parentApproved = true;
    notifyListeners();
  }

  void startCourse() {
    if (completedSteps == 0) completedSteps = 1;
    notifyListeners();
  }

  void completeActivity(int step) {
    if (step > completedSteps) {
      completedSteps = step;
      xp += 10;
      honey += 5;
      notifyListeners();
    }
  }

  bool buy(String name, int price) {
    if (ownedAccessories.contains(name)) return true;
    if (honey < price) return false;
    honey -= price;
    ownedAccessories.add(name);
    notifyListeners();
    return true;
  }

  void equip(String name) {
    if (!ownedAccessories.contains(name)) return;
    equippedAccessory = name;
    notifyListeners();
  }
}
