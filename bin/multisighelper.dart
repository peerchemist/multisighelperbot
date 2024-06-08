import 'package:multisig_helper/transaction.dart' as transaction;
import 'package:televerse/televerse.dart';
import "package:coinlib/coinlib.dart";
import 'dart:io';

bool isNumeric(n) {
  return double.tryParse(n) != null && n != null;
}

Map<String, Object> parseMsg(String msg) {
  var resp = {'parsedAddress': "", 'parsedAmount': ""};
  for (var i in msg.split(" ")) {
    if (i.startsWith("p") || i.startsWith('P') || i.startsWith('pc')) {
      // try to parse the address
      try {
        Address addr = Address.fromString(i, Network.mainnet);
        resp['parsedAddress'] = addr.toString();
      } catch (e) {
        print('Invalid address: $e');
        resp['parsedAddress'] = "";
      }
    }
    if (isNumeric(i)) {
      resp['parsedAmount'] = i;
    }
  }
  return resp;
}

void main() async {
  await loadCoinlib();

  // read the TGBOTTOKEN environment variable
  final tgBotToken = Platform.environment["TGBOTTOKEN"]!;

  // Read the REDEEMSCRIPT environment variable
  final redeemScript = Platform.environment["REDEEMSCRIPT"]!;

  // Create a new bot instance
  final bot = Bot(tgBotToken);

  print('Up and running!');

  /// Simple help command
  bot.command("help", (ctx) async {
    await ctx.reply(
        'Send command like /musig PWaWALZqyct3myGDxqwcwPzM3C75SKjPe8 8000 to initiate the bot.');
  });

  bot.command("musig", (ctx) async {
    final String? msgContent = ctx.message?.text;
    if (msgContent != null) {
      final Map parsedMessage = parseMsg(msgContent);
      final String raw = await transaction.buildTransaction(redeemScript,
          parsedMessage['parsedAddress'], parsedMessage['parsedAmount']);
      ctx.reply(raw);
    } else {
      ctx.reply("Come again?! 🤔");
    }
  });

  /// Starts the bot
  bot.start();
}
