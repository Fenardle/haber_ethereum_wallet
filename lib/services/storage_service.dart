import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StorageService {
  Future<String?> safeRead(String key);
  Future<void> safeStore(String key, String value);
}

class StorageServiceImpl implements StorageService {
  final storage = const FlutterSecureStorage();

  @override
  Future<String?> safeRead(String key) async {
    String? value = await storage.read(key: key);
    return value;
  }

  @override
  Future<void> safeStore(String key, String value) async {
    await storage.write(key: key, value: value);
  }
}

final storageService = StorageServiceImpl();
