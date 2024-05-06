import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:haber/services/storage_service.dart';
import 'package:haber/services/encryption_service.dart';
import 'package:haber/services/mnemonic_service.dart';
import 'package:haber/services/key_pairs_service.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';

class MockStorageService extends Mock implements StorageService {}

class MockEncryptionService extends Mock implements EncryptionService {}

class MockMnemonicService extends Mock implements MnemonicService {}

void main() {
  FlutterSecureStorage.setMockInitialValues({});
  group('StorageService', () {
    late StorageService storageService;
    setUp(() {
      storageService = StorageServiceImpl();
    });
    test('should store and retrieve value safely', () async {
      final key = 'test_key';
      final value = 'test_value';
      await storageService.safeStore(key, value);
      final retrievedValue = await storageService.safeRead(key);
      expect(retrievedValue, equals(value));
    });
  });

  group('EncryptionService', () {
    late EncryptionService encryptionService;
    setUp(() {
      encryptionService = EncryptionServiceImpl();
    });
    test('should encrypt and decrypt text correctly', () async {
      final text = 'test_text';
      final password = 'test_password';
      final encryptedText = await encryptionService.encryptText(text, password);
      final decryptedText =
          await encryptionService.decryptText(encryptedText, password);
      expect(decryptedText, equals(text));
    });
  });

  group('MnemonicService', () {
    late MnemonicService mnemonicService;
    late StorageService storageService;
    late EncryptionService encryptionService;
    setUp(() {
      storageService = StorageServiceImpl();
      encryptionService = EncryptionServiceImpl();
      mnemonicService = MnemonicServiceImpl(
          storageService: storageService, encryptionService: encryptionService);
    });
    test('should generate and store mnemonic phrase', () async {
      final password = 'test_password';
      final generatedMnemonic =
          await mnemonicService.generateMnemonic(password);
      final retrievedMnemonic = await mnemonicService.getMnemonic(password);
      expect(retrievedMnemonic, equals(generatedMnemonic));
    });
  });

  group('KeyPairService', () {
    late KeyPairService keyPairService;
    late StorageService storageService;
    late EncryptionService encryptionService;
    late MnemonicService mnemonicService;
    final mnemonic =
        'meadow permit excite unknown easily nuclear fancy bar paper soft segment wheel';
    final privateKey =
        '743537498436afdf9dd45d7699271178271cd83dd5a971d0d8c3192ea223ebc8';
    final publicKey = '0x1D49E2f8D0040095ff4436Cea3A592BBb2AC7C06';
    var expectedGeneratedKeyPairs = {};
    var expectedImportedKeyPairs = {};

    setUp(() {
      storageService = MockStorageService();
      encryptionService = MockEncryptionService();
      mnemonicService = MockMnemonicService();

      // mock the storage service to return the test key pairs
      when(() => storageService.safeRead('generated_key_pairs'))
          .thenAnswer((_) async => jsonEncode(expectedGeneratedKeyPairs));
      when(() => storageService.safeRead('imported_key_pairs'))
          .thenAnswer((_) async => jsonEncode(expectedImportedKeyPairs));
      when(() => storageService.safeStore(any(), any()))
          .thenAnswer((_) async {});

      keyPairService = KeyPairServiceImpl(
        storageService: storageService,
        encryptionService: encryptionService,
        mnemonicService: mnemonicService,
      );
    });

    test('should generate private key from mnemonic', () async {
      final expectedPrivateKey = privateKey;
      final actualPrivateKey =
          await keyPairService.generatePrivateKeyFromMnemonic(mnemonic);
      expect(actualPrivateKey, equals(expectedPrivateKey));
    });

    test('should generate and store key pair from new account', () async {
      // mock the mnemonic service to return the test mnemonic
      when(() => mnemonicService.getMnemonic(any()))
          .thenAnswer((_) async => mnemonic);

      // mock the encryption service to return the test encrypted private key
      final encryptedPrivateKey = 'encrypted_private_key';
      when(() => encryptionService.encryptText(any(), any()))
          .thenAnswer((_) async => encryptedPrivateKey);

      // mock the storage service to return empty map for generated key pairs
      when(() => storageService.safeRead('generated_key_pairs'))
          .thenAnswer((_) async => '{}');

      await keyPairService.createAccount('password');

      verify(() => encryptionService.encryptText(privateKey, any())).called(1);
      verify(() => storageService.safeStore(
              'generated_key_pairs', '{"$publicKey":"$encryptedPrivateKey"}'))
          .called(1);
    });

    test('should store key pair from imported account', () async {
      final password = 'password';
      final isImported = true;

      // mock the encryption service to return the test encrypted private key
      final encryptedPrivateKey = 'encrypted_private_key';
      when(() => encryptionService.encryptText(privateKey, password))
          .thenAnswer((_) async => encryptedPrivateKey);

      await keyPairService.importAccount(privateKey, password);

      // verify that the private key is stored in encrypted format
      verify(() => storageService.safeStore(
              'imported_key_pairs', '{"$publicKey":"$encryptedPrivateKey"}'))
          .called(1);
    });

    test('should set and retrieve current account', () async {
      final expectedCurrentAccount = publicKey;

      // mock the storage service to return the test current account
      when(() => storageService.safeRead('current_account'))
          .thenAnswer((_) async => expectedCurrentAccount);

      await keyPairService.setCurrentAccount(expectedCurrentAccount);
      final actualCurrentAccount = await keyPairService.getCurrentAccount();

      expect(actualCurrentAccount, equals(expectedCurrentAccount));
    });

    test('should retrieve all generated and imported key pairs', () async {
      expectedGeneratedKeyPairs = {
        '0x1234': 'encrypted_private_key1',
      };
      expectedImportedKeyPairs = {
        '0x5678': 'encrypted_private_key2',
      };

      final actualGeneratedKeyPairs =
          await keyPairService.getGeneratedKeyPairs();
      final actualImportedKeyPairs = await keyPairService.getImportedKeyPairs();

      expect(actualGeneratedKeyPairs, equals(expectedGeneratedKeyPairs));
      expect(actualImportedKeyPairs, equals(expectedImportedKeyPairs));
    });

    test('should retrieve all public keys', () async {
      expectedGeneratedKeyPairs = {
        '0x1234': 'encrypted_private_key1',
      };
      expectedImportedKeyPairs = {
        '0x5678': 'encrypted_private_key2',
      };
      final expectedPublicKeys = ['0x1234', '0x5678'];

      final actualPublicKeys = await keyPairService.getPublicKeys();

      expect(actualPublicKeys, equals(expectedPublicKeys));
    });

    test('should retrieve decrypted private key for public key', () async {
      final expectedPrivateKey = privateKey;
      final password = 'password';
      final encryptedPrivateKey = 'encrypted_private_key';

      expectedGeneratedKeyPairs = {
        publicKey: 'encrypted_private_key',
      };
      // mock the encryption service to return the test decrypted private key
      when(() => encryptionService.decryptText(encryptedPrivateKey, password))
          .thenAnswer((_) async => expectedPrivateKey);

      final actualPrivateKey =
          await keyPairService.getPrivateKey(publicKey, password);

      expect(actualPrivateKey, equals(expectedPrivateKey));
    });

    test('should retrieve public key from private key', () {
      final expectedPublicKey = publicKey;
      final actualPublicKey = keyPairService.getPublicKey(privateKey);
      expect(actualPublicKey, equals(expectedPublicKey));
    });

    test('should encrypt and store key pair', () async {
      final password = 'password';
      final isImported = false;
      // mock the encryption service to return the test encrypted private key
      final encryptedPrivateKey = 'encrypted_private_key';
      when(() => encryptionService.encryptText(privateKey, password))
          .thenAnswer((_) async => encryptedPrivateKey);

      // mock the storage service to return empty map for generated key pairs
      when(() => storageService.safeRead('generated_key_pairs'))
          .thenAnswer((_) async => '{}');

      await keyPairService.safeStoreKeyPairs(
          publicKey, privateKey, password, isImported);

      // verify that the private key is stored in encrypted format
      verify(() => storageService.safeStore(
              'generated_key_pairs', '{"$publicKey":"$encryptedPrivateKey"}'))
          .called(1);
    });
  });
}
