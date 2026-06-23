import 'package:eub_connect/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows registration and login fields', (tester) async {
    await tester.pumpWidget(const EubConnectApp());

    expect(find.text('EUB Connect'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Student ID'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Profile Photo'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Student ID'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });
}
