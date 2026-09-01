import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orqestra_flutter/features/pairing/claim_preview_page.dart';
import 'package:orqestra_flutter/features/pairing/scan_page.dart';

void main() {
  test('pairing QR parser accepts exact Orqestra payload', () {
    final payload = parsePairingQr('orqestra://pair/LAMP-001/token-123');

    expect(payload?.deviceCode, 'LAMP-001');
    expect(payload?.pairingToken, 'token-123');
  });

  test('pairing QR parser rejects malformed payloads', () {
    expect(parsePairingQr('https://pair/LAMP-001/token-123'), isNull);
    expect(parsePairingQr('orqestra://wrong/LAMP-001/token-123'), isNull);
    expect(parsePairingQr('orqestra://pair/LAMP-001'), isNull);
    expect(parsePairingQr('orqestra://pair/LAMP-001/token/extra'), isNull);
  });

  testWidgets('invalid claim route renders scan recovery', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ClaimPreviewPage.invalid()),
    );

    expect(find.text('Invalid pairing link'), findsOneWidget);
    expect(find.text('Scan again'), findsOneWidget);
    expect(find.byIcon(Icons.link_off), findsOneWidget);
  });
}
