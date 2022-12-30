import 'dart:convert';

import 'package:encrypt/encrypt.dart';

class Crypt {
  Key? key;
  IV? iv;
  Encrypter? encrypter;

  Crypt(Key keyEncryptBase64) {
    key = Key.fromBase64(keyEncryptBase64.base64);
    iv = IV.fromLength(16);
    encrypter ??= Encrypter(AES(key!));
  }

  decode(String encrypted) {
    final cry = base64Decode(encrypted);
    return encrypter?.decrypt(Encrypted(cry), iv: iv);
  }

  encode(text) {
    return encrypter?.encrypt(text, iv: iv).base64;
  }

  static Crypt getKeyFromBase64(String base64) {
    return Crypt(Key(base64Decode(base64)));
  }

  static Key getKeyEncrypt() {
    return Key.fromSecureRandom(16);
  }
}
