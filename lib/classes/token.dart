abstract class Token {
  final String tokenName;
  final String tokenSymbol;
  final String tokenLogoURL;

  Token({
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenLogoURL,
  });
}

class FungibleToken extends Token {
  final String contractAddress;
  double tokenBalance;
  final int tokenDecimals;

  FungibleToken({
    required this.contractAddress,
    required this.tokenBalance,
    required this.tokenDecimals,
    required String tokenName,
    required String tokenSymbol,
    required String tokenLogoURL,
  }) : super(
          tokenName: tokenName,
          tokenSymbol: tokenSymbol,
          tokenLogoURL: tokenLogoURL,
        );

  // Convert FungibleToken instance to a JSON object
  Map<String, dynamic> toJson() => {
        'contractAddress': contractAddress,
        'tokenBalance': tokenBalance,
        'tokenDecimals': tokenDecimals,
        'tokenName': tokenName,
        'tokenSymbol': tokenSymbol,
        'tokenLogoURL': tokenLogoURL,
      };

  // Create a FungibleToken instance from a JSON object
  factory FungibleToken.fromJson(Map<String, dynamic> json) {
    return FungibleToken(
      contractAddress: json['contractAddress'],
      tokenBalance: json['tokenBalance'],
      tokenDecimals: json['tokenDecimals'],
      tokenName: json['tokenName'],
      tokenSymbol: json['tokenSymbol'],
      tokenLogoURL: json['tokenLogoURL'],
    );
  }
}
