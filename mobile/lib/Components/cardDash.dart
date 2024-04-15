import 'package:flutter/material.dart';

class CounterCard extends StatelessWidget {
  final IconData icon;
  final int count;
  final String text;

  const CounterCard({
    required this.icon,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 30.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  "$count",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
