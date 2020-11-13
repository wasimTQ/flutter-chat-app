import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptDecrypt {
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter =
      encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));
  static encryptAES(text) {
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

  static decryptAES(text) {
    return encrypter.decrypt(text, iv: iv);
  }
}
