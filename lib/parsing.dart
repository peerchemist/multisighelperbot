import "package:coinlib/coinlib.dart";

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
      resp['parsedAmount'] = i;
    }
  }
  return resp;
}
