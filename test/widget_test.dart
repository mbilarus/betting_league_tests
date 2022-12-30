import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_flutter/colors.dart';
import 'package:test_task_flutter/random_number_generator.dart';
import 'package:test_task_flutter/yellow_screen.dart';

class MockRandomNumberGenerator implements RandomNumberGenerator {
  int number;
  MockRandomNumberGenerator(this.number);
  @override
  int generate() => number;
}

void main() {
  testWidgets(
      'Проверяем, что при тапе по кнопке число от 0 до 49 отображается синим цветом',
      (WidgetTester tester) async {
    Widget yellowScreenWidget = MaterialApp(
      home: Scaffold(
        body: YellowScreen(generator: MockRandomNumberGenerator(1)),
      ),
    );
    await tester.pumpWidget(yellowScreenWidget);
    // Должна отображаться кнопка “случайное число”, фон экрана желтый, а также должна отображаться кнопка “назад”
    expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is ElevatedButton &&
              (widget.child as Text).data == 'Случайное число',
          description: 'Кнопка, для создания случайного числа',
        ),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is Container && widget.color == yellowColor,
            description: 'Желтый контейнер занимающий большую часть экрана'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) =>
                widget is AppBar && widget.backgroundColor == yellowColor,
            description: 'Желтая панель приложения'),
        findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // Тапнуть по кнопке “случайное число” и проверить, что число от 0 до 49 отображается синим цветом
    for (var i = 0; i < 50; i++) {
      Widget yellowScreenWidget = MaterialApp(
        home: Scaffold(
          body: YellowScreen(generator: MockRandomNumberGenerator(i)),
        ),
      );
      await tester.pumpWidget(yellowScreenWidget);
      await tester.tap(find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            (widget.child as Text).data == 'Случайное число',
        description: 'Кнопка, для создания случайного числа',
      ));

      await tester.pump();
      expect(
          find.byWidgetPredicate(
              (widget) => widget is Text && widget.style?.color == blueColor),
          findsOneWidget);
    }
  });
}
