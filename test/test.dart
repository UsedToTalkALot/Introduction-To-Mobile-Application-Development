import 'package:flutter_test/flutter_test.dart';

void main() {
  ///given when the
  ///
  test("testing ", () {
    TestClass instance = TestClass();
    instance.addValue();
    expect(instance.a, 2);
  });
}
