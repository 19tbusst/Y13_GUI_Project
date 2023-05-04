import 'package:flutter/material.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Item Name'),
                const Spacer(),
                Row(
                  children: const [
                    Card(
                      child: Text('Item Price'),
                    ),
                    Text('dd/mm/yy'),
                  ],
                ),
              ],
            ),
            const Placeholder(),
          ],
        ),
      ),
    );
  }
}
