// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;
import 'dart:typed_data' as _i2;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"delegator","type":"address"},{"indexed":true,"internalType":"address","name":"fromDelegate","type":"address"},{"indexed":true,"internalType":"address","name":"toDelegate","type":"address"}],"name":"DelegateChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"delegate","type":"address"},{"indexed":false,"internalType":"uint256","name":"previousBalance","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"newBalance","type":"uint256"}],"name":"DelegateVotesChanged","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint8","name":"version","type":"uint8"}],"name":"Initialized","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"MintCompleted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"MintInitiated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"MintProposalCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"uint256","name":"mintProposalId","type":"uint256"},{"indexed":true,"internalType":"address","name":"voter","type":"address"},{"indexed":true,"internalType":"uint256","name":"voteNumber","type":"uint256"}],"name":"MintProposalVoted","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[],"name":"DOMAIN_SEPARATOR","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"uint32","name":"pos","type":"uint32"}],"name":"checkpoints","outputs":[{"components":[{"internalType":"uint32","name":"fromBlock","type":"uint32"},{"internalType":"uint224","name":"votes","type":"uint224"}],"internalType":"struct ERC20VotesUpgradeable.Checkpoint","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"receiveAddress","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"createMintProposal","outputs":[{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"delegatee","type":"address"}],"name":"delegate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"delegatee","type":"address"},{"internalType":"uint256","name":"nonce","type":"uint256"},{"internalType":"uint256","name":"expiry","type":"uint256"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"delegateBySig","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"delegates","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getAllProposals","outputs":[{"components":[{"internalType":"address","name":"receiveAddress","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"internalType":"struct ERC20Implementation.MintProposal[]","name":"proposals","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"mingProposalId","type":"uint256"}],"name":"getMintProposal","outputs":[{"internalType":"address","name":"receiveAddress","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"getMintReleaseTime","outputs":[{"internalType":"uint256","name":"releaseTime","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"name":"getPastTotalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"},{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"name":"getPastVotes","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"getProposalBlockNumber","outputs":[{"internalType":"uint256","name":"blockNumber","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"getProposalVotesNumber","outputs":[{"internalType":"uint256","name":"votesNumber","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"getVotes","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"voter","type":"address"},{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"hasVoted","outputs":[{"internalType":"bool","name":"voted","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"string","name":"name","type":"string"},{"internalType":"string","name":"symbol","type":"string"},{"internalType":"address","name":"creator","type":"address"}],"name":"initialize","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"initiateMint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"mint","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"nonces","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"numCheckpoints","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"value","type":"uint256"},{"internalType":"uint256","name":"deadline","type":"uint256"},{"internalType":"uint8","name":"v","type":"uint8"},{"internalType":"bytes32","name":"r","type":"bytes32"},{"internalType":"bytes32","name":"s","type":"bytes32"}],"name":"permit","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"mintProposalId","type":"uint256"}],"name":"voteMintProposal","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'ERC20Implementation',
);

class ERC20Implementation extends _i1.GeneratedContract {
  ERC20Implementation({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i2.Uint8List> DOMAIN_SEPARATOR({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '3644e515'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i2.Uint8List);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> allowance(
    _i1.EthereumAddress owner,
    _i1.EthereumAddress spender, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'dd62ed3e'));
    final params = [
      owner,
      spender,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> approve(
    _i1.EthereumAddress spender,
    BigInt amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '095ea7b3'));
    final params = [
      spender,
      amount,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> balanceOf(
    _i1.EthereumAddress account, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '70a08231'));
    final params = [account];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> checkpoints(
    _i1.EthereumAddress account,
    BigInt pos, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'f1127ed8'));
    final params = [
      account,
      pos,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> createMintProposal(
    _i1.EthereumAddress receiveAddress,
    BigInt amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'b3fa024f'));
    final params = [
      receiveAddress,
      amount,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> decimals({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '313ce567'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> decreaseAllowance(
    _i1.EthereumAddress spender,
    BigInt subtractedValue, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, 'a457c2d7'));
    final params = [
      spender,
      subtractedValue,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> delegate(
    _i1.EthereumAddress delegatee, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '5c19a95c'));
    final params = [delegatee];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> delegateBySig(
    _i1.EthereumAddress delegatee,
    BigInt nonce,
    BigInt expiry,
    BigInt v,
    _i2.Uint8List r,
    _i2.Uint8List s, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, 'c3cda520'));
    final params = [
      delegatee,
      nonce,
      expiry,
      v,
      r,
      s,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<_i1.EthereumAddress> delegates(
    _i1.EthereumAddress account, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '587cde1e'));
    final params = [account];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getAllProposals({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, 'cceb68f5'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<GetMintProposal> getMintProposal(
    BigInt mingProposalId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '2baa6321'));
    final params = [mingProposalId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return GetMintProposal(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getMintReleaseTime(
    BigInt mintProposalId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, '584bf6d8'));
    final params = [mintProposalId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getPastTotalSupply(
    BigInt blockNumber, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, '8e539e8c'));
    final params = [blockNumber];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getPastVotes(
    _i1.EthereumAddress account,
    BigInt blockNumber, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[16];
    assert(checkSignature(function, '3a46b1a8'));
    final params = [
      account,
      blockNumber,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getProposalBlockNumber(
    BigInt mintProposalId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, 'f6678d54'));
    final params = [mintProposalId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getProposalVotesNumber(
    BigInt mintProposalId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, '1d3a026a'));
    final params = [mintProposalId];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getVotes(
    _i1.EthereumAddress account, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, '9ab24eb0'));
    final params = [account];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<bool> hasVoted(
    _i1.EthereumAddress voter,
    BigInt mintProposalId, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, '42545825'));
    final params = [
      voter,
      mintProposalId,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> increaseAllowance(
    _i1.EthereumAddress spender,
    BigInt addedValue, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, '39509351'));
    final params = [
      spender,
      addedValue,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> initialize(
    String name,
    String symbol,
    _i1.EthereumAddress creator, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[22];
    assert(checkSignature(function, '077f224a'));
    final params = [
      name,
      symbol,
      creator,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> initiateMint(
    BigInt mintProposalId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[23];
    assert(checkSignature(function, '69512af7'));
    final params = [mintProposalId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> mint(
    BigInt mintProposalId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[24];
    assert(checkSignature(function, 'a0712d68'));
    final params = [mintProposalId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<String> name({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[25];
    assert(checkSignature(function, '06fdde03'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as String);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> nonces(
    _i1.EthereumAddress owner, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[26];
    assert(checkSignature(function, '7ecebe00'));
    final params = [owner];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> numCheckpoints(
    _i1.EthereumAddress account, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[27];
    assert(checkSignature(function, '6fcfff45'));
    final params = [account];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> permit(
    _i1.EthereumAddress owner,
    _i1.EthereumAddress spender,
    BigInt value,
    BigInt deadline,
    BigInt v,
    _i2.Uint8List r,
    _i2.Uint8List s, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[28];
    assert(checkSignature(function, 'd505accf'));
    final params = [
      owner,
      spender,
      value,
      deadline,
      v,
      r,
      s,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<String> symbol({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[29];
    assert(checkSignature(function, '95d89b41'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as String);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalSupply({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[30];
    assert(checkSignature(function, '18160ddd'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transfer(
    _i1.EthereumAddress to,
    BigInt amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[31];
    assert(checkSignature(function, 'a9059cbb'));
    final params = [
      to,
      amount,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transferFrom(
    _i1.EthereumAddress from,
    _i1.EthereumAddress to,
    BigInt amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[32];
    assert(checkSignature(function, '23b872dd'));
    final params = [
      from,
      to,
      amount,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> voteMintProposal(
    BigInt mintProposalId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[33];
    assert(checkSignature(function, '24c92b18'));
    final params = [mintProposalId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all Approval events emitted by this contract.
  Stream<Approval> approvalEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Approval');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Approval(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all DelegateChanged events emitted by this contract.
  Stream<DelegateChanged> delegateChangedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('DelegateChanged');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return DelegateChanged(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all DelegateVotesChanged events emitted by this contract.
  Stream<DelegateVotesChanged> delegateVotesChangedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('DelegateVotesChanged');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return DelegateVotesChanged(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Initialized events emitted by this contract.
  Stream<Initialized> initializedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Initialized');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Initialized(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all MintCompleted events emitted by this contract.
  Stream<MintCompleted> mintCompletedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('MintCompleted');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return MintCompleted(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all MintInitiated events emitted by this contract.
  Stream<MintInitiated> mintInitiatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('MintInitiated');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return MintInitiated(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all MintProposalCreated events emitted by this contract.
  Stream<MintProposalCreated> mintProposalCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('MintProposalCreated');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return MintProposalCreated(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all MintProposalVoted events emitted by this contract.
  Stream<MintProposalVoted> mintProposalVotedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('MintProposalVoted');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return MintProposalVoted(
        decoded,
        result,
      );
    });
  }

  /// Returns a live stream of all Transfer events emitted by this contract.
  Stream<Transfer> transferEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('Transfer');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return Transfer(
        decoded,
        result,
      );
    });
  }
}

class GetMintProposal {
  GetMintProposal(List<dynamic> response)
      : receiveAddress = (response[0] as _i1.EthereumAddress),
        amount = (response[1] as BigInt),
        blockNumber = (response[2] as BigInt);

  final _i1.EthereumAddress receiveAddress;

  final BigInt amount;

  final BigInt blockNumber;
}

class Approval {
  Approval(
    List<dynamic> response,
    this.event,
  )   : owner = (response[0] as _i1.EthereumAddress),
        spender = (response[1] as _i1.EthereumAddress),
        value = (response[2] as BigInt);

  final _i1.EthereumAddress owner;

  final _i1.EthereumAddress spender;

  final BigInt value;

  final _i1.FilterEvent event;
}

class DelegateChanged {
  DelegateChanged(
    List<dynamic> response,
    this.event,
  )   : delegator = (response[0] as _i1.EthereumAddress),
        fromDelegate = (response[1] as _i1.EthereumAddress),
        toDelegate = (response[2] as _i1.EthereumAddress);

  final _i1.EthereumAddress delegator;

  final _i1.EthereumAddress fromDelegate;

  final _i1.EthereumAddress toDelegate;

  final _i1.FilterEvent event;
}

class DelegateVotesChanged {
  DelegateVotesChanged(
    List<dynamic> response,
    this.event,
  )   : delegate = (response[0] as _i1.EthereumAddress),
        previousBalance = (response[1] as BigInt),
        newBalance = (response[2] as BigInt);

  final _i1.EthereumAddress delegate;

  final BigInt previousBalance;

  final BigInt newBalance;

  final _i1.FilterEvent event;
}

class Initialized {
  Initialized(
    List<dynamic> response,
    this.event,
  ) : version = (response[0] as BigInt);

  final BigInt version;

  final _i1.FilterEvent event;
}

class MintCompleted {
  MintCompleted(
    List<dynamic> response,
    this.event,
  ) : mintProposalId = (response[0] as BigInt);

  final BigInt mintProposalId;

  final _i1.FilterEvent event;
}

class MintInitiated {
  MintInitiated(
    List<dynamic> response,
    this.event,
  ) : mintProposalId = (response[0] as BigInt);

  final BigInt mintProposalId;

  final _i1.FilterEvent event;
}

class MintProposalCreated {
  MintProposalCreated(
    List<dynamic> response,
    this.event,
  ) : mintProposalId = (response[0] as BigInt);

  final BigInt mintProposalId;

  final _i1.FilterEvent event;
}

class MintProposalVoted {
  MintProposalVoted(
    List<dynamic> response,
    this.event,
  )   : mintProposalId = (response[0] as BigInt),
        voter = (response[1] as _i1.EthereumAddress),
        voteNumber = (response[2] as BigInt);

  final BigInt mintProposalId;

  final _i1.EthereumAddress voter;

  final BigInt voteNumber;

  final _i1.FilterEvent event;
}

class Transfer {
  Transfer(
    List<dynamic> response,
    this.event,
  )   : from = (response[0] as _i1.EthereumAddress),
        to = (response[1] as _i1.EthereumAddress),
        value = (response[2] as BigInt);

  final _i1.EthereumAddress from;

  final _i1.EthereumAddress to;

  final BigInt value;

  final _i1.FilterEvent event;
}
