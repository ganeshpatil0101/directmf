import 'package:sink/common/exceptions.dart';
import 'package:sink/common/validations.dart';
import 'package:test/test.dart';

void main() {
  test('does not allow an empty string', () {
    expect(() => notEmpty(''), throwsA(TypeMatcher<InvalidInput>()));
  });

  test('does not allow whitespaces', () {
    expect(() => notEmpty('   '), throwsA(TypeMatcher<InvalidInput>()));
  });

  test('does not allow a null', () {
    expect(() => notEmpty(null), throwsA(TypeMatcher<InvalidInput>()));
  });

  test('does allow a valid string', () {
    notEmpty('Valid');
  });

  test('does not allow an empty string instead of a number', () {
    expect(() => nonNegative(''), throwsA(TypeMatcher<InvalidInput>()));
  });

  test('does not allow whitespaces in a number', () {
    expect(() => nonNegative('   '), throwsA(TypeMatcher<InvalidInput>()));
  });

  test('does not allow a null instead of a number', () {
    expect(() => nonNegative(null), throwsA(TypeMatcher<InvalidInput>()));
  });
  
  test('does not allow a negative number', () {
    expect(() => nonNegative('-1'), throwsA(TypeMatcher<InvalidInput>()));
  });

  test('allows a valid number', () {
    expect(() => nonNegative('0'), throwsA(TypeMatcher<InvalidInput>()));
  });
}
