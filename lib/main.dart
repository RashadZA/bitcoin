import 'package:flutter/material.dart';
import 'package:bitcoin/price_screen.dart';

void main() {
  runApp(const BitcoinTicker());
}

class BitcoinTicker extends StatelessWidget {
  const BitcoinTicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
       primaryColor:  Colors.lightBlue, scaffoldBackgroundColor: Colors.white,
      ),
      home: PriceScreen(),
    );
  }
}


