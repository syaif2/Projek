import 'package:flutter_test/flutter_test.dart';
import 'package:vorteks/core/utils/input_validators.dart';

void main() {
  test('username validation accepts local account names and rejects invalid input', () {
    expect(InputValidators.username('siswa_12'), isNull);
    expect(InputValidators.username('ab'), isNotNull);
    expect(InputValidators.username('nama siswa'), isNotNull);
  });

  test('registration requires a full name, class, and a password of at least six characters', () {
    expect(InputValidators.fullName('  '), isNotNull);
    expect(InputValidators.className('XII IPA 1'), isNull);
    expect(InputValidators.password('12345'), isNotNull);
    expect(InputValidators.password('123456'), isNull);
    expect(InputValidators.password('fisika123'), isNull);
  });

  test('measurement input must be a finite positive number', () {
    expect(InputValidators.positiveNumber('0'), isNotNull);
    expect(InputValidators.positiveNumber('abc'), isNotNull);
    expect(InputValidators.positiveNumber('2,5'), isNull);
  });
}
