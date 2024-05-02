import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:sql_query/random.dart';

class Crypt {
  Key? key;
  IV? iv;
  String? ivString;
  Encrypter? encrypter;

  Crypt(Key keyEncryptBase64, {ivs}) {
    key = Key.fromBase64(keyEncryptBase64.base64);
    ivString = ivs ?? getRandomString(6);
    iv = IV.fromUtf8(ivString!);
    encrypter ??= Encrypter(AES(key!));
  }

  decode(String encrypted) {
    final cry = base64Decode(encrypted);
    return encrypter?.decrypt(Encrypted(cry), iv: iv);
  }

  encode(text) {
    return encrypter?.encrypt(text, iv: iv).base64;
  }

  static Crypt getKeyFromBase64(String base64, {ivs}) {
    return Crypt(Key(base64Decode(base64)), ivs: ivs);
  }

  static Key getKeyEncrypt() {
    return Key.fromSecureRandom(16);
  }
}
