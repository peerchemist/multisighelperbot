import 'package:test/test.dart';
import 'package:multisig_helper/parsing.dart';

void main() {
  group('parseMsg', () {
    test('parses address and amount correctly', () {
      String msg = "PSo7xbSRPvpS2DqqEjQa95apr3KWgLyGDc 1000";
      var result = parseMsg(msg);
      expect(result['parsedAddress'], "PSo7xbSRPvpS2DqqEjQa95apr3KWgLyGDc");
      expect(result['parsedAmount'], "1000");
    });

    test('parses only amount when address is missing', () {
      String msg = "2000";
      var result = parseMsg(msg);
      expect(result['parsedAddress'], "");
      expect(result['parsedAmount'], "2000");
    });

    test('handles mixed case address prefix', () {
      String msg = "P98765 1500";
      var result = parseMsg(msg);
      expect(result['parsedAddress'], "");
      expect(result['parsedAmount'], "1500");
    });
  });
}
