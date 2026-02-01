import 'package:test/test.dart';
import 'package:multisig_helper/parsing.dart';

void main() {
  group('parseMsg', () {
    test('parses address and amount correctly', () {
      String msg = "/tip PSo7xbSRPvpS2DqqEjQa95apr3KWgLyGDc 1000";
      var result = parseMsg(msg);
      expect(result['parsedAddress'], "PSo7xbSRPvpS2DqqEjQa95apr3KWgLyGDc");
      expect(result['parsedAmount'], "1000");
    });

    test('parses only amount when address is missing', () {
      String msg = "/tip 2000";
      var result = parseMsg(msg);
      expect(result['parsedAddress'], "");
      expect(result['parsedAmount'], "2000");
    });

    test('handles mixed case address prefix', () {
      String msg = "/tip P98765 1500";
      var result = parseMsg(msg);
      expect(result['parsedAddress'], "");
      expect(result['parsedAmount'], "1500");
    });

    test('parses WPPCBurned event correctly', () {
      String msg = """Event: WPPCBurned
externalAddress: PDgLnwXHwpLNREt3bpzWAVRKsdDiJNSTLA
from: 0x2c2ad26fd8f53ea716089325748cc1d4f9912f25
to: 0x0000000000000000000000000000000000000000
tokens: 1047""";
      var result = parseMsg(msg);
      expect(result['parsedAddress'], "PDgLnwXHwpLNREt3bpzWAVRKsdDiJNSTLA");
      expect(result['parsedAmount'], "1047");
    });
  });
}
