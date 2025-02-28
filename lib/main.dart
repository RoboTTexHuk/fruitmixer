import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:ftuitmixer/nextScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FallingFruitsScreen(),
    );
  }
}

class FallingFruitsScreen extends StatefulWidget {
  @override
  _FallingFruitsScreenState createState() => _FallingFruitsScreenState();
}

class _FallingFruitsScreenState extends State<FallingFruitsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;

  final List<Fruit> fruits = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // Создаем 10 фруктов с начальной позицией вне экрана
    for (int i = 0; i < 10; i++) {
      fruits.add(Fruit(
        icon: _randomFruitIcon(),
        left: random.nextDouble() * 300, // Случайное положение по горизонтали
        top: -random.nextDouble() * 300, // Случайное положение за пределами экрана
      ));
    }

    // Запускаем таймер, чтобы через 3 секунды перейти на следующий экран
    _timer = Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const NextScreen()),
      );
    });

    // Запускаем анимацию
    _startAnimation();
  }

  void _startAnimation() {
    Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        for (var fruit in fruits) {
          // Увеличиваем позицию по вертикали, чтобы фрукты "падали"
          fruit.top += 5;

          // Если фрукт вышел за пределы экрана, возвращаем его наверх
          if (fruit.top > MediaQuery.of(context).size.height) {
            fruit.top = -50;
            fruit.left = random.nextDouble() *
                MediaQuery.of(context).size.width; // Случайное новое положение
          }
        }
      });
    });
  }

  IconData _randomFruitIcon() {
    final fruitIcons = [
      Icons.apple, // Икона яблока
      Icons.cake, // Икона торта
      Icons.icecream, // Икона мороженого
      Icons.local_pizza, // Икона пиццы
      Icons.fastfood, // Икона фастфуда
    ];
    return fruitIcons[random.nextInt(fruitIcons.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Синий фон
      body: Stack(
        children: fruits.map((fruit) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            left: fruit.left,
            top: fruit.top,
            child: Icon(
              fruit.icon,
              size: 40,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class Fruit {
  IconData icon;
  double left;
  double top;

  Fruit({required this.icon, required this.left, required this.top});
}

class NextScreen extends StatelessWidget {
  const NextScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebViewWithLoader();
  }
}