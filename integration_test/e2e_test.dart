import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/colors.dart';
import 'package:test_task_flutter/home_screen.dart';
import 'package:test_task_flutter/keys.dart';

import 'package:test_task_flutter/main.dart';

void main() {
  testWidgets(
    'E2E test',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      // Пользователь находится на стартовом экране и видит две кнопки “зеленый”, “желтый”
      final greenButtonFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ElevatedButton &&
              (widget.child as Text).data == 'зеленый',
          description:
              'Кнопка с надписью "зеленый", для перехода на зеленый экран');

      final yellowButtonFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ElevatedButton &&
              (widget.child as Text).data == 'желтый',
          description:
              'Кнопка с текстом "желтый", для перехода на желтый экран');

      expect(greenButtonFinder, findsOneWidget);
      expect(yellowButtonFinder, findsOneWidget);

      // Тап на “зеленый” - должен открыться экран с белой надписью “зеленый экран” и зеленым фоном
      await tester.tap(greenButtonFinder);
      await tester.pumpAndSettle();

      final greenScreenWithTextFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.color == greenColor &&
              (widget.child as Text).style?.color == Colors.white &&
              (widget.child as Text).data == 'Зеленый экран',
          description:
              'Зеленый экран, с белой надписью "Зеленый экран", по центру');

      expect(greenScreenWithTextFinder, findsOneWidget);

      // Тап кнопку назад - должны попасть на стартовый экран
      final popButtonFinder = find.byIcon(Icons.arrow_back);

      await tester.tap(popButtonFinder);
      await tester.pumpAndSettle();

      final homeScreenFinder = find.byType(HomeScreen);
      expect(homeScreenFinder, findsOneWidget);

      // Тап на “желтый” - должен открыться экран с кнопкой “случайное число”, текст в центре экрана не отображается
      await tester.tap(yellowButtonFinder);
      await tester.pumpAndSettle();

      final randomNumberButtonFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ElevatedButton &&
              (widget.child as Text).data == 'Случайное число',
          description: 'Кнопка, генерирующая случайное число');

      const randomNumberContainerKey = Key(Keys.randomNumberContainerKey);
      final randomNumberContainerFinder = find.byKey(randomNumberContainerKey);
      expect(randomNumberContainerFinder, findsOneWidget);

      final yellowScreenSizedBox = (randomNumberContainerFinder.first
              .evaluate()
              .single
              .widget as Container)
          .child;
      expect(yellowScreenSizedBox, isNot(Text));

      // Тап на кнопку “случайное число” - отображается надпись с числом от 0 до 99 в центре экрана
      await tester.tap(randomNumberButtonFinder);
      await tester.pump();

      final yellowScreenRandomText = (randomNumberContainerFinder.first
              .evaluate()
              .single
              .widget as Container)
          .child;
      expect(yellowScreenRandomText, isA<Text>());

      expect(int.parse((yellowScreenRandomText as Text).data ?? '-1'),
          inInclusiveRange(0, 99));

      // Тапнуть кнопку назад - должны попасть на стартовый экран
      await tester.tap(popButtonFinder);
      await tester.pumpAndSettle();

      expect(homeScreenFinder, findsOneWidget);
    },
  );
}
