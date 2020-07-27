import 'package:flutter/material.dart';
import 'input_page.dart';

void main() => runApp(SummonersSpellTimer());

class SummonersSpellTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF264653),
        scaffoldBackgroundColor: Color(0xFF2A9D8F),
      ),
      home: InputPage(),
    );
  }
}
