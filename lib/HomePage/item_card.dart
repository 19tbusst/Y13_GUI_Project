import 'package:flutter/material.dart';
import 'home_page.dart';

class ItemCard extends StatefulWidget {
  ItemCard({super.key, required this.item});

  final Item item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  String _name = '';
  bool _isIssued = false;
  DateTime _date = DateTime.now();
  String _image = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      _name = widget.item.name;
      _isIssued = widget.item.isIssued;
      _date = widget.item.date;
      _image = widget.item.image;
    });

    return Card(
      elevation: 2.5,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 200, maxHeight: 200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 224,
                  maxHeight: 200),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          _name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Card(
                          color: Theme.of(context).colorScheme.background,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _isIssued
                                ? const Text('Issued')
                                : const Text('Not Issued'),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text('${_date.day}/${_date.month}/${_date.year}'),
                        const Spacer(),
                        ElevatedButton(
                          child: _isIssued
                              ? const Text('Return')
                              : const Text('Issue'),
                          onPressed: () => print(_isIssued),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(_image),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
