import 'package:flutter/material.dart';
import 'package:learn_map_g9/pages/custom_flutter_map.dart';
import 'package:learn_map_g9/pages/custom_yandex_map.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CustomYandexMap(),
    );
  }
}
