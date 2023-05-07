import 'dart:io';

import 'package:flutter/material.dart';

class Item {
  String name;
  bool isIssued;
  DateTime date;
  String image;

  Item({
    required this.name,
    required this.isIssued,
    required this.date,
    required this.image,
  });
}

class ItemCard extends StatefulWidget {
  const ItemCard({super.key});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  Item item1 = Item(
    name: 'Item 1',
    isIssued: true,
    date: DateTime.now(),
    image:
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
  );

  String _name = '';
  bool _isIssued = false;
  DateTime _date = DateTime.now();
  String _image = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      _name = item1.name;
      _isIssued = item1.isIssued;
      _date = item1.date;
      _image = item1.image;
    });

    return Card(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 200, maxHeight: 200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(_name),
                  const Spacer(),
                  Row(
                    children: [
                      const Card(
                        child: Text('Item Price'),
                      ),
                      Text('${_date.day}/${_date.month}/${_date.year}'),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Image(
                  image: NetworkImage(_image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
