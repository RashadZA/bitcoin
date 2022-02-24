import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin/coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);


  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'NULL';

  DropdownButton<String> androidButton(){

    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem<String>(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value){
        setState(() {
          selectedCurrency = value! ;
          getData();
        },);
      },);
  }


  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    // getData();
  }

   Column makeCards() {
   List<CryptoCard> cryptoCards = [];
   for (String crypto in cryptoList) {
     cryptoCards.add(
       CryptoCard(
         cryptoCurrency: crypto,
         selectedCurrency: selectedCurrency,
         value: isWaiting ? '?' : coinValues[crypto],
       ),
     );
   }
   return Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: cryptoCards,
   );
 }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('🤑 Coin Ticker',
          style: TextStyle(
            color: Colors.green,
          ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS?  iOSPicker() : androidButton() ,
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {

  CryptoCard({ this.selectedCurrency, this.value, this.cryptoCurrency});
  final String? value;
  final String? selectedCurrency;
  final String? cryptoCurrency;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}



// Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: <Widget>[
// CryptoCard(
// cryptoCurrency: 'BTC',
// //7. Finally, we use a ternary operator to check if we are waiting and if so, we'll display a '?' otherwise we'll show the actual price data.
// value: isWaiting ? '?' : coinValues['BTC'],
// selectedCurrency: selectedCurrency,
// ),
// CryptoCard(
// cryptoCurrency: 'ETH',
// value: isWaiting ? '?' : coinValues['ETH'],
// selectedCurrency: selectedCurrency,
// ),
// CryptoCard(
// cryptoCurrency: 'LTC',
// value: isWaiting ? '?' : coinValues['LTC'],
// selectedCurrency: selectedCurrency,
// ),
// ],
// ),