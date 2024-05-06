import 'dart:convert';
import 'package:cryptography/cryptography.dart';

abstract class EncryptionService {
  Future<SecretKey> generateEncryptionKey(String password);
  Future<String> encryptText(String text, String password);
  Future<String> decryptText(String secretBoxJsonString, String password);
}

class EncryptionServiceImpl implements EncryptionService {
  /// use Pbkdf2 algorithm to generate encryptionKey from password
  @override
  Future<SecretKey> generateEncryptionKey(String password) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );

    final salt = utf8.encode('haber-salt'); // Salt value to add entropy

    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    return secretKey;
  }

  /// use AesGcm algorithm to encrypt the text to a Json String format SecretBox with encryptionKey
  @override
  Future<String> encryptText(String text, String password) async {
    final algorithm = AesGcm.with256bits();

    List<int> clearText =
        utf8.encode(text); // Convert the mnemonic to a byte array

    SecretKey encryptionKey = await generateEncryptionKey(password);
    final secretBox =
        await algorithm.encrypt(clearText, secretKey: encryptionKey);
    return secretBoxToJsonString(secretBox);
  }

  /// use AesGcm algorithm to decrypt the String format SecretBox to a text with encryptionKey
  @override
  Future<String> decryptText(
      String secretBoxJsonString, String password) async {
    SecretBox secretBox = jsonStringToSecretBox(secretBoxJsonString);

    final algorithm = AesGcm.with256bits();

    SecretKey encryptionKey = await generateEncryptionKey(password);
    final clearText = await algorithm.decrypt(
      secretBox,
      secretKey: encryptionKey,
    );

    return utf8.decode(clearText);
  }

  /// turn a SecretBox var to a Json String format
  String secretBoxToJsonString(SecretBox secretBox) {
    final secretBoxJson = {
      'cipherText': secretBox.cipherText,
      'mac': secretBox.mac.bytes,
      'nonce': secretBox.nonce,
    };
    return jsonEncode(secretBoxJson);
  }

  /// turn a Json String format var to a SecretBox
  SecretBox jsonStringToSecretBox(String jsonString) {
    final secretBoxJson = jsonDecode(jsonString);
    final cipherText = List<int>.from(secretBoxJson['cipherText']);
    final macBytes = List<int>.from(secretBoxJson['mac']);
    final nonce = List<int>.from(secretBoxJson['nonce']);
    final mac = Mac(macBytes);
    return SecretBox(cipherText, mac: mac, nonce: nonce);
  }
}

final encryptionService = EncryptionServiceImpl();
