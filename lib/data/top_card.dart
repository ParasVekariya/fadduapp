import 'package:flutter/material.dart';

class TopNeuCard extends StatefulWidget {
  const TopNeuCard({super.key, required this.balance});
  final String balance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        color: Colors.grey[200],
        child: Center(
          child: Column(
            children: [
              Text(
                'B A L A N C E',
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
              Text(
                // '\u{20B9}${10000}',
                balance,
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
  // @override
  // State<TopNeuCard> createState() => _TopNeuCardState();
}

// class _TopNeuCardState extends State<TopNeuCard> {
//   // static const IconData currency_rupee_outlined =
//   //     IconData(0xf05db, fontFamily: 'MaterialIcons');
  
// }
