import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should be return a simple sum', () async {
    //arrange
    var sum = 0;
    //act
    sum = sum + 1;

    //assert
    expect(sum, 1);
  });
}
