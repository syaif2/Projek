import 'dart:math';

import 'package:cryptography/cryptography.dart';

class PasswordDigest {
  const PasswordDigest({required this.salt, required this.hash});
  final String salt;
  final String hash;
}

class PasswordService {
  PasswordService({Random? random}) : _random = random ?? Random.secure();

  static const int _iterations = 210000;
  final Random _random;
  final Pbkdf2 _kdf = Pbkdf2.hmacSha256(iterations: _iterations, bits: 256);

  Future<PasswordDigest> derive(String password) async {
    final salt = List<int>.generate(16, (_) => _random.nextInt(256));
    final key = await _kdf.deriveKeyFromPassword(password: password, nonce: salt);
    return PasswordDigest(salt: _hex(salt), hash: _hex(await key.extractBytes()));
  }

  Future<bool> verify(String password, PasswordDigest digest) async {
    final salt = _fromHex(digest.salt);
    final key = await _kdf.deriveKeyFromPassword(password: password, nonce: salt);
    final candidate = await key.extractBytes();
    final expected = _fromHex(digest.hash);
    if (candidate.length != expected.length) return false;
    var difference = 0;
    for (var i = 0; i < candidate.length; i++) {
      difference |= candidate[i] ^ expected[i];
    }
    return difference == 0;
  }

  String _hex(List<int> bytes) => bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  List<int> _fromHex(String value) {
    if (value.length.isOdd) throw const FormatException('Invalid hex data.');
    return [for (var i = 0; i < value.length; i += 2) int.parse(value.substring(i, i + 2), radix: 16)];
  }
}
