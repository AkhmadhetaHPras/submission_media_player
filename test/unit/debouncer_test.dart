import 'package:flutter_test/flutter_test.dart';
import 'package:media_player/utils/debouncer.dart';

void main() {
  group('Debouncer', () {
    test('should execute the action after the specified delay', () async {
      var isActionExecuted = false;

      final debouncer = Debouncer(milliseconds: 500);
      debouncer.run(() {
        isActionExecuted = true;
      });

      await Future.delayed(const Duration(milliseconds: 450));
      expect(isActionExecuted, false);

      await Future.delayed(const Duration(milliseconds: 100));
      expect(isActionExecuted, true);
    });

    test('should cancel the previous timer when run is called multiple times',
        () async {
      int executionCount = 0;

      final debouncer = Debouncer(milliseconds: 500);
      debouncer.run(() {
        executionCount++;
      });

      // Call run multiple times with different actions
      debouncer.run(() {
        executionCount++;
      });
      debouncer.run(() {
        executionCount++;
      });

      await Future.delayed(const Duration(milliseconds: 600));
      expect(executionCount, 1); // Only the last action should be executed
    });
  });
}
