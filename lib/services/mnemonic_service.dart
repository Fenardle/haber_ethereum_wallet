import './storage_service.dart';
import './encryption_service.dart';
import 'package:bip39/bip39.dart' as bip39;

abstract class MnemonicService {
  Future<String> generateMnemonic(String password);
  Future<void> safeStoreMnemonic(String mnemonic, String password);
  Future<String?> getMnemonic(String password);
}

class MnemonicServiceImpl implements MnemonicService {
  final StorageService _storageService;
  final EncryptionService _encryptionService;

  MnemonicServiceImpl(
      {required StorageService storageService,
      required EncryptionService encryptionService})
      : _storageService = storageService,
        _encryptionService = encryptionService;

  @override
  Future<String> generateMnemonic(String password) async {
    final mnemonic = bip39.generateMnemonic();
    await safeStoreMnemonic(mnemonic, password);
    return mnemonic;
  }

  @override
  Future<void> safeStoreMnemonic(String mnemonic, String password) async {
    final encryptedMnemonic =
        await _encryptionService.encryptText(mnemonic, password);
    await _storageService.safeStore('encrypted_mnemonic', encryptedMnemonic);
  }

  @override
  Future<String?> getMnemonic(String password) async {
    final encryptedMnemonic =
        await _storageService.safeRead('encrypted_mnemonic');
    if (encryptedMnemonic == null) return null;
    final mnemonic =
        await _encryptionService.decryptText(encryptedMnemonic, password);
    return mnemonic;
  }
}

final mnemonicService = MnemonicServiceImpl(
    storageService: storageService, encryptionService: encryptionService);
