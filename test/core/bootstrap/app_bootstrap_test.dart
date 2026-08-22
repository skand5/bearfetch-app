import 'package:bearfetch_app/core/bootstrap/app_bootstrap.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bootstrapped app resolves repository overrides before routing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: BearfetchBootstrapApp()),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(
      find.text('Bad state: Auth repository has not been bootstrapped.'),
      findsNothing,
    );
  });
}
