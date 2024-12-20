import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hedieaty/database/database_helper.dart';
import 'package:hedieaty/main.dart' as myApp;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Workflow: Login, Add friend',
          (tester) async {
        // Launch the app
        WidgetsFlutterBinding.ensureInitialized() ;
        await Firebase.initializeApp();
        await DatabaseHelper().database;
        await tester.pumpWidget(myApp.MyApp());

        await testLogin(tester);

        await Future.delayed(Duration(seconds: 1));

        await testAddFriend(tester);


      });


}

Future<void> testLogin(WidgetTester tester) async {
  final loginEmailField = find.byKey(const Key('LoginEmailField'));
  final loginPasswordField = find.byKey(const Key('LoginPasswordField'));
  final loginButton = find.byKey(const Key('LoginButton'));

  // Assert all fields are present
  expect(loginEmailField, findsOneWidget);
  expect(loginPasswordField, findsOneWidget);
  expect(loginButton, findsOneWidget);

  // Enter login credentials
  await tester.enterText(loginEmailField, 'test@email.com');
  await tester.enterText(loginPasswordField, '123456');

  // Close the keyboard
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();

  // Tap the login button
  await tester.tap(loginButton);
  await tester.pumpAndSettle();

  // Debug print to check widget tree
  debugPrint(tester.element(find.byType(Scaffold)).toString());
}

Future<void> testAddFriend(WidgetTester tester) async {
  // Wait for the home page to load
  await tester.pumpAndSettle();

  final homeAppbar = find.byKey(const Key('HomeAppbar'));
  final allFriendsPageButton = find.byKey(const Key('AllFriendsPageButton'));

  // Assert home app bar is present
  expect(homeAppbar, findsOneWidget);

  // Tap the "All Friends" page button
  await tester.tap(allFriendsPageButton);
  await tester.pumpAndSettle();

  final addFriendButton = find.byKey(const Key('AddFriendButton'));
  expect(addFriendButton, findsOneWidget);
  await tester.tap(addFriendButton);

  await tester.pumpAndSettle();

  final phoneNumber = find.byKey(const Key('PhoneNumberField'));
  final confirmAddButton = find.byKey(const Key('ConfirmAddButton'));

  await tester.enterText(phoneNumber, "01234567890");

  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();

  await tester.tap(confirmAddButton);
  await tester.pumpAndSettle();

  debugPrint(tester.allWidgets.toString());

  await tester.pumpAndSettle(Duration(seconds: 1));
  final friendExist = find.text("Kero Noshy");
  expect(friendExist, findsOneWidget);

  await tester.pumpAndSettle();
}
