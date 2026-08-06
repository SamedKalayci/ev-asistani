import 'package:flutter_test/flutter_test.dart';
import 'package:ev_asistani/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EvAsistaniApp());
  });
}
