import "package:coinlib/coinlib.dart";

bool isNumeric(n) {
  return double.tryParse(n) != null && n != null;
}

List<String> filterMessage(List<String> message) {
  return message.where((item) => item.trim().isNotEmpty).toList();
}

Map<String, Object> parseMsg(String msg) {
  var message = msg.split(RegExp(r'\s+')).skip(1).toList();
  var filteredMessage = filterMessage(message);

  var resp = {'parsedAddress': "", 'parsedAmount': ""};

  for (var i in filteredMessage) {
    if (i.startsWith("p") || i.startsWith('P') || i.startsWith('pc')) {
      // try to parse the address
      try {
        Address addr = Address.fromString(i, Network.mainnet);
        resp['parsedAddress'] = addr.toString();
      } on InvalidAddress catch (e) {
        print('Invalid address: $e');
        resp['parsedAddress'] = "";
      } on InvalidBase58Checksum catch (e) {
        print('Invalid address: $e');
        resp['parsedAddress'] = "";
      } catch (e) {
        print('Unexpected error: $e');
        resp['parsedAddress'] = "";
      }
    }
    if (isNumeric(i)) {
      try {
        resp['parsedAmount'] = i;
      } on BadAmountString catch (e) {
        print('Bad amount string: $e');
        resp['parsedAmount'] = "";
      } catch (e) {
        print('Unexpected error: $e');
        resp['parsedAmount'] = "";
      }
    }
  }

  print(resp);

  return resp;
}
