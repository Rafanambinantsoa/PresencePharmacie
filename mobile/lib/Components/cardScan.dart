import 'package:flutter/material.dart';

class VersScan extends StatelessWidget {
  final IconData icon;
  final String text;

  const VersScan({
    super.key,
    required this.icon,
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
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 30.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
