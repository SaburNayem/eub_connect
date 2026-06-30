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

  testWidgets('opens the static university workspace', (tester) async {
    await tester.pumpWidget(const EubConnectApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    expect(find.text('Student workspace'), findsOneWidget);
    expect(find.text('Attendance'), findsWidgets);
    expect(find.text('Role Modules'), findsOneWidget);

    await tester.tap(find.text('Teacher'));
    await tester.pumpAndSettle();

    expect(find.text('Teacher workspace'), findsOneWidget);
    expect(find.text('Teacher Portal'), findsWidgets);
  });
}
