import 'package:multisig_helper/transaction.dart' as transaction;
import 'package:multisig_helper/parsing.dart';
import 'package:televerse/televerse.dart';
import "package:coinlib/coinlib.dart";
import 'dart:io';
import 'dart:developer';

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

  bot.onError((err) {
    log(
      "Something went wrong: $err",
      error: err.error,
      stackTrace: err.stackTrace,
    );
  });
}
