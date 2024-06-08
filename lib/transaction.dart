import "dart:core";
import "package:coinlib/coinlib.dart";
import 'package:dio/dio.dart';

final apiurl = 'https://blockbook.peercoin.net/api';

final dio = Dio();

Future<String> buildTransaction(
    String redeemScript, String outputAddress, String amount) async {
  final outputAmount = CoinUnit.coin.toSats(amount);
  final multisig = MultisigProgram.decompile(hexToBytes(redeemScript));

  final outputProgram = P2SH.fromRedeemScript(multisig.script);
  final address = P2SHAddress.fromHash(
    outputProgram.scriptHash,
    version: Network.mainnet.p2shPrefix,
  );

  final apiResult =
      await dio.get("$apiurl/utxo/$address"); // fetching utxos of the explorer

  // rawUtxo example: {txid: eb9592a2e4e5f5ebafc73e731aee9f5858fe2d5951bf4815d49d5eac6f16b0f3, vout: 1, amount: 30.777694, satoshis: 30777694, height: 723366, confirmations: 127}

  final rawUtxos = apiResult.data;

  final candidates = rawUtxos.map<InputCandidate>(
    (utxo) => InputCandidate(
      input: P2SHMultisigInput(
        prevOut: OutPoint.fromHex(utxo["txid"], utxo["vout"]),
        program: multisig,
      ),
      value: BigInt.from(utxo["satoshis"]),
    ),
  );

  final selection = CoinSelection.optimal(
    candidates: candidates,
    recipients: [
      Output.fromAddress(
          outputAmount, Address.fromString(outputAddress, Network.mainnet))
    ],
    changeProgram: outputProgram,
    feePerKb: Network.mainnet.feePerKb,
    minFee: Network.mainnet.minFee,
    minChange: Network.mainnet.minOutput,
  );

  return selection.transaction.toHex();
}
