class DeployedContracts {
  static const Goerli = {
    'ERC20Implementation': '0x1dEa3064C4CCb88d212d002Ab00bBA1d74A02baF',
    'ERC20ProxyFactory': '0x26C2acfB1D9C24b807a74064c86482C6C5afEf55',
  };

  static const Mumbai = {
    'ERC20Implementation': '0xd4A0AC16fb6D68812ABdf4265f4A784a58bA25ae',
    'ERC20ProxyFactory': '0x684D3Fa453c8Abdd011aafB124e3A5c2919DF10b',
  };
}

String getERC20ProxyFactory(String networkName) {
  switch (networkName.toLowerCase()) {
    case 'goerli':
      return DeployedContracts.Goerli['ERC20ProxyFactory']!;
    case 'mumbai':
      return DeployedContracts.Mumbai['ERC20ProxyFactory']!;
    default:
      throw Exception('Unsupported network: $networkName');
  }
}
