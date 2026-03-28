import 'dart:io';

void main() {
  print('--- ARCHITECTURE VALIDATION START ---');
  bool hasError = false;

  final projectRoot = Directory.current;
  final libDir = Directory('${projectRoot.path}/lib');

  if (!libDir.existsSync()) {
    print('[ERROR] lib directory not found at ${libDir.path}');
    return;
  }

  // 1. Presentation Layer Check
  final presentationDir = Directory('${libDir.path}/presentation');
  if (presentationDir.existsSync()) {
    if (_checkDirForText(presentationDir, 'shared_preferences')) {
      print('[FAIL] Presentation layer is accessing SharedPreferences directly!');
      hasError = true;
    }
  }

  // 2. Domain Layer Check
  final domainDir = Directory('${libDir.path}/domain');
  if (domainDir.existsSync()) {
    if (_checkDirForText(domainDir, 'shared_preferences')) {
      print('[FAIL] Domain layer is accessing SharedPreferences directly!');
      hasError = true;
    }
  }

  // 3. Data Layer Check
  final dataDir = Directory('${libDir.path}/data');
  if (dataDir.existsSync()) {
    if (_checkDirForText(dataDir, 'ChangeNotifier')) {
      print('[FAIL] Data layer contains UI logic (ChangeNotifier)!');
      hasError = true;
    }
  }

  if (!hasError) {
    print('[PASS] Architecture boundaries are intact.');
  } else {
    print('[RESULT] Architecture validation failed. Please review the errors above.');
  }
  print('--- VALIDATION COMPLETE ---');
}


bool _checkDirForText(Directory dir, String text) {
  bool found = false;
  try {
    final files = dir.listSync(recursive: true);
    for (var entity in files) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final contents = entity.readAsStringSync();
        if (contents.contains(text)) {
          print('  Violation found in: ${entity.path}');
          found = true;
        }
      }
    }
  } catch (e) {
    print('[ERROR] Could not scan directory ${dir.path}: $e');
  }
  return found;
}
