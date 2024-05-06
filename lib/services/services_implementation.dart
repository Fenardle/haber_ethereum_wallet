import './mnemonic_service.dart';
import './storage_service.dart';
import './encryption_service.dart';
import './key_pairs_service.dart';

final storageService = StorageServiceImpl();
final encryptionService = EncryptionServiceImpl();
final mnemonicService = MnemonicServiceImpl(
    storageService: storageService, encryptionService: encryptionService);
final keyPairsService = KeyPairServiceImpl(
    storageService: storageService,
    encryptionService: encryptionService,
    mnemonicService: mnemonicService);
