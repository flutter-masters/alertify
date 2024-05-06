import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Counter', () {
    test('should be return a simple sum', () async {
      //arrange
      var sum = 0;
      //act
      sum = sum + 1;

      //assert
      expect(sum, 1);
    });

    test('should be return a simple subtract', () async {
      //arrange
      var value = 0;

      //act
      value = value - 1;

      //assert
      expect(value, -1);
    });
  });
}
