abstract class ContractService {
  Future<String> getERC20TokenBalance(
      String contractAddress, String userAddress);
  Future<List> getTokenBalances(String address);
  Future<Map<String, dynamic>> getTokenMetadata(String contractAddress);
}
